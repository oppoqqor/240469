import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cart/bloc/cart_bloc.dart';
import 'package:cart/bloc/cart_event.dart';
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

  blocTest<CartBloc, CartState>(
    'emits three states when adding keyboard twice and applying SAVE10',
    build: () => CartBloc(mockApi),
    act: (b) => b
      ..add(CartProductAdded(keyboard))
      ..add(CartProductAdded(keyboard))
      ..add(const CartCouponApplied('SAVE10')),
    expect: () => [s1, s2, s3],
  );

  blocTest<CartBloc, CartState>(
    'emits submitting then failure when checkout throws',
    setUp: () => when(() => mockApi.submit(any())).thenThrow(const CheckoutException('Card declined')),
    build: () => CartBloc(mockApi),
    seed: () => s1,
    act: (b) => b.add(const CartCheckoutRequested()),
    expect: () => [
      s1.copyWith(status: CheckoutStatus.submitting),
      s1.copyWith(status: CheckoutStatus.failure, checkoutError: () => 'Card declined'),
    ],
  );

  blocTest<CartBloc, CartState>(
    'drops duplicate CartCheckoutRequested thanks to droppable()',
    setUp: () => when(() => mockApi.submit(any())).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      return 'ORD-1';
    }),
    build: () => CartBloc(mockApi),
    seed: () => s1,
    act: (b) => b
      ..add(const CartCheckoutRequested())
      ..add(const CartCheckoutRequested()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      s1.copyWith(status: CheckoutStatus.submitting),
      const CartState(status: CheckoutStatus.success).copyWith(orderId: () => 'ORD-1'),
    ],
    verify: (_) => verify(() => mockApi.submit(any())).called(1),
  );
}
