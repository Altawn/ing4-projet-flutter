import 'package:dio/dio.dart';
import 'package:formation_flutter/model/product.dart';

class OpenFoodFactsAPI {
  static const String _baseUrl = 'https://api.formation-flutter.fr/v2';

  static final OpenFoodFactsAPI _instance = OpenFoodFactsAPI._internal();

  factory OpenFoodFactsAPI() => _instance;

  final Dio _dio;

  OpenFoodFactsAPI._internal() : _dio = Dio(BaseOptions(baseUrl: _baseUrl));

  Future<Product> getProduct(String barcode) async {
    try {
      final response = await _dio.get(
        '/getProduct',
        queryParameters: {'barcode': barcode},
      );
      final data = response.data['response'] as Map<String, dynamic>?;
      if (data == null) throw Exception('Produit introuvable');
      return Product.fromJson(data);
    } on DioException {
      throw Exception('Produit introuvable');
    }
  }
}
