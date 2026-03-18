import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/api/pocketbase_repository.dart';

class ScanHistoryManager extends ChangeNotifier {
  final List<Product> _products = [];
  final PocketBaseRepository _repository = PocketBaseRepository();

  List<Product> get products => List.unmodifiable(_products);

  /// Charge depuis l'API et rafraichit la liste locale.
  Future<void> fetchItems() async {
    final fetchedProducts = await _repository.fetchProducts(onlyFavorites: false);
    _products.clear();
    _products.addAll(fetchedProducts);
    notifyListeners();
  }

  /// Ajoute un produit scanné en mémoire (instantané) et l'envoie en BDD (asynchrone).
  void addProduct(Product product) {
    _products.removeWhere((p) => p.barcode == product.barcode);
    _products.insert(0, product);
    notifyListeners();
    
    // Synchro BDD en fond
    _repository.upsertProduct(product);
  }

  bool get isEmpty => _products.isEmpty;
}
