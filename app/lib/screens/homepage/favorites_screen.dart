import 'package:flutter/material.dart';
import 'package:formation_flutter/model/favorites_manager.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blueDark),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Mes favoris',
          style: TextStyle(
            color: AppColors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Consumer<FavoritesManager>(
        builder: (context, favManager, _) {
          if (favManager.isEmpty) {
            return const Center(
              child: Text(
                'Aucun favori pour le moment',
                style: TextStyle(
                  color: AppColors.grey2,
                  fontSize: 16,
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            itemCount: favManager.favorites.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12.0),
            itemBuilder: (context, index) {
              return _FavoriteProductCard(product: favManager.favorites[index]);
            },
          );
        },
      ),
    );
  }
}

class _FavoriteProductCard extends StatelessWidget {
  const _FavoriteProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/product', extra: product.barcode),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 12.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                bottomLeft: Radius.circular(16.0),
              ),
              child: product.picture != null
                  ? Image.network(
                      product.picture!,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 120,
                        height: 120,
                        color: AppColors.grey1,
                        child: const Icon(Icons.image_not_supported, color: AppColors.grey2),
                      ),
                    )
                  : Container(
                      width: 120,
                      height: 120,
                      color: AppColors.grey1,
                      child: const Icon(Icons.image_not_supported, color: AppColors.grey2),
                    ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.name ?? '-',
                      style: const TextStyle(
                        color: AppColors.blueDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      product.brands?.join(', ') ?? '-',
                      style: const TextStyle(
                        color: AppColors.grey2,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    _NutriscoreChip(nutriScore: product.nutriScore),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12.0),
          ],
        ),
      ),
    );
  }
}

class _NutriscoreChip extends StatelessWidget {
  const _NutriscoreChip({this.nutriScore});

  final ProductNutriScore? nutriScore;

  @override
  Widget build(BuildContext context) {
    final String label = switch (nutriScore) {
      ProductNutriScore.A => 'A',
      ProductNutriScore.B => 'B',
      ProductNutriScore.C => 'C',
      ProductNutriScore.D => 'D',
      ProductNutriScore.E => 'E',
      _ => '?',
    };

    final Color color = switch (nutriScore) {
      ProductNutriScore.A => AppColors.nutriscoreA,
      ProductNutriScore.B => AppColors.nutriscoreB,
      ProductNutriScore.C => AppColors.nutriscoreC,
      ProductNutriScore.D => AppColors.nutriscoreD,
      ProductNutriScore.E => AppColors.nutriscoreE,
      _ => AppColors.grey2,
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6.0),
        Text(
          'Nutriscore : $label',
          style: const TextStyle(
            color: AppColors.blueDark,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
