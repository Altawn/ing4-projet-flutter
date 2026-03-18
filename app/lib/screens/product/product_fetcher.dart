import 'package:flutter/material.dart';
import 'package:formation_flutter/api/open_food_facts_api.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/model/scan_history.dart';

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
      _state = ProductFetcherSuccess(product);
      scanHistoryManager?.addProduct(product);
    } catch (error) {
      _state = ProductFetcherError(error);
    } finally {
      notifyListeners();
    }
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
