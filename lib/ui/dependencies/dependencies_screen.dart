import 'package:flutter/material.dart';

import '../../l10n/app_strings.dart';
import '../common/error_message.dart';
import '../common/loading_indicator.dart';
import 'dependencies_state.dart';

class DependenciesScreen extends StatelessWidget {
  const DependenciesScreen({
    super.key,
    required this.crateName,
    required this.state,
    required this.onBack,
    required this.onDependencyClick,
    required this.onRetry,
  });

  final String crateName;
  final DependenciesState state;
  final VoidCallback onBack;
  final ValueChanged<String> onDependencyClick;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${s.dependencies}: $crateName'),
        actions: [TextButton(onPressed: onBack, child: Text(s.back))],
      ),
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          if (state.error != null && state.dependencies.isEmpty) {
            return Center(child: ErrorMessage(message: state.error!, onRetry: onRetry));
          }
          if (state.isLoading) return const Center(child: LoadingIndicator());
          if (state.dependencies.isEmpty) {
            return Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(s.noDependencies)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.dependencies.length,
            itemBuilder: (context, i) {
              final dep = state.dependencies[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => onDependencyClick(dep),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(dep, style: Theme.of(context).textTheme.titleMedium),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
