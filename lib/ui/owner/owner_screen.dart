import 'package:flutter/material.dart';

import '../../l10n/app_strings.dart';
import '../../model/owner.dart';
import '../common/error_message.dart';
import '../common/loading_indicator.dart';
import 'owner_state.dart';

class OwnerScreen extends StatelessWidget {
  const OwnerScreen({
    super.key,
    required this.login,
    required this.state,
    required this.onBack,
    required this.onRetry,
  });

  final String login;
  final OwnerState state;
  final VoidCallback onBack;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${s.owner}: $login'),
        actions: [TextButton(onPressed: onBack, child: Text(s.back))],
      ),
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          final owner = state.owner;
          if (owner != null) return Align(alignment: Alignment.topCenter, child: _OwnerContent(owner: owner));
          if (state.error != null) return Center(child: ErrorMessage(message: state.error!, onRetry: onRetry));
          return const Center(child: LoadingIndicator());
        },
      ),
    );
  }
}

class _OwnerContent extends StatelessWidget {
  const _OwnerContent({required this.owner});

  final Owner owner;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // The initial letter stays visible if the avatar cannot be loaded (offline, CORS on web).
          ClipOval(
            child: Container(
              width: 96,
              height: 96,
              color: theme.colorScheme.primaryContainer,
              alignment: Alignment.center,
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      owner.login.substring(0, 1).toUpperCase(),
                      style: theme.textTheme.headlineLarge?.copyWith(color: theme.colorScheme.onPrimaryContainer),
                    ),
                  ),
                  if (owner.avatar != null)
                    Image.network(
                      owner.avatar!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => const SizedBox.shrink(),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text('${s.login}: ${owner.login}', style: theme.textTheme.titleLarge),
          if (owner.name != null) ...[
            const SizedBox(height: 12),
            Text('${s.userName}: ${owner.name}', style: theme.textTheme.bodyLarge),
          ],
        ],
      ),
    );
  }
}
