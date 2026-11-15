# Lab 9 Notes: One Cart, Four Ways

## Comparison Table

| Style | Files | Lines (T1-T5) | Test Lines | One Strength | One Weakness |
| :--- | :---: | :---: | :---: | :--- | :--- |
| setState | 1 | 73 | 21 | Built into Flutter, no extra packages or setup needed | State dies when the page is popped and callbacks must be passed by hand |
| Riverpod | 2 | 107 | 46 | State lives outside the widget tree and unit tests run in `ProviderContainer` with no UI | Extra concepts to keep track of (`WidgetRef`, `autoDispose`, `select`) |
| Cubit | 2 | 83 | 42 | Simple method calls that emit new states; `blocTest` checks exact state lists | Scoped to `BuildContext`, so `BlocProvider` must sit above every reader |
| Bloc | 3 | 124 | 61 | Every change maps to a named `CartEvent` in logs and `droppable()` stops double taps | Most files and boilerplate for simple actions like +1 / -1 |

---

## Checkpoint Questions

1. **Where does state live and when does it die in each style?**
   - `setState`: Lives in `_SetStateCartPageState` inside the widget tree. Dies as soon as the page is popped.
   - `Riverpod`: Lives in the root `ProviderContainer`. Because `cartProvider` uses `NotifierProvider.autoDispose`, it dies when the page is popped (without `autoDispose`, it would stay alive app-wide).
   - `Cubit`: Lives in the `CartCubit` instance owned by `BlocProvider`. Dies when `BlocProvider` closes on page pop.
   - `Bloc`: Lives in the `CartBloc` instance owned by `BlocProvider`. Dies when `BlocProvider` closes on page pop.

2. **What is the single public mutation API in Riverpod, Cubit, and Bloc? Which style has none?**
   - `Riverpod`: Public methods on `CartNotifier` reached through `ref.read(cartProvider.notifier)`.
   - `Cubit`: Public methods on `CartCubit` (`add`, `remove`, `changeQty`, `applyCoupon`, `undo`, `checkout`).
   - `Bloc`: `bloc.add(CartEvent)` is the only public way to trigger a change.
   - `setState` has no public mutation API -- `_state` and `setState` are private to `_SetStateCartPageState`.

3. **Map `ref.watch` / `ref.read` / `ref.listen` vs `BlocBuilder` / `context.read` / `BlocListener`. Where does `setState` fit?**
   - `ref.watch` <-> `BlocBuilder` / `BlocSelector` (subscribes and rebuilds when state changes).
   - `ref.read` <-> `context.read` (one-off lookup inside callbacks, no rebuild subscription).
   - `ref.listen` <-> `BlocListener` (runs side effects like `SnackBar` and `MaterialBanner` without rebuilding).
   - `setState` does not split reading from subscribing; calling `setState` marks the whole widget dirty and re-runs `build` with the new `_state`.

4. **Why do Riverpod, Cubit, and Bloc skip notifying when `newState == oldState`, and what two things must `CartState` do for this?**
   - Skipping equal states avoids extra rebuilds and listener triggers when nothing actually changed (like applying the same invalid coupon twice).
   - `CartState` must: (1) stay immutable (`final` fields, returning new instances via `copyWith`), and (2) override `operator ==` and `hashCode` (using `listEquals` on `lines`) so equality compares values instead of object references.

5. **After `await` in checkout, what guard did each style need and why do they differ?**
   - `setState`: `if (!mounted) return;` because calling `setState` or reading `context` after the widget unmounts throws a `FlutterError`.
   - `Riverpod`: No guard needed in `CartNotifier.checkout()` because state sits in `ProviderContainer` outside the widget tree, and `ref.listen` on the page stops listening automatically when the page unmounts.
   - `Cubit`: `if (isClosed) return;` because `BlocProvider` calls `close()` when the page pops, and calling `emit` after `close()` throws a `StateError`.
   - `Bloc`: `if (emit.isDone) return;` because the event handler's `Emitter` finishes when the bloc is closed.

---

## Inline Questions (Parts 1-5)

### Part 1: Shared Code
- **Why is `CartLine` immutable with `copyWith`? Which style still works with mutation, and why is that a trap?**
  - Plain `setState` still works if you mutate `qty` in place because `setState` always forces a rebuild. That is a trap in Riverpod, Cubit, and Bloc: if you mutate the same object and emit/assign it back, `oldState == newState` is `true`, so they drop the update and the UI never refreshes.
