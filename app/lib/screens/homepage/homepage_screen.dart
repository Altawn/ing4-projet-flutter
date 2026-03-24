import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/model/scan_history.dart';
import 'package:formation_flutter/res/app_vectorial_images.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_icons.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/screens/homepage/homepage_empty.dart';
import 'package:formation_flutter/screens/homepage/product_card.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:formation_flutter/api/auth_service.dart';

import 'package:formation_flutter/res/app_responsive.dart';
import 'package:formation_flutter/widgets/custom_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Consumer<ScanHistoryManager>(
      builder: (context, history, _) {
        return Scaffold(
          backgroundColor: AppColors.grey1,
          appBar: CustomAppBar(
            title: localizations.my_scans_screen_title,
            showBackButton: false,
            actions: <Widget>[
              if (!history.isEmpty)
                IconButton(
                  onPressed: () => _onScanButtonPressed(context),
                  iconSize: 23,
                  icon: Icon(AppIcons.barcode, color: AppColors.blue),
                ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: () => context.push('/favorites'),
                child: SizedBox(
                  width: 23.9,
                  height: 23.9,
                  child: SvgPicture.asset(
                    AppVectorialImages.star,
                    colorFilter: const ColorFilter.mode(
                      AppColors.blue,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: () {
                  AuthService().logout();
                  context.go('/login');
                },
                child: SizedBox(
                  width: 23.9,
                  height: 23.9,
                  child: SvgPicture.asset(
                    AppVectorialImages.arrowInSquare,
                    colorFilter: const ColorFilter.mode(
                      AppColors.blue,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
            ],
          ),
          body: history.isEmpty
              ? HomePageEmpty(onScan: () => _onScanButtonPressed(context))
              : _ScanHistoryList(products: history.products),
        );
      },
    );
  }

  void _onScanButtonPressed(BuildContext context) {
    context.push('/scanner');
  }
}

class _ScanHistoryList extends StatelessWidget {
  const _ScanHistoryList({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.w(context, 19.0),
        vertical: AppResponsive.h(context, 13.0),
      ).copyWith(bottom: AppResponsive.h(context, 40.0)),
      itemCount: products.length,
      separatorBuilder: (_, _) => const SizedBox(height: 47.0),
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}
