import 'package:flutter/material.dart';
import '../services/classifier.dart';

class ModelScreen extends StatelessWidget {
  const ModelScreen({super.key, required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Model Info', style: text.titleLarge),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(label: 'Model file', value: Classifier.modelAssetPath),
                const Divider(height: 20),
                _InfoRow(label: 'Labels file', value: Classifier.labelsAssetPath),
                const Divider(height: 20),
                _InfoRow(label: 'Classes', value: '${labels.length}'),
                const Divider(height: 20),
                const _InfoRow(
                  label: 'Input tensor',
                  value: '${Classifier.inputSize} x ${Classifier.inputSize} x 3 (float32)',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text('Labels (${labels.length})', style: text.titleLarge),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < labels.length; i++)
              Chip(label: Text('$i - ${labels[i]}')),
          ],
        ),
        const SizedBox(height: 20),
        Text('Design Credit', style: text.titleLarge),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Material 3 Mobile App UI Kit', style: text.titleMedium),
                const SizedBox(height: 4),
                Text(
                  'Author: Material Design Team (Figma Community)',
                  style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                ),
                const SizedBox(height: 2),
                Text(
                  'Source: figma.com/community/file/1035203688168086460',
                  style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                ),
                const SizedBox(height: 2),
                Text(
                  'Licence: CC BY 4.0',
                  style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(label, style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
        ),
        Expanded(child: Text(value, style: text.bodyLarge)),
      ],
    );
  }
}
