import 'package:flutter/material.dart';

import '../data/crates_repository.dart';
import '../navigation/app_navigator.dart';
import '../navigation/screen.dart';
import '../state/app_state.dart';
import '../ui/dependencies/dependencies_screen.dart';
import '../ui/dependencies/dependencies_state.dart';
import '../ui/detail/detail_screen.dart';
import '../ui/detail/detail_state.dart';
import '../ui/owner/owner_screen.dart';
import '../ui/owner/owner_state.dart';

/// Pages own the per-route state object and wire it to a screen: screens themselves only
/// receive state + callbacks.
class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.crateName, required this.repository, required this.nav});

  final String crateName;
  final CratesRepository repository;
  final AppNavigator nav;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final DetailState _state = DetailState();

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => _state.load(widget.repository, widget.crateName);

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DetailScreen(
        state: _state,
        onBack: widget.nav.goBack,
        onDependencies: () => widget.nav.navigateTo(DependenciesRoute(widget.crateName)),
        onOwner: (login) => widget.nav.navigateTo(OwnerRoute(login)),
        onRetry: _load,
      );
}

class DependenciesPage extends StatefulWidget {
  const DependenciesPage({super.key, required this.crateName, required this.repository, required this.nav});

  final String crateName;
  final CratesRepository repository;
  final AppNavigator nav;

  @override
  State<DependenciesPage> createState() => _DependenciesPageState();
}

class _DependenciesPageState extends State<DependenciesPage> {
  final DependenciesState _state = DependenciesState();

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => _state.load(widget.repository, widget.crateName);

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DependenciesScreen(
        crateName: widget.crateName,
        state: _state,
        onBack: widget.nav.goBack,
        onDependencyClick: (dep) => widget.nav.navigateTo(DetailRoute(dep)),
        onRetry: _load,
      );
}

class OwnerPage extends StatefulWidget {
  const OwnerPage({super.key, required this.login, required this.repository, required this.nav});

  final String login;
  final CratesRepository repository;
  final AppNavigator nav;

  @override
  State<OwnerPage> createState() => _OwnerPageState();
}

class _OwnerPageState extends State<OwnerPage> {
  final OwnerState _state = OwnerState();

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => _state.load(widget.repository, widget.login);

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => OwnerScreen(
        login: widget.login,
        state: _state,
        onBack: widget.nav.goBack,
        onRetry: _load,
      );
}

/// Keeps AppState-dependent props (language label, data source label) of the list screen fresh.
typedef AppStateBuilder = Widget Function(BuildContext context, AppState app);

class AppStateScope extends StatelessWidget {
  const AppStateScope({super.key, required this.app, required this.builder});

  final AppState app;
  final AppStateBuilder builder;

  @override
  Widget build(BuildContext context) => ListenableBuilder(listenable: app, builder: (c, _) => builder(c, app));
}
