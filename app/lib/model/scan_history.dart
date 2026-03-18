import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';

class ScanHistoryManager extends ChangeNotifier {
  final List<Product> _products = [];

  List<Product> get products => List.unmodifiable(_products);

  void addProduct(Product product) {
    // Éviter les doublons consécutifs du même barcode
    _products.removeWhere((p) => p.barcode == product.barcode);
    // Ajouter en tête de liste (le plus récent en premier)
    _products.insert(0, product);
    notifyListeners();
  }

  bool get isEmpty => _products.isEmpty;
}
