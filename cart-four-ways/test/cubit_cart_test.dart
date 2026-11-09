import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cart/cubit/cart_cubit.dart';
import 'package:cart/models/cart.dart';
import 'package:cart/services/checkout_api.dart';

class MockCheckoutApi extends Mock implements CheckoutApi {}

void main() {
  final keyboard = catalog.first;
  late MockCheckoutApi mockApi;

  setUp(() => mockApi = MockCheckoutApi());

  final s1 = const CartState().withAdded(keyboard);
  final s2 = s1.withAdded(keyboard);
  final s3 = s2.withCoupon('SAVE10');

  blocTest<CartCubit, CartState>(
    'emits three states when adding keyboard twice and applying SAVE10',
    build: () => CartCubit(mockApi),
    act: (c) {
      c.add(keyboard);
      c.add(keyboard);
      c.applyCoupon('SAVE10');
    },
    expect: () => [s1, s2, s3],
  );

  blocTest<CartCubit, CartState>(
    'emits submitting then failure when checkout throws',
    setUp: () => when(() => mockApi.submit(any())).thenThrow(const CheckoutException('Card declined')),
    build: () => CartCubit(mockApi),
    seed: () => s1,
    act: (c) => c.checkout(),
    expect: () => [
      s1.copyWith(status: CheckoutStatus.submitting),
      s1.copyWith(status: CheckoutStatus.failure, checkoutError: () => 'Card declined'),
    ],
  );
}
