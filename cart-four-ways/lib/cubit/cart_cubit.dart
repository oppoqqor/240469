import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cart.dart';
import '../services/checkout_api.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._api) : super(const CartState());
  final CheckoutApi _api;

  @override
  void onChange(Change<CartState> change) {
    super.onChange(change);
    debugPrint('Cubit change: ${change.currentState.total} -> ${change.nextState.total}');
  }

  void add(Product p) => emit(state.withAdded(p));
  void remove(String id) => emit(state.withRemoved(id));
  void changeQty(String id, int delta) => emit(state.withQty(id, delta));
  void applyCoupon(String code) => emit(state.withCoupon(code));
  void undo() => emit(state.withUndone());

  Future<void> checkout() async {
    emit(state.copyWith(status: CheckoutStatus.submitting));
    try {
      final orderId = await _api.submit(state.total);
      if (isClosed) return;
      emit(const CartState(status: CheckoutStatus.success).copyWith(orderId: () => orderId));
    } on CheckoutException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(status: CheckoutStatus.failure, checkoutError: () => e.message));
    }
  }
}
