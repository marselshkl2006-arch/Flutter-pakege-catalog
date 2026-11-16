import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FavoritesService {
  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/favorites.txt');
  }

  Future<List<String>> loadFavorites() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        return content.split('\n').where((s) => s.trim().isNotEmpty).toList();
      }
    } catch (e) {
      print('Error loading favorites: $e');
    }
    return [];
  }

  Future<void> saveFavorites(List<String> favorites) async {
    try {
      final file = await _getFile();
      await file.writeAsString(favorites.join('\n'));
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }
}
