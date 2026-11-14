import 'package:flutter/material.dart';

import '../../l10n/app_strings.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(AppStrings.of(context).loading, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
