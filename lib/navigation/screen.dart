/// Type-safe routes (sealed classes, not strings).
sealed class Screen {
  const Screen();
}

final class ListRoute extends Screen {
  const ListRoute();

  @override
  bool operator ==(Object other) => other is ListRoute;

  @override
  int get hashCode => 0;
}

final class DetailRoute extends Screen {
  const DetailRoute(this.crateName);
  final String crateName;

  @override
  bool operator ==(Object other) => other is DetailRoute && other.crateName == crateName;

  @override
  int get hashCode => Object.hash('detail', crateName);
}

final class DependenciesRoute extends Screen {
  const DependenciesRoute(this.crateName);
  final String crateName;

  @override
  bool operator ==(Object other) => other is DependenciesRoute && other.crateName == crateName;

  @override
  int get hashCode => Object.hash('dependencies', crateName);
}

final class OwnerRoute extends Screen {
  const OwnerRoute(this.login);
  final String login;

  @override
  bool operator ==(Object other) => other is OwnerRoute && other.login == login;

  @override
  int get hashCode => Object.hash('owner', login);
}

// ДОБАВЛЯЕМ НОВЫЙ МАРШРУТ
final class FavoritesRoute extends Screen {
  const FavoritesRoute();

  @override
  bool operator ==(Object other) => other is FavoritesRoute;

  @override
  int get hashCode => 1;
}
