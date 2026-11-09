import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cart.dart';
import '../services/checkout_api.dart';
import 'cart_event.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this._api) : super(const CartState()) {
    on<CartProductAdded>(_onSync);
    on<CartProductRemoved>(_onSync);
    on<CartQtyChanged>(_onSync);
    on<CartCouponApplied>(_onSync);
    on<CartUndone>(_onSync);
    on<CartCheckoutRequested>(_onCheckout, transformer: droppable());
  }

  final CheckoutApi _api;

  void _onSync(CartEvent event, Emitter<CartState> emit) => emit(switch (event) {
        CartProductAdded(:final product) => state.withAdded(product),
        CartProductRemoved(:final productId) => state.withRemoved(productId),
        CartQtyChanged(:final productId, :final delta) => state.withQty(productId, delta),
        CartCouponApplied(:final code) => state.withCoupon(code),
        CartUndone() => state.withUndone(),
        CartCheckoutRequested() => state,
      });

  Future<void> _onCheckout(CartCheckoutRequested event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CheckoutStatus.submitting));
    try {
      final orderId = await _api.submit(state.total);
      if (emit.isDone) return;
      emit(const CartState(status: CheckoutStatus.success).copyWith(orderId: () => orderId));
    } on CheckoutException catch (e) {
      if (emit.isDone) return;
      emit(state.copyWith(status: CheckoutStatus.failure, checkoutError: () => e.message));
    }
  }
}
