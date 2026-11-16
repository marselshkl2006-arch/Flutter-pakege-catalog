import 'package:flutter/material.dart';

import '../../l10n/app_strings.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(s.errorTitle, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.error)),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
          FilledButton(onPressed: onRetry, child: Text(s.errorRetry)),
        ],
      ),
    );
  }
}
