import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_icons.dart';
import 'package:formation_flutter/res/app_theme_extension.dart';
import 'package:formation_flutter/res/app_vectorial_images.dart';
import 'package:formation_flutter/res/app_responsive.dart';
import 'package:formation_flutter/model/recall.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProductTab0 extends StatelessWidget {
  const ProductTab0({super.key});

  static double horizontalPadding(BuildContext context) =>
      AppResponsive.w(context, 19.0);

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsetsDirectional.only(
            start: AppResponsive.w(context, 20.0),
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
              const SizedBox(height: 5.0),
              SizedBox(
                width: AppResponsive.w(context, 335),
                child: Text(
                  product.altName ?? 'Pas de description disponible',
                  style: TextStyle(
                    color: const Color(0xFF6A6A6A),
                    fontFamily: 'Avenir',
                    fontSize: AppResponsive.sp(context, 17),
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.48,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppResponsive.h(context, 14.0)),
        if (product.recall != null) _RecallBanner(recall: product.recall!),
        SizedBox(height: AppResponsive.h(context, 29.0)),
        const _Scores(),
        Padding(
          padding: EdgeInsetsDirectional.only(
            start: AppResponsive.w(context, 19.0),
            end: AppResponsive.w(context, 19.0),
            top: AppResponsive.h(context, 29.0),
            bottom: AppResponsive.h(context, 8.0),
          ),
          child: const _Info(),
        ),
      ],
    );
  }
}

class _Scores extends StatelessWidget {
  const _Scores();

  static double horizontalPadding(BuildContext context) =>
      ProductTab0.horizontalPadding(context);
  static double verticalPadding(BuildContext context) =>
      AppResponsive.h(context, 18.0);

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();

    return DefaultTextStyle(
      style: context.theme.altText,
      child: Container(
        color: AppColors.grey1,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    top: AppResponsive.h(context, 17.0),
                    bottom: verticalPadding(context),
                    start: horizontalPadding(context),
                    end: horizontalPadding(context),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(end: 5.0),
                          child: _Nutriscore(
                            nutriscore:
                                product.nutriScore ?? ProductNutriScore.unknown,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 16.0,
                          ),
                          child: _NovaGroup(
                            novaScore:
                                product.novaScore ?? ProductNovaScore.unknown,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: AppResponsive.w(context, 166.25),
                  top: AppResponsive.h(context, 17.0),
                  child: Container(
                    width: 2.0,
                    height: AppResponsive.h(context, 69.0),
                    color: const Color(0xFFEAECEF),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: AppResponsive.h(context, 80.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F8),
                border: Border(
                  top: BorderSide(color: const Color(0xFFEAECEF), width: 2.0),
                ),
              ),
              padding: EdgeInsetsDirectional.only(
                start: horizontalPadding(context),
              ),
              alignment: Alignment.centerLeft,
              child: _GreenScore(
                start:
                    AppResponsive.w(context, 35.0) - horizontalPadding(context),
                greenScore: product.greenScore ?? ProductGreenScore.unknown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Nutriscore extends StatelessWidget {
  const _Nutriscore({required this.nutriscore});

  final ProductNutriScore nutriscore;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Nutri-Score',
          style: context.theme.title3.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: AppResponsive.sp(context, 16),
            fontFamily: 'Avenir',
            color: AppColors.blue,
          ),
        ),
        const SizedBox(height: 8.0),
        if (_findAssetName() case final String asset)
          Image.asset(
            asset,
            height: AppResponsive.h(context, 48.0),
            fit: BoxFit.contain,
          ),
      ],
    );
  }

  String? _findAssetName() {
    return switch (nutriscore) {
      ProductNutriScore.A => 'res/drawables/nutriscore_a.png',
      ProductNutriScore.B => 'res/drawables/nutriscore_b.png',
      ProductNutriScore.C => 'res/drawables/nutriscore_c.png',
      ProductNutriScore.D => 'res/drawables/nutriscore_d.png',
      ProductNutriScore.E => 'res/drawables/nutriscore_e.png',
      ProductNutriScore.unknown => null,
    };
  }
}

