import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
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
      color: AppColors.grey1,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      child: Text(
        title,
        style: context.theme.title3.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildIngredientsList(BuildContext context, Product product) {
    if (product.ingredients == null || product.ingredients!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: Text('Aucune', style: context.theme.title1.copyWith(fontSize: 16, fontWeight: FontWeight.normal)),
      );
    }
    
    final List<Widget> items = [];
    for (int i = 0; i < product.ingredients!.length; i++) {
      items.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          child: Text(
            product.ingredients![i],
            style: context.theme.title1.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
      if (i < product.ingredients!.length - 1) {
        items.add(const Divider(height: 1, indent: 20, endIndent: 20));
      }
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items,
    );
  }

  Widget _buildSimpleList(BuildContext context, List<String>? items, String emptyText) {
    if (items == null || items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: Text(emptyText, style: context.theme.title1.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      child: Text(
        items.join(', '),
        style: context.theme.title1.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildAdditivesList(BuildContext context, Map<String, String>? additives) {
    if (additives == null || additives.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: Text('Aucune', style: context.theme.title1.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
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
              Text(entry.key, style: context.theme.title1.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  entry.value, 
                  style: context.theme.title1.copyWith(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.grey3)
                )
              ),
            ],
          ),
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items,
    );
  }
}
