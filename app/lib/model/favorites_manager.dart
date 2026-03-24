import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:dio/dio.dart';
import 'package:formation_flutter/api/auth_service.dart';

class FavoritesManager extends ChangeNotifier {
  final List<Product> _favorites = [];
  final Dio _dio = Dio();

  List<Product> get favorites => List.unmodifiable(_favorites);

  Future<void> fetchFavorites() async {
    try {
      final token = AuthService().token;
      final userId = AuthService().userId;
      if (token == null || userId == null) return;

      final response = await _dio.get(
        '${AuthService.pbBaseUrl}/api/collections/products/records',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {
          'sort': '-last_scanned_at',
          'filter': 'user_id ~ "$userId" && is_liked = true',
        },
      );

      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        _favorites.clear();
        final seenBarcodes = <String>{};
        for (var item in items) {
          final barcode = item['gtin'] ?? '';
          if (!seenBarcodes.contains(barcode)) {
            seenBarcodes.add(barcode);
            _favorites.add(Product.fromPocketBase(item));
          }
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erreur fetch favorites PB: $e');
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

      final existingResponse = await _dio.get(
        '${AuthService.pbBaseUrl}/api/collections/products/records',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {'filter': 'gtin = "${product.barcode}"'},
      );

      final items = existingResponse.data['items'] as List;

      if (items.isNotEmpty) {
        await _dio.patch(
          '${AuthService.pbBaseUrl}/api/collections/products/records/${items.first['id']}',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: {'is_liked': isLiked},
        );
      } else {
        await _dio.post(
          '${AuthService.pbBaseUrl}/api/collections/products/records',
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
