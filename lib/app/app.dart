import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../data/crates_api.dart';
import '../data/crates_repository.dart';
import '../l10n/app_strings.dart';
import '../navigation/app_navigator.dart';
import '../navigation/screen.dart';
import '../state/app_state.dart';
import '../state/favorites_state.dart'; // <-- Импорт состояния избранного
import '../theme/app_theme.dart';
import '../ui/favorites/favorites_screen.dart'; // <-- Импорт экрана избранного
import '../ui/list/list_screen.dart';
import '../ui/list/list_state.dart';
import 'pages.dart';

class CratesCatalogApp extends StatefulWidget {
  const CratesCatalogApp({super.key, this.repository});

  final CratesRepository? repository;

  @override
  State<CratesCatalogApp> createState() => _CratesCatalogAppState();
}

class _CratesCatalogAppState extends State<CratesCatalogApp> {
  late final AppState _app = AppState(
    isDarkTheme: WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark,
  );
  final ListState _list = ListState();
  final FavoritesState _favoritesState = FavoritesState(); // <-- Создаем состояние
  final AppNavigator _nav = AppNavigator();
  late final CratesApi? _ownedApi;
  late final CratesRepository _repo;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (widget.repository != null) {
      _ownedApi = null;
      _repo = widget.repository!;
    } else {
      _ownedApi = CratesApi(client: createCratesClient());
      _repo = CratesRepository(api: _ownedApi!, useMocks: () => _app.useMocks);
    }
    _nav.routeFactory = _routeFor;
    _list.loadFirstPage(_repo);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ownedApi?.close();
    _list.dispose();
    _favoritesState.dispose(); // <-- Не забываем очищать память
    _app.dispose();
    super.dispose();
  }

  Route<void> _routeFor(Screen screen) => slideRoute(
        screen,
        (_) => switch (screen) {
          ListRoute() => _listPage(),
          DetailRoute(:final crateName) => DetailPage(crateName: crateName, repository: _repo, nav: _nav),
          DependenciesRoute(:final crateName) => DependenciesPage(crateName: crateName, repository: _repo, nav: _nav),
          OwnerRoute(:final login) => OwnerPage(login: login, repository: _repo, nav: _nav),
          FavoritesRoute() => _favoritesPage(), // <-- Добавляем маршрут
        },
      );

  Widget _listPage() => AppStateScope(
        app: _app,
        builder: (context, app) => ListScreen(
          state: _list,
          favoritesState: _favoritesState, // <-- Передаем состояние
          language: app.language,
          useMocks: app.useMocks,
          onOpenFavorites: () => _nav.navigateTo(const FavoritesRoute()), // <-- Кнопка перехода
          onQueryChange: (q) {
            _list.query = q;
            _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 300), () => _list.loadFirstPage(_repo));
          },
          onItemClick: (crate) => _nav.navigateTo(DetailRoute(crate.name)),
          onLoadMore: () => _list.loadNextPage(_repo),
          onRetry: () => _list.loadFirstPage(_repo),
          onToggleTheme: app.toggleTheme,
          onToggleLanguage: () => app.setLanguage(app.language == 'ru' ? 'en' : 'ru'),
          onToggleDataSource: () {
            app.toggleDataSource();
            _list.loadFirstPage(_repo);
          },
        ),
      );

  // Новый экран избранного
  Widget _favoritesPage() => AppStateScope(
        app: _app,
        builder: (context, app) => FavoritesScreen(
          favoritesState: _favoritesState,
          onCrateClick: (crateName) => _nav.navigateTo(DetailRoute(crateName)),
          onBack: () => _nav.goBack(), 
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _app,
      builder: (context, _) => MaterialApp(
        navigatorKey: _nav.key,
        navigatorObservers: [_nav],
        title: 'crates-catalog',
        debugShowCheckedModeBanner: false,
        locale: Locale(_app.language),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          AppStrings.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: buildAppTheme(Brightness.light),
        darkTheme: buildAppTheme(Brightness.dark),
        themeMode: _app.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
        home: _listPage(),
      ),
    );
  }
}
