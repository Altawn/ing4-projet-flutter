import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:dio/dio.dart';
import 'package:formation_flutter/api/auth_service.dart';

class ScanHistoryManager extends ChangeNotifier {
  final List<Product> _products = [];

  List<Product> get products => List.unmodifiable(_products);

  Future<void> fetchItems() async {
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
          'filter': 'user_id ~ "$userId"',
        },
      );

      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        _products.clear();
        for (var item in items) {
          _products.add(Product(
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
      debugPrint('Erreur lors du fetch depuis PB: $e');
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

  void addProduct(Product product) {
    _products.removeWhere((p) => p.barcode == product.barcode);
    _products.insert(0, product);
    notifyListeners();
    
    _syncToPocketBase(product);
  }

  Future<void> _syncToPocketBase(Product product) async {
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
      final data = {
        'gtin': product.barcode,
        'libelle': product.name ?? 'Produit Inconnu',
        'marque_produit': product.brands?.join(', ') ?? '',
        'picture': product.picture ?? '',
        'nutriscore': product.nutriScore?.name ?? 'unknown',
        'user_id': userId,
      };

      if (items.isNotEmpty) {
        await dio.patch(
          '$baseUrl/api/collections/products/records/${items.first['id']}',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: data,
        );
      } else {
        await dio.post(
          '$baseUrl/api/collections/products/records',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: data,
        );
      }
    } catch (e) {
      debugPrint('Erreur synchro PocketBase : $e');
    }
  }

  bool get isEmpty => _products.isEmpty;
}