- **Why does `CartBody` take callbacks instead of importing a provider or bloc directly?**
  - Keeping `CartBody` dumb lets all four pages reuse the exact same UI widget without coupling it to Riverpod or `flutter_bloc`.

### Part 2: setState
- **Why must `total`, `discount`, and `subtotal` be getters on `CartState` rather than stored fields?**
  - Storing `total` means every method that touches `lines` or `coupon` has to remember to recalculate it. Keeping them as getters guarantees they never drift out of sync.
- **What happens without `if (!mounted) return;` after `await`?**
  - Popping the page during the 1.5 s delay disposes `_SetStateCartPageState`, and calling `setState` or `ScaffoldMessenger.of(context)` after dispose crashes with `setState() called after dispose()`.
- **How would a second page read the cart after T4?**
  - You would have to lift `_state` and the mutators up above `Navigator` (for example into `HomePage` or an `InheritedWidget`) and pass them down to both pages.
- **Where does `_history` live, and what happens on hot reload vs hot restart?**
  - It lives in `_SetStateCartPageState` in RAM. Hot reload keeps `_history` intact; hot restart (or popping the page) wipes it back to empty.

### Part 3: Riverpod
- **Name the three places `ref.read` was used and the two places `ref.watch` was used.**
  - `ref.read`: (1) getting `cartProvider.notifier` in `RiverpodCartPage` for callbacks, (2) reading `checkoutApiProvider` inside `CartNotifier.checkout()`, (3) reading `cartProvider` inside `ref.listen` and `_RiverpodSummaryCard` after `.select` already triggered the rebuild.
  - `ref.watch`: (1) watching `cartProvider` and `canUndoProvider` in `RiverpodCartPage.build`, (2) watching `cartProvider.select((s) => s.total)` in `_RiverpodSummaryCard.build`.
- **Why does `_RiverpodSummaryCard` rebuild less often than the `setState` summary card?**
  - In `setState`, any state change re-runs the whole page `build`. In Riverpod, `select((s) => s.total)` only triggers `_RiverpodSummaryCard` when `total` changes, ignoring `couponError` or `status` updates.
- **What happened to `_history` when `cartProvider` became `autoDispose` and we popped the page?**
  - Riverpod disposed `CartNotifier` when no widget was watching it, clearing `_history`. Coming back to the page calls `build()` fresh with an empty cart and empty history.

### Part 4: Cubit
- **What would break if you put `BlocProvider` inside `CartBody`?**
  - The `AppBar` undo button and `BlocListener` wrap `CartBody` above it in the tree, so `context.read<CartCubit>()` and `BlocBuilder` would throw `ProviderNotFoundException`.
- **Give the Riverpod equivalent of `BlocProvider`, `BlocBuilder`, `BlocListener`, `context.read`, `buildWhen`:**
  - `BlocProvider` <-> `ProviderScope` + `NotifierProvider`
  - `BlocBuilder` <-> `ConsumerWidget` + `ref.watch`
  - `BlocListener` <-> `ref.listen`
  - `context.read` <-> `ref.read`
  - `buildWhen` <-> `provider.select(...)`

### Part 5: Bloc
- **What extra information does `BlocObserver.onTransition` give compared to Cubit's `onChange`?**
  - `onChange` only shows `currentState -> nextState`. `onTransition` also includes `transition.event`, so you can trace which user action (`CartProductAdded`, `CartCouponApplied`, etc.) caused the change.
- **Where is Bloc clearly better than Cubit, and where is it pure overhead?**
  - Better: async concurrency control (`transformer: droppable()` on checkout) and exhaustive `switch` over sealed events for undoable actions.
  - Overhead: simple synchronous mutations like `CartQtyChanged` where a single cubit method call does the same job without an extra event class.
- **Which style implements "drop duplicate taps" declaratively, and how do you do it in the others?**
  - Only `Bloc` does it declaratively with `transformer: droppable()`. In `setState`, `Riverpod`, and `Cubit`, you guard manually at the top of `checkout()` with `if (state.status == CheckoutStatus.submitting) return;` or disable the button while submitting.
