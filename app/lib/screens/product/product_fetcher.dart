import 'package:flutter/material.dart';
import 'package:formation_flutter/api/open_food_facts_api.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/model/scan_history.dart';
import 'package:formation_flutter/model/recall.dart';
import 'package:dio/dio.dart';
import 'package:formation_flutter/api/auth_service.dart';

class ProductFetcher extends ChangeNotifier {
  ProductFetcher({required String barcode, this.scanHistoryManager})
    : _barcode = barcode,
      _state = ProductFetcherLoading() {
    loadProduct();
  }

  final String _barcode;
  final ScanHistoryManager? scanHistoryManager;
  ProductFetcherState _state;

  Future<void> loadProduct() async {
    _state = ProductFetcherLoading();
    notifyListeners();

    try {
      Product product = await OpenFoodFactsAPI().getProduct(_barcode);
      
      // Check for recall in PocketBase
      final recall = await _checkRecall(_barcode);
      if (recall != null) {
        product = product.copyWith(recall: recall);
      }

      _state = ProductFetcherSuccess(product);
      scanHistoryManager?.addProduct(product);
    } catch (error) {
      _state = ProductFetcherError(error);
    } finally {
      notifyListeners();
    }
  }

  Future<ProductRecall?> _checkRecall(String barcode) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        '${AuthService.pbBaseUrl}/api/collections/rappels/records',
        queryParameters: {'filter': 'gtin ~ "$barcode"'},
      );

      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        if (items.isNotEmpty) {
          return ProductRecall.fromPocketBase(items.first);
        }
      }
    } catch (e) {
      debugPrint('Erreur lors de la recherche de rappel : $e');
    }
    return null;
  }

  ProductFetcherState get state => _state;
}

sealed class ProductFetcherState {}

class ProductFetcherLoading extends ProductFetcherState {}

class ProductFetcherSuccess extends ProductFetcherState {
  ProductFetcherSuccess(this.product);

  final Product product;
}

class ProductFetcherError extends ProductFetcherState {
  ProductFetcherError(this.error);

  final dynamic error;
}
