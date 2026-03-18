import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/api/auth_service.dart';

class PocketBaseRepository {
  static const String _defaultUrl = 'http://127.0.0.1:8090';

  String get _baseUrl => const String.fromEnvironment('PB_URL', defaultValue: _defaultUrl);
  String get _recordsUrl => '$_baseUrl/api/collections/products/records';

  final Dio _dio = Dio();

  Options _authOptions() {
    final token = AuthService().token;
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  Future<List<Product>> fetchProducts({bool onlyFavorites = false}) async {
    final userId = AuthService().userId;
    if (userId == null) return [];

    final String filter = onlyFavorites 
        ? 'user_id ~ "$userId" && is_liked = true'
        : 'user_id ~ "$userId"';

    try {
      final response = await _dio.get(
        _recordsUrl,
        options: _authOptions(),
        queryParameters: {
          'sort': '-created',
          'filter': filter,
        },
      );

      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        return items.map((item) => _mapJsonToProduct(item)).toList();
      }
    } catch (e) {
      debugPrint('Erreur fetch products PB: $e');
    }
    return [];
  }

  Future<void> upsertProduct(Product product, {bool? isLiked}) async {
    final userId = AuthService().userId;
    if (userId == null) return;

    try {
      final existingResponse = await _dio.get(
        _recordsUrl,
        options: _authOptions(),
        queryParameters: {'filter': 'gtin = "${product.barcode}"'},
      );

      final items = existingResponse.data['items'] as List;
      final existingId = items.isNotEmpty ? items.first['id'] as String : null;

      final data = {
        'gtin': product.barcode,
        'libelle': product.name ?? 'Produit Inconnu',
        'marque_produit': product.brands?.join(', ') ?? '',
        'picture': product.picture ?? '',
        'nutriscore': product.nutriScore?.name ?? 'unknown',
        'user_id': [userId],
      };

      if (isLiked != null) {
        data['is_liked'] = isLiked;
      }

      if (existingId != null) {
        final patchData = isLiked != null ? {'is_liked': isLiked} : data;
        await _dio.patch('$_recordsUrl/$existingId', options: _authOptions(), data: patchData);
      } else {
        await _dio.post(_recordsUrl, options: _authOptions(), data: data);
      }
    } catch (e) {
      debugPrint('Erreur lors du upsert PB : $e');
    }
  }

  Product _mapJsonToProduct(Map<String, dynamic> item) {
    return Product(
      barcode: item['gtin'] ?? '',
      name: item['libelle'],
      brands: [(item['marque_produit'] ?? '')],
      picture: item['picture'],
      nutriScore: _parseNutriscore(item['nutriscore']),
    );
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
}
