import 'package:flutter/material.dart';

class ProductPageError extends StatelessWidget {
  const ProductPageError({super.key, this.error});

  final dynamic error;

  @override
  Widget build(BuildContext context) {
    final isNotFound = error.toString().contains('introuvable');
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isNotFound ? Icons.search_off : Icons.error_outline,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 12),
          Text(
            isNotFound ? 'Produit introuvable' : 'Une erreur est survenue',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
