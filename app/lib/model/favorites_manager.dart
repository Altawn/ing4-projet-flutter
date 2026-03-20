import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:dio/dio.dart';
import 'package:formation_flutter/api/auth_service.dart';

class FavoritesManager extends ChangeNotifier {
  final List<Product> _favorites = [];

  List<Product> get favorites => List.unmodifiable(_favorites);

  Future<void> fetchFavorites() async {
    try {
      final token = AuthService().token;
      final userId = AuthService().userId;
      if (token == null || userId == null) return;

      const baseUrl = String.fromEnvironment('PB_URL', defaultValue: 'http://127.0.0.1:8090');
      final dio = Dio();
      final response = await dio.get(
        '$baseUrl/api/collections/products/records',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {
          'sort': '-created',
          'filter': 'user_id ~ "$userId" && is_liked = true',
        },
      );

      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        _favorites.clear();
        for (var item in items) {
          _favorites.add(Product(
             barcode: item['gtin'] ?? '',
             name: item['libelle'],
             brands: [(item['marque_produit'] ?? '')],
             picture: item['picture'],
             nutriScore: _parseNutriscore(item['nutriscore']),
          ));
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erreur fetch favorites PB: $e');
    }
  }

  ProductNutriScore _parseNutriscore(String? val) {
    if (val == null) return ProductNutriScore.unknown;
    switch (val.toUpperCase()) {
      case 'A': return ProductNutriScore.A;
      case 'B': return ProductNutriScore.B;
      case 'C': return ProductNutriScore.C;
      case 'D': return ProductNutriScore.D;
      case 'E': return ProductNutriScore.E;
      default: return ProductNutriScore.unknown;
    }
  }

  bool isFavorite(String barcode) {
    return _favorites.any((p) => p.barcode == barcode);
  }

  void toggleFavorite(Product product) {
    final bool willBeFavorite = !isFavorite(product.barcode);

    if (!willBeFavorite) {
      _favorites.removeWhere((p) => p.barcode == product.barcode);
    } else {
      _favorites.insert(0, product);
    }
    notifyListeners();

    _setFavoriteInPocketBase(product, willBeFavorite);
  }

  Future<void> _setFavoriteInPocketBase(Product product, bool isLiked) async {
    try {
      final token = AuthService().token;
      final userId = AuthService().userId;
      if (token == null || userId == null) return;

      const baseUrl = String.fromEnvironment('PB_URL', defaultValue: 'http://127.0.0.1:8090');
      final dio = Dio();

      final existingResponse = await dio.get(
        '$baseUrl/api/collections/products/records',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {'filter': 'gtin = "${product.barcode}"'},
      );

      final items = existingResponse.data['items'] as List;

      if (items.isNotEmpty) {
        await dio.patch(
          '$baseUrl/api/collections/products/records/${items.first['id']}',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: {'is_liked': isLiked},
        );
      } else {
        await dio.post(
          '$baseUrl/api/collections/products/records',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: {
            'gtin': product.barcode,
            'libelle': product.name ?? 'Produit Inconnu',
            'marque_produit': product.brands?.join(', ') ?? '',
            'picture': product.picture ?? '',
            'nutriscore': product.nutriScore?.name ?? 'unknown',
            'is_liked': isLiked,
            'user_id': userId,
          },
        );
      }
    } catch (e) {
      debugPrint('Erreur favoris PocketBase : $e');
    }
  }

  bool get isEmpty => _favorites.isEmpty;
}
