import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
    required this.isLoading,
    required this.labels,
    required this.loadError,
    required this.onGetStarted,
    required this.onRetry,
  });

  final bool isLoading;
  final List<String> labels;
  final String? loadError;
  final VoidCallback onGetStarted;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;
    final displayLabels = labels.isNotEmpty
        ? labels
        : const ['cat', 'hiding person', 'notebook', 'keyboard', 'Davron', 'nothing'];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.center_focus_strong_outlined,
                  size: 36,
                  color: colors.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 20),
              Text('LabLens Classifier', style: text.headlineMedium),
              const SizedBox(height: 10),
              Text(
                'Recognises six everyday lab objects offline using your own TensorFlow Lite model.',
                style: text.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              Text('Trained classes', style: text.labelLarge),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final label in displayLabels) Chip(label: Text(label)),
                ],
              ),
              const Spacer(),
              if (isLoading)
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                    const SizedBox(width: 12),
                    Text('Loading model and labels...', style: text.bodyMedium),
                  ],
                )
              else if (loadError != null)
                Card(
                  color: colors.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          loadError!,
                          style: text.bodyMedium?.copyWith(color: colors.onErrorContainer),
                        ),
                        const SizedBox(height: 12),
                        FilledButton(onPressed: onRetry, child: const Text('Retry load')),
                      ],
                    ),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onGetStarted,
                    child: const Text('Get started'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
