import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_responsive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductTab3 extends StatelessWidget {
  const ProductTab3({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();
    if (product.nutritionFacts == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: DefaultTextStyle.merge(
            style: const TextStyle(color: AppColors.blueDark, fontSize: 16),
            child: Table(
              border: const TableBorder(
                horizontalInside: BorderSide(color: Color(0xFFF3F3F7), width: 1.0),
                verticalInside: BorderSide(color: Color(0xFFF3F3F7), width: 1.0),
              ),
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
              },
              children: _body(context, product.nutritionFacts!),
            ),
          ),
        ),
      ],
    );
  }

  List<TableRow> _body(BuildContext context, NutritionFacts nutritionFacts) {
    final NumberFormat numberFormat = NumberFormat.decimalPatternDigits(
      locale: Localizations.localeOf(context).countryCode ?? 'fr',
      decimalDigits: 1,
    );

    final List<TableRow> rows = <TableRow>[];

    rows.add(
      TableRow(
        children: <Widget>[
          const TableCell(child: SizedBox.shrink()),
          _NutritionFactsValue(
            text: 'Pour 100g', 
            isHeader: true,
          ),
          _NutritionFactsValue(
            text: 'Par part', 
            isHeader: true,
          ),
        ],
      ),
    );

    rows.add(
      _generateCell(
        numberFormat,
        'Énergie',
        nutritionFacts.energy ?? nutritionFacts.calories,
      ),
    );
    rows.add(
      _generateCell(
        numberFormat,
        'Matières grasses',
        nutritionFacts.fat,
      ),
    );
    rows.add(
      _generateCell(
        numberFormat,
        'dont Acides gras saturés',
        nutritionFacts.saturatedFat,
      ),
    );
    rows.add(
      _generateCell(
        numberFormat,
        'Glucides',
        nutritionFacts.carbohydrate,
      ),
    );
    rows.add(
      _generateCell(
        numberFormat,
        'dont Sucres',
        nutritionFacts.sugar,
      ),
    );
    rows.add(
      _generateCell(
        numberFormat,
        'Fibres alimentaires',
        nutritionFacts.fiber,
      ),
    );
    rows.add(
      _generateCell(
        numberFormat,
        'Protéines',
        nutritionFacts.proteins,
      ),
    );
    rows.add(
      _generateCell(
        numberFormat,
        'Sel',
        nutritionFacts.salt,
      ),
    );
    rows.add(
      _generateCell(
        numberFormat,
        'Sodium',
        nutritionFacts.sodium,
      ),
    );

    return rows;
  }

  TableRow _generateCell(
    NumberFormat numberFormat,
    String label,
    Nutriment? nutriment,
  ) {
    String formatField(dynamic field, String unit) {
      if (field == null) {
        return '?';
      } else if (field is num) {
        return '${numberFormat.format(field)} $unit';
      } else {
        return '$field $unit';
      }
    }

    return TableRow(
      children: <Widget>[
        _NutritionFactsTitle(text: label),
        _NutritionFactsValue(
          text: nutriment == null ? '?' : formatField(nutriment.per100g, nutriment.unit),
        ),
        _NutritionFactsValue(
          text: nutriment == null ? '?' : formatField(nutriment.perServing, nutriment.unit),
        ),
      ],
    );
  }
}

class _NutritionFactsValue extends StatelessWidget {
  const _NutritionFactsValue({required this.text, this.isHeader = false});

  final String text;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 16.0,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFF080040),
          fontFamily: 'Avenir',
          fontSize: 15,
          fontWeight: isHeader ? FontWeight.w500 : FontWeight.w400,
          height: 23 / 15,
        ),
      ),
    );
  }
}

class _NutritionFactsTitle extends StatelessWidget {
  const _NutritionFactsTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Color(0xFF080040),
          fontFamily: 'Avenir',
          fontSize: 15,
          fontWeight: FontWeight.w500,
          height: 23 / 15,
        ),
      ),
    );
  }
}

extension ProductNutrimentsExtension on Product {}
