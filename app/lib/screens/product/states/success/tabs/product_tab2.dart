import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_responsive.dart';
import 'package:provider/provider.dart';
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
          padding: EdgeInsetsDirectional.only(
            start: AppResponsive.w(context, 20.0),
            top: AppResponsive.h(context, 10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: AppResponsive.w(context, 313),
                child: Text(
                  product.name ?? '-',
                  style: TextStyle(
                    color: const Color(0xFF080040),
                    fontFamily: 'Avenir',
                    fontSize: AppResponsive.sp(context, 28),
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.45,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 3.0),
              SizedBox(
                width: AppResponsive.w(context, 288),
                child: Text(
                  product.brands?.join(', ') ?? '-',
                  style: TextStyle(
                    color: const Color(0xFFB8BBC6),
                    fontFamily: 'Avenir',
                    fontSize: AppResponsive.sp(context, 17),
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.27,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 18.0, bottom: 47.0, left: 20.0, right: 20.0),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              'Repères nutritionnels pour 100g',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF6A6A6A),
                fontFamily: 'Avenir',
                fontSize: 17,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.48,
              ),
            ),
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
        color = const Color(0xFF63993F);
        levelText = 'Faible quantité';
        break;
      case 'moderate':
        color = const Color(0xFF997B3F);
        levelText = 'Quantité modérée';
        break;
      case 'high':
        color = const Color(0xFF993F3F);
        levelText = 'Quantité élevée';
        break;
      default:
        levelText = level ?? '';
    }

    const TextStyle quantityStyle = TextStyle(
      fontFamily: 'Avenir',
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF080040),
                fontFamily: 'Avenir',
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                quantityText,
                textAlign: TextAlign.right,
                style: quantityStyle.copyWith(color: color),
              ),
              if (levelText.isNotEmpty)
                Text(
                  levelText,
                  textAlign: TextAlign.right,
                  style: quantityStyle.copyWith(color: color),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
