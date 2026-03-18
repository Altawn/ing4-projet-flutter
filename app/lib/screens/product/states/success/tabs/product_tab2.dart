import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:formation_flutter/res/app_theme_extension.dart';
import 'package:intl/intl.dart';

class ProductTab2 extends StatelessWidget {
  const ProductTab2({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Text(
            'Repères nutritionnels pour 100g',
            style: context.theme.title1.copyWith(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.grey3),
          ),
        ),
        _buildNutrientRow(
          context,
          'Matières grasses / lipides',
          product.nutritionFacts?.fat,
          product.nutrientLevels?.fat,
        ),
        const Divider(height: 1, indent: 20, endIndent: 20),
        _buildNutrientRow(
          context,
          'Acides gras saturés',
          product.nutritionFacts?.saturatedFat,
          product.nutrientLevels?.saturatedFat,
        ),
        const Divider(height: 1, indent: 20, endIndent: 20),
        _buildNutrientRow(
          context,
          'Sucres',
          product.nutritionFacts?.sugar,
          product.nutrientLevels?.sugars,
        ),
        const Divider(height: 1, indent: 20, endIndent: 20),
        _buildNutrientRow(
          context,
          'Sel',
          product.nutritionFacts?.salt,
          product.nutrientLevels?.salt,
        ),
      ],
    );
  }

  Widget _buildNutrientRow(BuildContext context, String title, Nutriment? nutriment, String? level) {
    if (nutriment == null) {
      return const SizedBox.shrink();
    }

    final NumberFormat numberFormat = NumberFormat.decimalPatternDigits(
      locale: Localizations.localeOf(context).countryCode ?? 'fr',
      decimalDigits: 2,
    );

    String quantityText = '-';
    if (nutriment.per100g != null) {
      if (nutriment.per100g is num) {
        quantityText = '${numberFormat.format(nutriment.per100g)}${nutriment.unit}';
      } else {
        quantityText = '${nutriment.per100g}${nutriment.unit}';
      }
    }

    Color color = AppColors.grey3;
    String levelText = '';

    switch (level?.toLowerCase()) {
      case 'low':
        color = AppColors.nutrientLevelLow;
        levelText = 'Faible quantité';
        break;
      case 'moderate':
        color = AppColors.nutrientLevelModerate;
        levelText = 'Quantité modérée';
        break;
      case 'high':
        color = AppColors.nutrientLevelHigh;
        levelText = 'Quantité élevée';
        break;
      default:
        levelText = level ?? '';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: context.theme.title1.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                quantityText,
                style: context.theme.title1.copyWith(fontSize: 16, color: color, fontWeight: FontWeight.bold),
              ),
              if (levelText.isNotEmpty)
                Text(
                  levelText,
                  style: context.theme.title1.copyWith(fontSize: 16, color: color, fontWeight: FontWeight.normal),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
