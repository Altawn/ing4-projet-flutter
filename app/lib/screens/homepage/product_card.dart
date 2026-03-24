import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_responsive.dart';
import 'package:go_router/go_router.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

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
                  ), 
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
