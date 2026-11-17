import 'package:flutter/material.dart';
import '../services/classifier.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.record});

  final ClassificationRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;
    final maxImageHeight = MediaQuery.sizeOf(context).height * 0.42;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Chip(label: Text(record.source)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.outlineVariant),
            ),
            padding: const EdgeInsets.all(12),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxImageHeight),
                child: Image.memory(record.bytes, fit: BoxFit.contain),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Predictions', style: text.titleLarge),
          const SizedBox(height: 12),
          for (var i = 0; i < record.predictions.length; i++) ...[
            _PredictionRow(prediction: record.predictions[i], isTop: i == 0),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _PredictionRow extends StatelessWidget {
  const _PredictionRow({required this.prediction, required this.isTop});

  final Prediction prediction;
  final bool isTop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;
    final percent = '${(prediction.confidence * 100).toStringAsFixed(1)} %';

    return Card(
      color: isTop ? colors.primaryContainer : colors.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    prediction.label,
                    style: (isTop ? text.titleMedium : text.bodyLarge)?.copyWith(
                      color: isTop ? colors.onPrimaryContainer : colors.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  percent,
                  style: (isTop ? text.titleMedium : text.bodyMedium)?.copyWith(
                    color: isTop ? colors.onPrimaryContainer : colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: prediction.confidence.clamp(0.0, 1.0),
                minHeight: isTop ? 10 : 7,
                backgroundColor: isTop ? colors.surface : colors.surfaceContainerHighest,
                color: isTop ? colors.primary : colors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
