import 'package:flutter/material.dart';
import '../services/classifier.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({
    super.key,
    required this.history,
    required this.onSelect,
  });

  final List<ClassificationRecord> history;
  final void Function(ClassificationRecord record) onSelect;

  IconData _sourceIcon(String source) => switch (source) {
        'Camera' => Icons.camera_alt_outlined,
        'Gallery' => Icons.photo_library_outlined,
        'Download' => Icons.cloud_download_outlined,
        _ => Icons.image_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;

    if (history.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history, size: 56, color: colors.outline),
              const SizedBox(height: 16),
              Text('No classifications yet', style: text.titleLarge),
              const SizedBox(height: 8),
              Text(
                'Classify a photo from the camera, gallery, or a URL on the Home tab to see it here.',
                textAlign: TextAlign.center,
                style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = history[index];
        final pct = '${(item.top.confidence * 100).toStringAsFixed(1)} %';
        return Card(
          child: ListTile(
            onTap: () => onSelect(item),
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(item.bytes, width: 56, height: 56, fit: BoxFit.cover),
            ),
            title: Text(item.top.label, style: text.titleMedium),
            subtitle: Text('$pct - ${item.source}',
                style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
            trailing: Icon(_sourceIcon(item.source), color: colors.primary),
          ),
        );
      },
    );
  }
}
