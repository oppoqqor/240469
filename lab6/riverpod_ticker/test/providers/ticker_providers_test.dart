import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_ticker/models/tick.dart';
import 'package:riverpod_ticker/providers/ticker_providers.dart';
import 'package:riverpod_ticker/services/tick_feed.dart';

void main() {
  test('tickerProvider loading and successful data', () async {
    final controller = StreamController<List<Tick>>();
    final container = ProviderContainer(
      overrides: [
        tickerProvider.overrideWith((ref) => controller.stream),
      ],
    );
    addTearDown(() {
      container.dispose();
      controller.close();
    });

    final sub = container.listen(tickerProvider, (_, _) {});
    addTearDown(sub.close);

    expect(container.read(tickerProvider).isLoading, isTrue);

    final ticks = [
      Tick(symbol: 'BTC', price: 50000, change: 10, at: DateTime.now()),
    ];
    controller.add(ticks);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(tickerProvider);
    expect(state.hasValue, isTrue);
    expect(state.value, ticks);
  });

  test('tickerProvider FeedException while previous data is retained', () async {
    final controller = StreamController<List<Tick>>();
    final container = ProviderContainer(
      overrides: [
        tickerProvider.overrideWith((ref) => controller.stream),
      ],
    );
    addTearDown(() {
      container.dispose();
      controller.close();
    });

    final sub = container.listen(tickerProvider, (_, _) {});
    addTearDown(sub.close);

    final ticks = [
      Tick(symbol: 'BTC', price: 50000, change: 10, at: DateTime.now()),
    ];
    controller.add(ticks);
    await Future<void>.delayed(Duration.zero);

    controller.addError(const FeedException('Feed disconnected'));
    await Future<void>.delayed(Duration.zero);

    final state = container.read(tickerProvider);
    expect(state.hasError, isTrue);
    expect(state.error, isA<FeedException>());
    expect(state.value, ticks);
  });
}
