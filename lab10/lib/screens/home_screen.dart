import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../services/classifier.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.latestRecord,
    required this.isDownloading,
    required this.onCamera,
    required this.onGallery,
    required this.onDownloadUrl,
    required this.onRunSample,
    required this.onTestBadBytes,
    required this.onOpenResult,
  });

  final ClassificationRecord? latestRecord;
  final bool isDownloading;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final Future<void> Function(String url) onDownloadUrl;
  final VoidCallback onRunSample;
  final VoidCallback onTestBadBytes;
  final void Function(ClassificationRecord record) onOpenResult;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();
  bool _showUrlField = false;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _fillSampleCatUrl() {
    _urlController.text = Uri.https(
      'upload.wikimedia.org',
      '/wikipedia/commons/thumb/3/3a/Cat03.jpg/320px-Cat03.jpg',
    ).toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;
    final latest = widget.latestRecord;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Classify an image', style: text.titleLarge),
        const SizedBox(height: 6),
        Text(
          'Pick a source below. Every image runs through the same local classifier.',
          style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        _ActionCard(
          icon: Icons.camera_alt_outlined,
          title: 'Take a photo',
          subtitle: 'Capture an object using your camera',
          onTap: widget.isDownloading ? null : widget.onCamera,
        ),
        const SizedBox(height: 12),
        _ActionCard(
          icon: Icons.photo_library_outlined,
          title: 'Choose from gallery',
          subtitle: 'Select an existing photo or screenshot',
          onTap: widget.isDownloading ? null : widget.onGallery,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => setState(() => _showUrlField = !_showUrlField),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: colors.secondaryContainer,
                        foregroundColor: colors.onSecondaryContainer,
                        child: const Icon(Icons.cloud_download_outlined),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Download an image', style: text.titleMedium),
                            const SizedBox(height: 2),
                            Text(
                              'Fetch image bytes from an http or https URL',
                              style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      Icon(_showUrlField ? Icons.expand_less : Icons.expand_more),
                    ],
                  ),
                ),
                if (_showUrlField) ...[
                  const SizedBox(height: 14),
                  TextField(
                    controller: _urlController,
                    keyboardType: TextInputType.url,
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                      hintText: 'Enter direct image link',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [
                      ActionChip(
                        label: const Text('Use sample cat URL'),
                        onPressed: widget.isDownloading ? null : _fillSampleCatUrl,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (widget.isDownloading) const LinearProgressIndicator(),
                  if (widget.isDownloading) const SizedBox(height: 10),
                  FilledButton.icon(
                    onPressed: widget.isDownloading
                        ? null
                        : () => widget.onDownloadUrl(_urlController.text),
                    icon: const Icon(Icons.download),
                    label: Text(widget.isDownloading ? 'Downloading...' : 'Download & classify'),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: widget.onRunSample,
                child: const Text('Test sample.jpg'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: widget.onTestBadBytes,
                child: const Text('Test bad input'),
              ),
            ),
          ],
        ),
        if (latest != null) ...[
          const SizedBox(height: 24),
          Text('Most recent result', style: text.titleLarge),
          const SizedBox(height: 10),
          _LatestCard(record: latest, onTap: () => widget.onOpenResult(latest)),
        ],
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: colors.primaryContainer,
                foregroundColor: colors.onPrimaryContainer,
                child: Icon(icon),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: text.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _LatestCard extends StatelessWidget {
  const _LatestCard({required this.record, required this.onTap});

  final ClassificationRecord record;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;
    final Uint8List bytes = record.bytes;
    final percent = '${(record.top.confidence * 100).toStringAsFixed(1)} %';

    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.memory(bytes, width: 56, height: 56, fit: BoxFit.cover),
        ),
        title: Text(record.top.label, style: text.titleMedium),
        subtitle: Text('${record.source} - $percent',
            style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
        trailing: const Icon(Icons.open_in_new),
      ),
    );
  }
}
