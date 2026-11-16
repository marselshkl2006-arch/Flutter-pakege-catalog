import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_strings.dart';
import '../../model/crate_detail.dart';
import '../common/error_message.dart';
import '../common/format.dart';
import '../common/loading_indicator.dart';
import 'detail_state.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    super.key,
    required this.state,
    required this.onBack,
    required this.onDependencies,
    required this.onOwner,
    required this.onRetry,
  });

  final DetailState state;
  final VoidCallback onBack;
  final VoidCallback onDependencies;
  final ValueChanged<String> onOwner;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final detail = state.crate;
        return Scaffold(
          appBar: AppBar(title: Text(detail?.crate.name ?? s.loading)),
          body: detail != null
              ? _Content(detail: detail, onBack: onBack, onDependencies: onDependencies, onOwner: onOwner)
              : state.error != null
                  ? Center(child: ErrorMessage(message: state.error!, onRetry: onRetry))
                  : const Center(child: LoadingIndicator()),
        );
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.detail, required this.onBack, required this.onDependencies, required this.onOwner});

  final CrateDetail detail;
  final VoidCallback onBack;
  final VoidCallback onDependencies;
  final ValueChanged<String> onOwner;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final theme = Theme.of(context);
    final crate = detail.crate;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(crate.name, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 12),
          Text('${s.version}: ${crate.version}', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Text(crate.description ?? s.descriptionMissing, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 12),
          Text('${s.downloads}: ${formatNumber(crate.downloads)}'),
          if (crate.repository != null) _LinkRow(label: s.repository, url: crate.repository!),
          if (crate.documentation != null) _LinkRow(label: s.documentation, url: crate.documentation!),
          if (detail.versions.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(s.versions, style: theme.textTheme.titleSmall),
            for (final v in detail.versions.take(5))
              Text(
                '${v.number} - ${formatNumber(v.downloads)}',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton(onPressed: onDependencies, child: Text(s.dependencies)),
              for (final o in detail.owners)
                OutlinedButton(onPressed: () => onOwner(o.login), child: Text('${s.owner}: ${o.login}')),
              TextButton(onPressed: onBack, child: Text(s.back)),
            ],
          ),
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.label, required this.url});

  final String label;
  final String url;

  Future<void> _open() async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      // No browser available: ignore.
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 4,
        children: [
          Text('$label:'),
          InkWell(
            onTap: _open,
            child: Text(
              url,
              style: TextStyle(color: theme.colorScheme.primary, decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }
}
