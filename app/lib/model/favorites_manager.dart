import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/api/pocketbase_repository.dart';

class FavoritesManager extends ChangeNotifier {
  final List<Product> _favorites = [];
  final PocketBaseRepository _repository = PocketBaseRepository();

  List<Product> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(String barcode) {
    return _favorites.any((p) => p.barcode == barcode);
  }

  Future<void> fetchFavorites() async {
    final fetchedFavorites = await _repository.fetchProducts(onlyFavorites: true);
    _favorites.clear();
    _favorites.addAll(fetchedFavorites);
    notifyListeners();
  }

  void toggleFavorite(Product product) {
    final bool willBeFavorite = !isFavorite(product.barcode);

    if (!willBeFavorite) {
      _favorites.removeWhere((p) => p.barcode == product.barcode);
    } else {
      _favorites.insert(0, product);
    }
    notifyListeners();

    _repository.upsertProduct(product, isLiked: willBeFavorite);
  }

  bool get isEmpty => _favorites.isEmpty;
}
