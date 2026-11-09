import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart.dart';
import '../services/checkout_api.dart';

final checkoutApiProvider = Provider<CheckoutApi>((ref) => CheckoutApi());

class CartNotifier extends AutoDisposeNotifier<CartState> {
  final _history = <CartState>[];
  bool get hasHistory => _history.isNotEmpty;

  @override
  CartState build() {
    _history.clear();
    return const CartState();
  }

  void _mutate(CartState next) {
    _history.add(state);
    state = next;
  }

  void add(Product p) => _mutate(state.copyWith(lines: state.lines.withProduct(p)));
  void remove(String id) => _mutate(state.copyWith(lines: state.lines.without(id)));
  void changeQty(String id, int delta) =>
      _mutate(state.copyWith(lines: state.lines.changeQty(id, delta)));

  void applyCoupon(String code) {
    final c = code.trim();
    _mutate(c == 'SAVE10'
        ? state.copyWith(coupon: () => 'SAVE10', couponError: () => null)
        : state.copyWith(coupon: () => null, couponError: () => 'Invalid coupon'));
  }

  void undo() {
    if (_history.isEmpty) return;
    state = _history.removeLast();
  }

  Future<void> checkout() async {
    state = state.copyWith(status: CheckoutStatus.submitting);
    try {
      final orderId = await ref.read(checkoutApiProvider).submit(state.total);
      state = const CartState(status: CheckoutStatus.success).copyWith(orderId: () => orderId);
    } on CheckoutException catch (e) {
      state = state.copyWith(status: CheckoutStatus.failure, checkoutError: () => e.message);
    }
  }
}

final cartProvider = NotifierProvider.autoDispose<CartNotifier, CartState>(CartNotifier.new);

final canUndoProvider = Provider.autoDispose<bool>((ref) {
  ref.watch(cartProvider);
  return ref.read(cartProvider.notifier).hasHistory;
});
