import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cart/models/cart.dart';
import 'package:cart/riverpod/cart_notifier.dart';
import 'package:cart/services/checkout_api.dart';

class MockCheckoutApi extends Mock implements CheckoutApi {}

void main() {
  test('add twice and apply SAVE10 gives total 88.2', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final sub = container.listen(cartProvider, (_, __) {});
    addTearDown(sub.close);

    final notifier = container.read(cartProvider.notifier);
    notifier.add(catalog.first);
    notifier.add(catalog.first);
    notifier.applyCoupon('SAVE10');

    expect(container.read(cartProvider).total, closeTo(88.2, 0.001));
  });

  test('checkout failure keeps lines and sets status to failure', () async {
    final mockApi = MockCheckoutApi();
    when(() => mockApi.submit(any())).thenThrow(const CheckoutException('Card declined'));

    final container = ProviderContainer(
      overrides: [checkoutApiProvider.overrideWithValue(mockApi)],
    );
    addTearDown(container.dispose);

    final sub = container.listen(cartProvider, (_, __) {});
    addTearDown(sub.close);

    final notifier = container.read(cartProvider.notifier);
    notifier.add(catalog.first);
    await notifier.checkout();

    final state = container.read(cartProvider);
    expect(state.status, CheckoutStatus.failure);
    expect(state.lines, isNotEmpty);
  });
}
