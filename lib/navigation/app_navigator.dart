import 'package:flutter/material.dart';

import 'screen.dart';

/// Wraps the Navigator: navigateTo / goBack / backStack. Typed [Screen]s travel as route arguments;
/// this observer mirrors the stack so it can be inspected.
class AppNavigator extends NavigatorObserver {
  final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  /// Builds the Route for a Screen. Set by the app.
  late Route<void> Function(Screen screen) routeFactory;

  final List<Screen> _stack = [const ListRoute()];

  List<Screen> get backStack => List.unmodifiable(_stack);

  void navigateTo(Screen screen) {
    key.currentState?.push(routeFactory(screen));
  }

  void goBack() {
    key.currentState?.maybePop();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final arg = route.settings.arguments;
    if (arg is Screen) _stack.add(arg);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.arguments is Screen && _stack.length > 1) _stack.removeLast();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.arguments is Screen && _stack.length > 1) _stack.removeLast();
  }
}

/// Forward: the new screen slides in from the right (the old one drifts left).
/// Back: the same animation in reverse, so the previous screen slides in from the left
/// and the current one leaves to the right.
Route<void> slideRoute(Screen screen, WidgetBuilder builder) {
  return PageRouteBuilder<void>(
    settings: RouteSettings(name: screen.runtimeType.toString(), arguments: screen),
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final incoming = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      final outgoing = CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeOutCubic);
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(incoming),
        child: SlideTransition(
          position: Tween<Offset>(begin: Offset.zero, end: const Offset(-0.3, 0)).animate(outgoing),
          child: child,
        ),
      );
    },
  );
}
