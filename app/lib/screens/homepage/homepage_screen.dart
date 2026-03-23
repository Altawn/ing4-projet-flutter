import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/model/scan_history.dart';
import 'package:formation_flutter/res/app_vectorial_images.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_icons.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/screens/homepage/homepage_empty.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:formation_flutter/api/auth_service.dart';

import 'package:formation_flutter/res/app_responsive.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Consumer<ScanHistoryManager>(
      builder: (context, history, _) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(54.0),
            child: Container(
              child: AppBar(
                title: Text(
                  localizations.my_scans_screen_title,
                  style: const TextStyle(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Avenir',
                    fontSize: 17,
                    letterSpacing: -0.41,
                  ),
                ),
                centerTitle: false,
                titleSpacing: 13.0, // 13px padding from left
                elevation: 0,
                backgroundColor: AppColors.white,
                toolbarHeight: 54, // The bottom section height
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
                  const SizedBox(width: 15), // 15px padding from right
                ],
              ),
            ),
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
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 13.0,
        bottom: 40.0,
      ),
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 47.0),
      itemBuilder: (context, index) {
        return _ProductCard(product: products[index]);
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/product', extra: product.barcode),
      child: Container(
        height: AppResponsive.h(context, 108 + 23),
        alignment: Alignment.bottomCenter,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // The Card Background
            Container(
              height: AppResponsive.h(context, 108),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.14),
                    blurRadius: AppResponsive.w(context, 20.0),
                    offset: Offset(0, AppResponsive.h(context, 5)),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: AppResponsive.w(context, 113 + 18 + 12),
                  ), // Space for the floating image
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppResponsive.h(context, 16.0),
                        horizontal: AppResponsive.w(context, 4.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: AppResponsive.w(context, 170),
                            height: AppResponsive.h(context, 22),
                            child: Text(
                              product.name ?? '-',
                              style: TextStyle(
                                color: AppColors.blue,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Avenir',
                                fontSize: AppResponsive.sp(context, 17),
                                letterSpacing: -0.41,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: AppResponsive.h(context, 4.0)),
                          SizedBox(
                            width: AppResponsive.w(context, 96),
                            height: AppResponsive.h(context, 18),
                            child: Text(
                              product.brands?.join(', ') ?? '-',
                              style: TextStyle(
                                color: AppColors.grey3,
                                fontFamily: 'Avenir',
                                fontSize: AppResponsive.sp(context, 13),
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.08,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: AppResponsive.h(context, 8.0)),
                          _NutriscoreChip(nutriScore: product.nutriScore),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // The Floating Image
            Positioned(
              left: AppResponsive.w(context, 18),
              bottom: AppResponsive.h(context, 18),
              child: Container(
                width: AppResponsive.w(context, 113),
                height: AppResponsive.h(context, 113),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: AppResponsive.w(context, 10.0),
                      offset: Offset(0, AppResponsive.h(context, 2)),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: product.picture != null
                      ? Image.network(
                          product.picture!,
                          width: AppResponsive.w(context, 113),
                          height: AppResponsive.h(context, 113),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: AppResponsive.w(context, 113),
                            height: AppResponsive.h(context, 113),
                            color: AppColors.grey1,
                            child: const Icon(
                              Icons.image_not_supported,
                              color: AppColors.grey2,
                            ),
                          ),
                        )
                      : Container(
                          width: AppResponsive.w(context, 113),
                          height: AppResponsive.h(context, 113),
                          color: AppColors.grey1,
                          child: const Icon(
                            Icons.image_not_supported,
                            color: AppColors.grey2,
                          ),
                        ),
                ),
              ),
            ),
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
          width: AppResponsive.w(context, 13),
          height: AppResponsive.h(context, 13),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: AppResponsive.w(context, 6.0)),
        SizedBox(
          width: AppResponsive.w(context, 170),
          height: AppResponsive.h(context, 18),
          child: Text(
            'Nutriscore : $label',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Avenir',
              fontSize: AppResponsive.sp(context, 12),
              fontWeight: FontWeight.w400,
              letterSpacing: -0.07,
            ),
          ),
        ),
      ],
    );
  }
}
