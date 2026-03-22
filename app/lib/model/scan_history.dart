import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:dio/dio.dart';
import 'package:formation_flutter/api/auth_service.dart';

class ScanHistoryManager extends ChangeNotifier {
  final List<Product> _products = [];
  final Dio _dio = Dio();

  List<Product> get products => List.unmodifiable(_products);

  Future<void> fetchItems() async {
    try {
      final token = AuthService().token;
      final userId = AuthService().userId;
      if (token == null || userId == null) return;

      final response = await _dio.get(
        '${AuthService.pbBaseUrl}/api/collections/products/records',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {
          'sort': '-last_scanned_at',
          'filter': 'user_id ~ "$userId"',
        },
      );

      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        _products.clear();
        final seenBarcodes = <String>{};
        for (var item in items) {
          final barcode = item['gtin'] ?? '';
          if (!seenBarcodes.contains(barcode)) {
            seenBarcodes.add(barcode);
            _products.add(Product.fromPocketBase(item));
          }
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erreur lors du fetch depuis PB: $e');
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

      final existingResponse = await _dio.get(
        '${AuthService.pbBaseUrl}/api/collections/products/records',
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
        await _dio.patch(
          '${AuthService.pbBaseUrl}/api/collections/products/records/${items.first['id']}',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: data,
        );
      } else {
        await _dio.post(
          '${AuthService.pbBaseUrl}/api/collections/products/records',
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
