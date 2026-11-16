import 'package:flutter/material.dart';
import '../../l10n/app_strings.dart';
import '../../state/favorites_state.dart';

class FavoritesScreen extends StatelessWidget {
  final FavoritesState favoritesState;
  final void Function(String crateName) onCrateClick;
  final VoidCallback onBack;

  const FavoritesScreen({
    super.key,
    required this.favoritesState,
    required this.onCrateClick,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context); // <-- Получаем локализацию
    
    return Scaffold(
      appBar: AppBar(
        title: Text(s.favorites), // <-- Локализованный заголовок
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: ListenableBuilder(
        listenable: favoritesState,
        builder: (context, child) {
          if (favoritesState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (favoritesState.favorites.isEmpty) {
            return Center(child: Text(s.favoritesEmpty)); // <-- Локализованный пустой экран
          }
          return ListView.builder(
            itemCount: favoritesState.favorites.length,
            itemBuilder: (context, index) {
              final crateName = favoritesState.favorites[index];
              return ListTile(
                title: Text(crateName),
                trailing: IconButton(
                  icon: const Icon(Icons.star, color: Colors.amber),
                  onPressed: () => favoritesState.toggleFavorite(crateName),
                ),
                onTap: () => onCrateClick(crateName),
              );
            },
          );
        },
      ),
    );
  }
}
