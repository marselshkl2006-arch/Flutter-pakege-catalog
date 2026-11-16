import 'package:flutter/foundation.dart';
import '../data/favorites_service.dart';

class FavoritesState extends ChangeNotifier {
  final FavoritesService _service = FavoritesService();
  List<String> _favorites = [];
  bool _isLoading = true;

  List<String> get favorites => _favorites;
  bool get isLoading => _isLoading;

  FavoritesState() {
    _load();
  }

  Future<void> _load() async {
    _favorites = await _service.loadFavorites();
    _isLoading = false;
    notifyListeners();
  }

  bool isFavorite(String crateName) => _favorites.contains(crateName);

  Future<void> toggleFavorite(String crateName) async {
    if (_favorites.contains(crateName)) {
      _favorites.remove(crateName);
    } else {
      _favorites.add(crateName);
    }
    notifyListeners();
    await _service.saveFavorites(_favorites);
  }
}