class _NovaGroup extends StatelessWidget {
  const _NovaGroup({required this.novaScore});

  final ProductNovaScore novaScore;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          child: Text(
            'Groupe NOVA',
            style: TextStyle(
              color: const Color(0xFF080040),
              fontFamily: 'Avenir',
              fontSize: AppResponsive.sp(context, 15),
              fontWeight: FontWeight.w800,
              letterSpacing: -0.24,
            ),
          ),
        ),
        const SizedBox(height: 2.0),
        SizedBox(
          width: AppResponsive.w(context, 160),
          child: Text(
            _findLabel(),
            style: TextStyle(
              color: const Color(0xFFB8BBC6),
              fontFamily: 'Avenir',
              fontSize: AppResponsive.sp(context, 13),
              fontWeight: FontWeight.w400,
              letterSpacing: -0.21,
            ),
          ),
        ),
      ],
    );
  }

  String _findLabel() {
    return switch (novaScore) {
      ProductNovaScore.group1 =>
        'Aliments non transformés ou transformés minimalement',
      ProductNovaScore.group2 => 'Ingrédients culinaires transformés',
      ProductNovaScore.group3 => 'Aliments transformés',
      ProductNovaScore.group4 =>
        'Produits alimentaires et boissons ultra-transformés',
      ProductNovaScore.unknown => 'Score non calculé',
    };
  }
}

class _GreenScore extends StatelessWidget {
  const _GreenScore({required this.greenScore, this.start});

