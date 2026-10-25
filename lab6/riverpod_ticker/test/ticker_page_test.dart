import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_ticker/models/tick.dart';
import 'package:riverpod_ticker/providers/ticker_providers.dart';
import 'package:riverpod_ticker/services/tick_feed.dart';
import 'package:riverpod_ticker/ticker_page.dart';

void main() {
  testWidgets('Initial loading spinner', (tester) async {
    final controller = StreamController<List<Tick>>();
    addTearDown(controller.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tickerProvider.overrideWith((ref) => controller.stream),
        ],
        child: const MaterialApp(home: TickerPage()),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Successful ticker data display', (tester) async {
    final ticks = [
      Tick(symbol: 'BTC', price: 50000, change: 10, at: DateTime.now()),
      Tick(symbol: 'ETH', price: 3000, change: -5, at: DateTime.now()),
      Tick(symbol: 'SOL', price: 150, change: 2, at: DateTime.now()),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tickerProvider.overrideWith((ref) => Stream.value(ticks)),
        ],
        child: const MaterialApp(home: TickerPage()),
      ),
    );
    await tester.pump();

    expect(find.text('BTC'), findsOneWidget);
    expect(find.text('ETH'), findsOneWidget);
    expect(find.text('SOL'), findsOneWidget);
  });

  testWidgets('Error without previous data, including Retry', (tester) async {
    var retried = false;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tickerProvider.overrideWith((ref) {
            if (retried) {
              return Stream.value([
                Tick(symbol: 'BTC', price: 50000, change: 10, at: DateTime.now()),
              ]);
            }
            return Stream.error(const FeedException('Initial failure'));
          }),
        ],
        child: const MaterialApp(home: TickerPage()),
      ),
    );
    await tester.pump();

    expect(find.textContaining('Could not load ticker'), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);

    retried = true;
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    await tester.pump();

    expect(find.text('BTC'), findsOneWidget);
  });

  testWidgets('Error after previous data, showing the MaterialBanner and BTC row', (tester) async {
    final controller = StreamController<List<Tick>>();
    addTearDown(controller.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tickerProvider.overrideWith((ref) => controller.stream),
        ],
        child: const MaterialApp(home: TickerPage()),
      ),
    );

    final ticks = [
      Tick(symbol: 'BTC', price: 50000, change: 10, at: DateTime.now()),
    ];
    controller.add(ticks);
    await tester.pump();

    expect(find.text('BTC'), findsOneWidget);

    controller.addError(const FeedException('Feed disconnected'));
    await tester.pump();

    expect(find.byType(MaterialBanner), findsOneWidget);
    expect(find.text('BTC'), findsOneWidget);
  });
}
