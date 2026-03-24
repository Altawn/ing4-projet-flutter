import 'package:flutter/material.dart';
import 'package:formation_flutter/model/favorites_manager.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:formation_flutter/screens/homepage/product_card.dart';
import 'package:formation_flutter/widgets/custom_app_bar.dart';
import 'package:formation_flutter/res/app_responsive.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey1,
      appBar: const CustomAppBar(title: 'Mes favoris'),
      body: Consumer<FavoritesManager>(
        builder: (context, favManager, _) {
          if (favManager.isEmpty) {
            return const Center(
              child: Text(
                'Aucun favori pour le moment',
                style: TextStyle(color: AppColors.grey2, fontSize: 16),
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.w(context, 19.0),
              vertical: AppResponsive.h(context, 12.0),
            ),
            itemCount: favManager.favorites.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12.0),
            itemBuilder: (context, index) {
              return ProductCard(product: favManager.favorites[index]);
            },
          );
        },
      ),
    );
  }
}
