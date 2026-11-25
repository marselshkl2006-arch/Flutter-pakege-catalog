import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/models/crate.dart';

class DetailScreen extends StatelessWidget {
  final String id;
  const DetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // В реальном проекте здесь был бы DetailCubit, который грузит данные по id.
    // Для простоты берем мок напрямую.
    final mockCrate = Crate(id: id, version: '2.0.0', description: 'Детали', downloads: 1000);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.detailsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(), // Возврат по стеку
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${mockCrate.id}', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Версия: ${mockCrate.version}'),
            const SizedBox(height: 8),
            Text(mockCrate.description),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/details/$id/related'),
              child: const Text('Связанная запись'),
            ),
          ],
        ),
      ),
    );
  }
}
