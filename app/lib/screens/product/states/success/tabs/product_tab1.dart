import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_responsive.dart';
import 'package:provider/provider.dart';
import 'package:formation_flutter/res/app_theme_extension.dart';

class ProductTab1 extends StatelessWidget {
  const ProductTab1({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(
            start: AppResponsive.w(context, 20.0),
            top: AppResponsive.h(context, 10.0),
            bottom: AppResponsive.h(context, 20.0),
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
        _buildSectionHeader(context, 'Ingrédients'),
        _buildIngredientsList(context, product),
        _buildSectionHeader(context, 'Substances allergènes'),
        _buildSimpleList(context, product.allergens, 'Aucune'),
        _buildSectionHeader(context, 'Additifs'),
        _buildAdditivesList(context, product.additives),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      height: AppResponsive.h(
        context,
        40.0,
      ), // Container height to wrap the 25px text
      color: const Color(0xFFF6F6F8),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF080040),
            fontFamily: 'Avenir',
            fontSize: AppResponsive.sp(context, 16),
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
            height: 25.0 / 16.0,
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientsList(BuildContext context, Product product) {
    if (product.ingredients == null || product.ingredients!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: Text(
          'Aucune',
          style: context.theme.title1.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      );
    }

    final List<Widget> items = [];
    for (int i = 0; i < product.ingredients!.length; i++) {
      final String rawIngredient = product.ingredients![i];
      String label = rawIngredient;
      String? details;

      // Simple parsing of "Ingredient (Details)"
      final int openParen = rawIngredient.indexOf('(');
      final int closeParen = rawIngredient.lastIndexOf(')');
      if (openParen != -1 && closeParen != -1 && closeParen > openParen) {
        label = rawIngredient.substring(0, openParen).trim();
        details = rawIngredient.substring(openParen + 1, closeParen).trim();
      }

      items.add(
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppResponsive.h(context, 16.0),
            horizontal: AppResponsive.w(context, 20.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  label,
                  style: TextStyle(
                    color: const Color(0xFF080040),
                    fontFamily: 'Avenir',
                    fontSize: AppResponsive.sp(context, 15),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (details != null)
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 28.0),
                    child: Text(
                      details,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Color(0xFF6A6A6A),
                        fontFamily: 'Avenir',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
      if (i < product.ingredients!.length - 1) {
        items.add(
          Divider(
            height: 1,
            indent: AppResponsive.w(context, 20.0),
            endIndent: AppResponsive.w(context, 20.0),
            color: const Color(0xFFF6F6F8),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items,
    );
  }

  Widget _buildSimpleList(
    BuildContext context,
    List<String>? items,
    String emptyText,
  ) {
    if (items == null || items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: Text(
          emptyText,
          style: context.theme.title1.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      child: Text(
        items.join(', '),
        style: const TextStyle(
          color: Color(0xFF080040),
          fontFamily: 'Avenir',
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAdditivesList(
    BuildContext context,
    Map<String, String>? additives,
  ) {
    if (additives == null || additives.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: Text(
          'Aucune',
          style: context.theme.title1.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    final List<Widget> items = [];
    for (var entry in additives.entries) {
      items.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  entry.key,
                  style: TextStyle(
                    color: const Color(0xFF080040),
                    fontFamily: 'Avenir',
                    fontSize: AppResponsive.sp(context, 15),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 28.0),
                  child: Text(
                    entry.value,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Color(0xFF6A6A6A),
                      fontFamily: 'Avenir',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      items.add(
        const Divider(
          height: 1,
          indent: 20,
          endIndent: 20,
          color: AppColors.grey1,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items,
    );
  }
}
