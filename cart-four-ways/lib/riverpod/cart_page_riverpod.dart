import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/cart_body.dart';
import 'cart_notifier.dart';

class RiverpodCartPage extends ConsumerWidget {
  const RiverpodCartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cartProvider);
    final canUndo = ref.watch(canUndoProvider);
    final cart = ref.read(cartProvider.notifier);

    ref.listen(
      cartProvider.select((s) => s.status),
      (prev, next) => handleCheckoutEffect(context, ref.read(cartProvider)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart · Riverpod'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: canUndo ? cart.undo : null,
          ),
        ],
      ),
      body: CartBody(
        state: state,
        onAdd: cart.add,
        onRemove: cart.remove,
        onQtyChanged: cart.changeQty,
        onApplyCoupon: cart.applyCoupon,
        onCheckout: cart.checkout,
        summaryCard: const _RiverpodSummaryCard(),
      ),
    );
  }
}

class _RiverpodSummaryCard extends ConsumerWidget {
  const _RiverpodSummaryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(cartProvider.select((s) => s.total));
    debugPrint('Riverpod SummaryCard rebuild');
    return SummaryCard(state: ref.read(cartProvider));
  }
}
