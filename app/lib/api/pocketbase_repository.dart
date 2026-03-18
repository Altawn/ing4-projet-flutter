import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/api/auth_service.dart';

/// Repository chargé de faire l'interface entre l'application et la base de données PocketBase.
/// On centralise ici tout le code réseau, ce qui rend l'application bien plus "propre" (Clean Architecture).
class PocketBaseRepository {
  static const String _defaultUrl = 'http://127.0.0.1:8090';

  String get _baseUrl => const String.fromEnvironment('PB_URL', defaultValue: _defaultUrl);
  String get _recordsUrl => '$_baseUrl/api/collections/products/records';

  final Dio _dio = Dio();

  // Injecte automatiquement le Bearer token d'authentification pour sécuriser les requêtes
  Options _authOptions() {
    final token = AuthService().token;
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  // --- GET : Récupère la liste des produits de l'utilisateur
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

  // --- POST/PATCH : Enregistre ou met à jour un produit
  Future<void> upsertProduct(Product product, {bool? isLiked}) async {
    final userId = AuthService().userId;
    if (userId == null) return;

    try {
      // Vérification si le produit existe déjà
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
        // Le produit est déjà là : on fait simplement un PATCH (mise à jour)
        final patchData = isLiked != null ? {'is_liked': isLiked} : data;
        await _dio.patch('$_recordsUrl/$existingId', options: _authOptions(), data: patchData);
      } else {
        // Nouveau produit, on l'invente avec POST
        await _dio.post(_recordsUrl, options: _authOptions(), data: data);
      }
    } catch (e) {
      debugPrint('Erreur lors du upsert PB : $e');
    }
  }

  // Permet de mapper le retour JSON brut de PocketBase vers notre Objet métier `Product`
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
