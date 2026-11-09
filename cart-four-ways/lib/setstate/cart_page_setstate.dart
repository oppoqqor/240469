import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../services/checkout_api.dart';
import '../widgets/cart_body.dart';

class SetStateCartPage extends StatefulWidget {
  const SetStateCartPage({super.key});
  @override
  State<SetStateCartPage> createState() => _SetStateCartPageState();
}

class _SetStateCartPageState extends State<SetStateCartPage> {
  CartState _state = const CartState();
  final _history = <CartState>[];
  final _api = CheckoutApi();

  void _mutate(CartState next) => setState(() {
        _history.add(_state);
        _state = next;
      });

  void _add(Product p) => _mutate(_state.copyWith(lines: _state.lines.withProduct(p)));
  void _remove(String id) => _mutate(_state.copyWith(lines: _state.lines.without(id)));
  void _changeQty(String id, int delta) =>
      _mutate(_state.copyWith(lines: _state.lines.changeQty(id, delta)));

  void _applyCoupon(String code) {
    final c = code.trim();
    _mutate(c == 'SAVE10'
        ? _state.copyWith(coupon: () => 'SAVE10', couponError: () => null)
        : _state.copyWith(coupon: () => null, couponError: () => 'Invalid coupon'));
  }

  void _undo() {
    if (_history.isEmpty) return;
    setState(() => _state = _history.removeLast());
  }

  Future<void> _checkout() async {
    setState(() => _state = _state.copyWith(status: CheckoutStatus.submitting));
    try {
      final orderId = await _api.submit(_state.total);
      if (!mounted) return;
      setState(() => _state = const CartState(status: CheckoutStatus.success).copyWith(orderId: () => orderId));
      handleCheckoutEffect(context, _state);
    } on CheckoutException catch (e) {
      if (!mounted) return;
      setState(() => _state = _state.copyWith(status: CheckoutStatus.failure, checkoutError: () => e.message));
      handleCheckoutEffect(context, _state);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Cart · setState'),
          actions: [
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: _history.isEmpty ? null : _undo,
            ),
          ],
        ),
        body: CartBody(
          state: _state,
          onAdd: _add,
          onRemove: _remove,
          onQtyChanged: _changeQty,
          onApplyCoupon: _applyCoupon,
          onCheckout: _checkout,
        ),
      );
}
