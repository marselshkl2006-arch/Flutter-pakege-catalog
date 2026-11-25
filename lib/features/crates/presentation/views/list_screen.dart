import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../features/settings/presentation/cubit/settings_cubit.dart';
import '../cubit/list_cubit.dart';
import '../cubit/list_state.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          // Кнопка смены темы
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              final isDark = state.themeMode == ThemeMode.dark;
              return IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () => context.read<SettingsCubit>().toggleTheme(),
              );
            },
          ),
          // Кнопка смены языка
          TextButton(
            onPressed: () => context.read<SettingsCubit>().toggleLanguage(),
            child: const Text('RU/EN'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: l10n.searchHint,
                border: const OutlineInputBorder(),
              ),
              onChanged: (val) => context.read<ListCubit>().search(val),
            ),
          ),
          Expanded(
            child: BlocBuilder<ListCubit, ListState>(
              builder: (context, state) {
                if (state is ListLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ListError) {
                  return const Center(child: Text("Error"));
                }
                if (state is ListLoaded) {
                  if (state.filteredCrates.isEmpty) {
                    return Center(child: Text(l10n.noResults));
                  }
                  // Адаптив: на широком экране 3 колонки, на узком — 1
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      int columns = constraints.maxWidth > 600 ? 3 : 1;
                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 120, // Фиксированная высота, чтобы не было overflow
                        ),
                        itemCount: state.filteredCrates.length,
                        itemBuilder: (context, index) {
                          final crate = state.filteredCrates[index];
                          return Card(
                            elevation: 2,
                            child: InkWell(
                              onTap: () => context.go('/details/${crate.id}'),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(crate.id, style: Theme.of(context).textTheme.titleLarge),
                                    const SizedBox(height: 8),
                                    Text(
                                      crate.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
