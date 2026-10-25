import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/ticker_providers.dart';
import 'widgets/tick_row.dart';

class TickerPage extends ConsumerWidget {
  const TickerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticks = ref.watch(tickerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live ticker'),
        actions: [
          IconButton(
            tooltip: 'Simulate feed error after 5 ticks',
            onPressed: () {
              ref.read(failAfterProvider.notifier).set(5);
            },
            icon: const Icon(Icons.warning_amber),
          ),
          IconButton(
            tooltip: 'Restore live feed',
            onPressed: () {
              ref.read(failAfterProvider.notifier).set(null);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: switch (ticks) {
        // Part 4: an error occurred, but previous data exists.
        AsyncError(:final error, :final value?) => Column(
            children: [
              MaterialBanner(
                content: Text(
                  'Feed error: $error — showing last prices',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      ref.read(failAfterProvider.notifier).set(null);
                      ref.invalidate(tickerProvider);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
              Expanded(
                child: Opacity(
                  opacity: 0.5,
                  child: ListView(
                    children: [
                      for (final tick in value)
                        TickRow(tick, key: ValueKey(tick.symbol)),
                    ],
                  ),
                ),
              ),
            ],
          ),

        // Part 4: an error occurred before any data arrived.
        AsyncError(:final error) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Could not load ticker\n$error',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () {
                    ref.read(failAfterProvider.notifier).set(null);
                    ref.invalidate(tickerProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),

        // Part 4: reload/refresh while previous data exists.
        AsyncValue(:final value?, isLoading: true) => Column(
            children: [
              const LinearProgressIndicator(),
              Expanded(
                child: ListView(
                  children: [
                    for (final tick in value)
                      TickRow(tick, key: ValueKey(tick.symbol)),
                  ],
                ),
              ),
            ],
          ),

        // Part 3: no subscribed symbols.
        AsyncData(value: []) =>
          const Center(child: Text('No symbols subscribed')),

        // Part 3: exactly one symbol.
        AsyncData(value: [final only]) => Center(
            child: TickRow(only),
          ),

        // Part 3: normal data.
        AsyncData(:final value) => RefreshIndicator(
            onRefresh: () => ref.refresh(tickerProvider.future),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                for (final tick in value)
                  TickRow(tick, key: ValueKey(tick.symbol)),
              ],
            ),
          ),

        // Part 3: first load.
        AsyncLoading() =>
          const Center(child: CircularProgressIndicator()),
      },
    );
  }
}