  final ProductGreenScore greenScore;
  final double? start;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'EcoScore',
          style: context.theme.title3.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: AppResponsive.sp(context, 16),
            fontFamily: 'Avenir',
            color: AppColors.blue,
          ),
        ),
        const SizedBox(height: 8.0),
        Padding(
          padding: EdgeInsetsDirectional.only(start: start ?? 0.0),
          child: Row(
            children: <Widget>[
              Icon(
                _findIcon(),
                color: _findIconColor(),
                size: AppResponsive.sp(context, 17.0),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  _findLabel(),
                  style: const TextStyle(color: AppColors.grey2),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _findIcon() {
    return switch (greenScore) {
      ProductGreenScore.aPlus => AppIcons.ecoscoreAPlus,
      ProductGreenScore.A => AppIcons.ecoscoreA,
      ProductGreenScore.B => AppIcons.ecoscoreB,
      ProductGreenScore.C => AppIcons.ecoscoreC,
      ProductGreenScore.D => AppIcons.ecoscoreD,
      ProductGreenScore.E => AppIcons.ecoscoreE,
      ProductGreenScore.F => AppIcons.ecoscoreF,
      ProductGreenScore.unknown => AppIcons.ecoscoreE,
    };
  }

  Color _findIconColor() {
    return switch (greenScore) {
      ProductGreenScore.aPlus => AppColors.greenScoreAPlus,
      ProductGreenScore.A => AppColors.greenScoreA,
      ProductGreenScore.B => AppColors.greenScoreB,
      ProductGreenScore.C => AppColors.greenScoreC,
      ProductGreenScore.D => AppColors.greenScoreD,
      ProductGreenScore.E => AppColors.greenScoreE,
      ProductGreenScore.F => AppColors.greenScoreF,
      ProductGreenScore.unknown => Colors.transparent,
    };
  }

  String _findLabel() {
    return switch (greenScore) {
      ProductGreenScore.aPlus => 'Très faible impact environnemental',
      ProductGreenScore.A => 'Très faible impact environnemental',
      ProductGreenScore.B => 'Faible impact environnemental',
      ProductGreenScore.C => "Impact modéré sur l'environnement",
      ProductGreenScore.D => 'Impact environnemental élevé',
      ProductGreenScore.E => 'Impact environnemental très élevé',
      ProductGreenScore.F => 'Impact environnemental très élevé',
      ProductGreenScore.unknown => 'Score non calculé',
    };
  }
}

class _Info extends StatelessWidget {
  const _Info();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final Product product = context.read<Product>();

    final String quantity = product.quantity?.trim() ?? '';
    final String manufacturing =
        product.manufacturingCountries?.join(', ').trim() ?? '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _ProductItemValue(
          label: 'Quantité',
          value: quantity.isNotEmpty ? quantity : 'Pas de données',
        ),
        SizedBox(height: AppResponsive.h(context, 12.0)),
        Container(
          width: AppResponsive.w(context, 319.0),
          height: 1.0,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: const Color(0xFFF6F6F8), width: 1.0),
            ),
          ),
        ),
        SizedBox(height: AppResponsive.h(context, 12.0)),
        _ProductItemValue(
          label: 'Vendu',
          value: manufacturing.isNotEmpty ? manufacturing : 'Pas de données',
          includeDivider: false,
        ),
        const SizedBox(height: 15.0),
        Row(
          children: <Widget>[
            Expanded(
              flex: 40,
              child: _ProductBubble(
                label: localizations.product_vegan,
                value: product.isVegan == ProductAnalysis.yes
                    ? _ProductBubbleValue.on
                    : _ProductBubbleValue.off,
              ),
            ),
            Spacer(flex: 10),
            Expanded(
              flex: 40,
              child: _ProductBubble(
                label: localizations.product_vegetarian,
                value: product.isVegetarian == ProductAnalysis.yes
                    ? _ProductBubbleValue.on
                    : _ProductBubbleValue.off,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProductItemValue extends StatelessWidget {
  const _ProductItemValue({
    required this.label,
    required this.value,
    this.includeDivider = true,
  });

  final String label;
  final String value;
  final bool includeDivider;

  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: const Color(0xFF080040),
                fontFamily: 'Avenir',
                fontSize: AppResponsive.sp(context, 15),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: const Color(0xFF6A6A6A),
                fontFamily: 'Avenir',
                fontSize: AppResponsive.sp(context, 15),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
    );
  }
}

class _ProductBubble extends StatelessWidget {
  const _ProductBubble({required this.label, required this.value});

  final String label;
  final _ProductBubbleValue value;

  @override
  Widget build(BuildContext context) {
    final bool isOn = value == _ProductBubbleValue.on;

    return Container(
      width: AppResponsive.w(context, 125.0),
      height: AppResponsive.h(context, 28.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2CC2DC),
        borderRadius: BorderRadius.circular(8.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SvgPicture.asset(
            isOn ? 'res/svg/validate.svg' : 'res/svg/error.svg',
            width: AppResponsive.w(context, isOn ? 14.0 : 12.0),
            height: AppResponsive.h(context, 12.0),
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.white,
                fontFamily: 'Avenir',
                fontSize: AppResponsive.sp(context, 11),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

enum _ProductBubbleValue { on, off }

class _RecallBanner extends StatelessWidget {
  const _RecallBanner({required this.recall});

  final ProductRecall recall;

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();

    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: AppResponsive.w(context, 17.0),
        end: AppResponsive.w(context, 13.0),
        bottom: AppResponsive.h(context, 8.0),
      ),
      child: InkWell(
        onTap: () => context.push(
          '/recall',
          extra: {'recall': recall, 'productImage': product.picture},
        ),
        child: Container(
          width: AppResponsive.w(context, 345.0),
          height: AppResponsive.h(context, 43.0),
          padding: EdgeInsetsDirectional.only(
            start: AppResponsive.w(context, 19.0),
            end: AppResponsive.w(context, 16.0),
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFF0000).withValues(alpha: 0.36),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Ce produit fait l\'objet d\'un rappel produit',
                  style: TextStyle(
                    color: const Color(0xFFA60000),
                    fontSize: AppResponsive.sp(context, 12),
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Avenir',
                  ),
                ),
              ),
              Transform.flip(
                flipX: true,
                child: SvgPicture.asset(
                  AppVectorialImages.goingBackArrow,
                  width: AppResponsive.w(context, 18),
                  height: AppResponsive.h(context, 16),
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFA60000),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
