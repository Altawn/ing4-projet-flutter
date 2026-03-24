import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: AppColors.blueDark, fontSize: 16),
        child: Table(
          border: const TableBorder(
            horizontalInside: BorderSide(color: AppColors.grey1, width: 1.0),
            verticalInside: BorderSide(color: AppColors.grey1, width: 1.0),
          ),
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
          },
          children: _body(context, product.nutritionFacts!),
        ),
      ),
    );
  }

  List<TableRow> _body(BuildContext context, NutritionFacts nutritionFacts) {
    final NumberFormat numberFormat = NumberFormat.decimalPatternDigits(
      locale: Localizations.localeOf(context).countryCode ?? 'fr',
      decimalDigits: 1,
    );

    final List<TableRow?> rows = <TableRow?>[];

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
        indent: true,
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
        indent: true,
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

    return rows.nonNulls.toList(growable: false);
  }

  TableRow? _generateCell(
    NumberFormat numberFormat,
    String label,
    Nutriment? nutriment, {
    bool indent = false,
  }) {
    if (nutriment == null) {
      return null;
    }

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
        _NutritionFactsTitle(text: label, indent: indent),
        _NutritionFactsValue(
          text: formatField(nutriment.per100g, nutriment.unit),
        ),
        _NutritionFactsValue(
          text: formatField(nutriment.perServing, nutriment.unit),
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
          color: AppColors.blueDark,
          fontWeight: isHeader ? FontWeight.normal : FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _NutritionFactsTitle extends StatelessWidget {
  const _NutritionFactsTitle({required this.text, this.indent = false});

  final String text;
  final bool indent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: indent ? 20.0 : 8.0,
        right: 8.0,
        top: 16.0,
        bottom: 16.0,
      ),
      child: Text(
        text, 
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.blueDark,
          fontSize: 16,
        ),
      ),
    );
  }
}

extension ProductNutrimentsExtension on Product {}
