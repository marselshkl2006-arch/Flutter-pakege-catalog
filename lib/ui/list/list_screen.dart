import 'package:flutter/material.dart';

import '../../l10n/app_strings.dart';
import '../../model/crate.dart';
import '../../state/favorites_state.dart';
import '../common/empty_state.dart';
import '../common/error_message.dart';
import '../common/format.dart';
import '../common/loading_indicator.dart';
import 'list_state.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({
    super.key,
    required this.state,
    required this.favoritesState,
    required this.language,
    required this.useMocks,
    required this.onQueryChange,
    required this.onItemClick,
    required this.onLoadMore,
    required this.onRetry,
    required this.onToggleTheme,
    required this.onToggleLanguage,
    required this.onToggleDataSource,
    required this.onOpenFavorites,
  });

  final ListState state;
  final FavoritesState favoritesState;
  final String language;
  final bool useMocks;
  final ValueChanged<String> onQueryChange;
  final ValueChanged<Crate> onItemClick;
  final VoidCallback onLoadMore;
  final VoidCallback onRetry;
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleDataSource;
  final VoidCallback onOpenFavorites;

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late final TextEditingController _search = TextEditingController(text: widget.state.query);
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_maybeLoadMore);
    widget.state.addListener(_scheduleCheck);
  }

  @override
  void dispose() {
    widget.state.removeListener(_scheduleCheck);
    _scroll.dispose();
    _search.dispose();
    super.dispose();
  }

  void _scheduleCheck() => WidgetsBinding.instance.addPostFrameCallback((_) => _maybeLoadMore());

  void _maybeLoadMore() {
    if (!mounted || !_scroll.hasClients) return;
    final s = widget.state;
    if (s.isLoading || s.endReached || s.error != null || s.crates.isEmpty) return;
    final p = _scroll.position;
    if (p.maxScrollExtent - p.pixels < 300) widget.onLoadMore();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.appTitle),
        actions: [
          // Кнопка перехода в избранное
          IconButton(
            icon: const Icon(Icons.star, color: Colors.amber),
            onPressed: widget.onOpenFavorites,
            tooltip: 'Избранное',
          ),
          TextButton(
            onPressed: widget.onToggleDataSource,
            child: Text(widget.useMocks ? s.dataSourceMock : s.dataSourceNetwork),
          ),
          TextButton(onPressed: widget.onToggleTheme, child: Text(s.themeToggle)),
          TextButton(onPressed: widget.onToggleLanguage, child: Text(widget.language == 'ru' ? 'EN' : 'RU')),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _search,
              onChanged: widget.onQueryChange,
              decoration: InputDecoration(labelText: s.searchHint, border: const OutlineInputBorder()),
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: widget.state,
              builder: (context, _) => _body(context, s),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, AppStrings s) {
    final state = widget.state;
    final visible = state.filtered;

    if (state.error != null && visible.isEmpty) {
      return Center(child: ErrorMessage(message: state.error!, onRetry: widget.onRetry));
    }
    if (state.isLoading && visible.isEmpty) return const Center(child: LoadingIndicator());
    if (visible.isEmpty) return const Center(child: EmptyState());

    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.all(16),
      itemCount: visible.length + (state.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= visible.length) return const LoadingIndicator();
        final crate = visible[index];
        return _CrateItem(
          crate: crate, 
          onTap: () => widget.onItemClick(crate),
          favoritesState: widget.favoritesState,
        );
      },
    );
  }
}

class _CrateItem extends StatelessWidget {
  const _CrateItem({required this.crate, required this.onTap, required this.favoritesState});

  final Crate crate;
  final VoidCallback onTap;
  final FavoritesState favoritesState;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('${crate.name}  ${crate.version}', style: theme.textTheme.titleMedium),
                  ),
                  // Звездочка для добавления в избранное
                  ListenableBuilder(
                    listenable: favoritesState,
                    builder: (context, _) {
                      final isFav = favoritesState.isFavorite(crate.name);
                      return IconButton(
                        icon: Icon(isFav ? Icons.star : Icons.star_border, color: Colors.amber),
                        onPressed: () => favoritesState.toggleFavorite(crate.name),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                crate.description ?? s.descriptionMissing,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                '${s.downloads}: ${formatNumber(crate.downloads)}',
                style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
