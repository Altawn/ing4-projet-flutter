import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';

class FavoritesManager extends ChangeNotifier {
  final List<Product> _favorites = [];

  List<Product> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(String barcode) {
    return _favorites.any((p) => p.barcode == barcode);
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product.barcode)) {
      _favorites.removeWhere((p) => p.barcode == product.barcode);
    } else {
      _favorites.insert(0, product);
    }
    notifyListeners();
  }

  bool get isEmpty => _favorites.isEmpty;
}
