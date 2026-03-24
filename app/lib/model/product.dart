import 'package:formation_flutter/model/recall.dart';

class Product {
  final String barcode;
  final String? name;
  final String? altName;
  final String? picture;
  final String? quantity;
  final List<String>? brands;
  final List<String>? manufacturingCountries;
  final ProductNutriScore? nutriScore;
  final ProductNutriScoreLevels? nutriScoreLevels;
  final ProductNovaScore? novaScore;
  final ProductGreenScore? greenScore;
  final List<String>? ingredients;

  final String? ingredientsWithAllergens;
  final List<String>? traces;
  final List<String>? allergens;
  final Map<String, String>? additives;
  final NutrientLevels? nutrientLevels;
  final NutritionFacts? nutritionFacts;
  final bool? ingredientsFromPalmOil;
  final ProductRecall? recall;
  final ProductAnalysis? containsPalmOil;
  final ProductAnalysis? isVegan;
  final ProductAnalysis? isVegetarian;

  Product({
    required this.barcode,
    this.name,
    this.altName,
    this.picture,
    this.quantity,
    this.brands,
    this.manufacturingCountries,
    this.nutriScore,
    this.nutriScoreLevels,
    this.novaScore,
    this.greenScore,
    this.ingredients,
    this.ingredientsWithAllergens,
    this.traces,
    this.allergens,
    this.additives,
    this.nutrientLevels,
    this.nutritionFacts,
    this.ingredientsFromPalmOil,
    this.containsPalmOil,
    this.isVegan,
    this.isVegetarian,
    this.recall,
  });

  Product copyWith({
    String? barcode,
    String? name,
    String? altName,
    String? picture,
    String? quantity,
    List<String>? brands,
    List<String>? manufacturingCountries,
    ProductNutriScore? nutriScore,
    ProductNutriScoreLevels? nutriScoreLevels,
    ProductNovaScore? novaScore,
    ProductGreenScore? greenScore,
    List<String>? ingredients,
    String? ingredientsWithAllergens,
    List<String>? traces,
    List<String>? allergens,
    Map<String, String>? additives,
    NutrientLevels? nutrientLevels,
    NutritionFacts? nutritionFacts,
    bool? ingredientsFromPalmOil,
    ProductAnalysis? containsPalmOil,
    ProductAnalysis? isVegan,
    ProductAnalysis? isVegetarian,
    ProductRecall? recall,
  }) {
    return Product(
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      altName: altName ?? this.altName,
      picture: picture ?? this.picture,
      quantity: quantity ?? this.quantity,
      brands: brands ?? this.brands,
      manufacturingCountries:
          manufacturingCountries ?? this.manufacturingCountries,
      nutriScore: nutriScore ?? this.nutriScore,
      nutriScoreLevels: nutriScoreLevels ?? this.nutriScoreLevels,
      novaScore: novaScore ?? this.novaScore,
      greenScore: greenScore ?? this.greenScore,
      ingredients: ingredients ?? this.ingredients,
      ingredientsWithAllergens:
          ingredientsWithAllergens ?? this.ingredientsWithAllergens,
      traces: traces ?? this.traces,
      allergens: allergens ?? this.allergens,
      additives: additives ?? this.additives,
      nutrientLevels: nutrientLevels ?? this.nutrientLevels,
      nutritionFacts: nutritionFacts ?? this.nutritionFacts,
      ingredientsFromPalmOil:
          ingredientsFromPalmOil ?? this.ingredientsFromPalmOil,
      containsPalmOil: containsPalmOil ?? this.containsPalmOil,
      isVegan: isVegan ?? this.isVegan,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      recall: recall ?? this.recall,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      barcode: json['barcode'] as String,
      name: json['name'] as String?,
      altName: json['altName'] as String?,
      picture: json['pictures']?['front'] as String?,
      quantity: json['quantity'] as String?,
      brands: (json['brands'] as List<dynamic>?)?.cast<String>(),
      manufacturingCountries: (json['manufacturingCountries'] as List<dynamic>?)
          ?.cast<String>(),
      nutriScore: parseNutriScore(json['nutriScore']),
      nutriScoreLevels: json['levels'] != null
          ? ProductNutriScoreLevels.fromJson(json['levels'])
          : null,
      novaScore: _parseNovaScore(json['novaScore']),
      greenScore: _parseGreenScore(json['ecoScoreGrade']),
      ingredients: (json['ingredients']?['list'] as List<dynamic>?)
          ?.cast<String>(),
      ingredientsWithAllergens:
          json['ingredients']?['withAllergens'] as String?,
      traces: (json['traces']?['list'] as List<dynamic>?)?.cast<String>(),
      allergens: (json['allergens']?['list'] as List<dynamic>?)?.cast<String>(),
      additives: (json['additives'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as String),
      ),
      nutrientLevels: json['nutrientLevels'] != null
          ? NutrientLevels.fromJson(json['nutrientLevels'])
          : null,
      nutritionFacts: json['nutritionFacts'] != null
          ? NutritionFacts.fromJson(json['nutritionFacts'])
          : null,
      ingredientsFromPalmOil: json['ingredients']?['containsPalmOil'] as bool?,
      containsPalmOil: ProductAnalysis.fromString(json['analysis']?['palmOil']),
      isVegan: ProductAnalysis.fromString(json['analysis']?['vegan']),
      isVegetarian: ProductAnalysis.fromString(json['analysis']?['vegetarian']),
      recall: json['recall'] != null
          ? ProductRecall.fromJson(json['recall'])
          : null,
    );
  }

  factory Product.fromPocketBase(Map<String, dynamic> json) {
    return Product(
      barcode: json['gtin'] ?? '',
      name: json['libelle'] as String?,
      brands: [(json['marque_produit'] ?? '')],
      picture: json['picture'] as String?,
      nutriScore: parseNutriScore(json['nutriscore']),
      recall: json['recall'] != null
          ? ProductRecall.fromPocketBase(json['recall'])
          : null,
    );
  }

  static ProductNutriScore parseNutriScore(dynamic value) {
    return switch (value?.toString().toUpperCase()) {
      'A' => ProductNutriScore.A,
      'B' => ProductNutriScore.B,
      'C' => ProductNutriScore.C,
      'D' => ProductNutriScore.D,
      'E' => ProductNutriScore.E,
      _ => ProductNutriScore.unknown,
    };
  }

  static ProductNovaScore _parseNovaScore(dynamic value) {
    return switch (value) {
      1 => ProductNovaScore.group1,
      2 => ProductNovaScore.group2,
      3 => ProductNovaScore.group3,
      4 => ProductNovaScore.group4,
      _ => ProductNovaScore.unknown,
    };
  }

  static ProductGreenScore _parseGreenScore(dynamic value) {
    return switch (value?.toString().toLowerCase()) {
      'a+' => ProductGreenScore.aPlus,
      'a' => ProductGreenScore.A,
      'b' => ProductGreenScore.B,
      'c' => ProductGreenScore.C,
      'd' => ProductGreenScore.D,
      'e' => ProductGreenScore.E,
      'f' => ProductGreenScore.F,
      _ => ProductGreenScore.unknown,
    };
  }
}

class NutritionFacts {
  final String servingSize;
  final Nutriment? calories;
  final Nutriment? fat;
  final Nutriment? saturatedFat;
  final Nutriment? carbohydrate;
  final Nutriment? sugar;
  final Nutriment? fiber;
  final Nutriment? proteins;
  final Nutriment? sodium;
  final Nutriment? salt;
  final Nutriment? energy;

  NutritionFacts({
    required this.servingSize,
    this.calories,
    this.fat,
    this.saturatedFat,
    this.carbohydrate,
    this.sugar,
    this.fiber,
    this.proteins,
    this.sodium,
    this.salt,
    this.energy,
  });

  factory NutritionFacts.fromJson(Map<String, dynamic> json) {
    return NutritionFacts(
      servingSize: json['servingSize'] as String? ?? '',
      calories: json['calories'] != null
          ? Nutriment.fromJson(json['calories'])
          : null,
      fat: json['fat'] != null ? Nutriment.fromJson(json['fat']) : null,
      saturatedFat: json['saturatedFat'] != null
          ? Nutriment.fromJson(json['saturatedFat'])
          : null,
      carbohydrate: json['carbohydrate'] != null
          ? Nutriment.fromJson(json['carbohydrate'])
          : null,
      sugar: json['sugar'] != null ? Nutriment.fromJson(json['sugar']) : null,
      fiber: json['fiber'] != null ? Nutriment.fromJson(json['fiber']) : null,
      proteins: json['proteins'] != null
          ? Nutriment.fromJson(json['proteins'])
          : null,
      sodium: json['sodium'] != null
          ? Nutriment.fromJson(json['sodium'])
          : null,
      salt: json['salt'] != null ? Nutriment.fromJson(json['salt']) : null,
      energy: json['energy'] != null
          ? Nutriment.fromJson(json['energy'])
          : null,
    );
  }
}

class Nutriment {
  final String unit;
  final dynamic perServing;
  final dynamic per100g;

  Nutriment({required this.unit, this.perServing, this.per100g});

  factory Nutriment.fromJson(Map<String, dynamic> json) {
    return Nutriment(
      unit: json['unit'] as String? ?? '',
      perServing: json['perServing'],
      per100g: json['per100g'],
    );
  }
}

class NutrientLevels {
  final String? salt;
  final String? saturatedFat;
  final String? sugars;
  final String? fat;

  NutrientLevels({this.salt, this.saturatedFat, this.sugars, this.fat});

  factory NutrientLevels.fromJson(Map<String, dynamic> json) {
    return NutrientLevels(
      salt: json['salt']?['level'] as String?,
      saturatedFat: json['saturatedFat']?['level'] as String?,
      sugars: json['sugars']?['level'] as String?,
      fat: json['fat']?['level'] as String?,
    );
  }
}

class ProductNutriScoreLevels {
  final ProductNutriScoreLevel? energy;
  final ProductNutriScoreLevel? fiber;
  final ProductNutriScoreLevel? fruitsVegetablesLegumes;
  final ProductNutriScoreLevel? proteins;
  final ProductNutriScoreLevel? salt;
  final ProductNutriScoreLevel? saturatedFat;
  final ProductNutriScoreLevel? sugars;

  ProductNutriScoreLevels({
    required this.energy,
    required this.fiber,
    required this.fruitsVegetablesLegumes,
    required this.proteins,
    required this.salt,
    required this.saturatedFat,
    required this.sugars,
  });

  factory ProductNutriScoreLevels.fromJson(Map<String, dynamic> json) {
    return ProductNutriScoreLevels(
      energy: json['energy'] != null
          ? ProductNutriScoreLevel.fromJson(json['energy'])
          : null,
      fiber: json['fiber'] != null
          ? ProductNutriScoreLevel.fromJson(json['fiber'])
          : null,
      fruitsVegetablesLegumes: json['fruitsVegetablesLegumes'] != null
          ? ProductNutriScoreLevel.fromJson(json['fruitsVegetablesLegumes'])
          : null,
      proteins: json['proteins'] != null
          ? ProductNutriScoreLevel.fromJson(json['proteins'])
          : null,
      salt: json['salt'] != null
          ? ProductNutriScoreLevel.fromJson(json['salt'])
          : null,
      saturatedFat: json['saturatedFat'] != null
          ? ProductNutriScoreLevel.fromJson(json['saturatedFat'])
          : null,
      sugars: json['sugars'] != null
          ? ProductNutriScoreLevel.fromJson(json['sugars'])
          : null,
    );
  }
}

class ProductNutriScoreLevel {
  final double points;
  final double maxPoints;
  final String unit;
  final double value;
  final ProductNutriScoreLevelType type;

  ProductNutriScoreLevel({
    required this.points,
    required this.maxPoints,
    required this.unit,
    required this.value,
    required this.type,
  });

  factory ProductNutriScoreLevel.fromJson(Map<String, dynamic> json) {
    return ProductNutriScoreLevel(
      points: (json['points'] as num?)?.toDouble() ?? 0,
      maxPoints: (json['maxPoints'] as num?)?.toDouble() ?? 0,
      unit: json['unit'] as String? ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0,
      type: _parseType(json['type']),
    );
  }

  static ProductNutriScoreLevelType _parseType(dynamic value) {
    return switch (value?.toString().toLowerCase()) {
      'positive' => ProductNutriScoreLevelType.positive,
      'negative' => ProductNutriScoreLevelType.negative,
      _ => ProductNutriScoreLevelType.unknown,
    };
  }
}

enum ProductNutriScoreLevelType { positive, negative, unknown }

enum ProductNutriScore { A, B, C, D, E, unknown }

enum ProductNovaScore { group1, group2, group3, group4, unknown }

enum ProductGreenScore { A, aPlus, B, C, D, E, F, unknown }

enum ProductAnalysis {
  yes,
  no,
  maybe;

  static ProductAnalysis fromString(String? analysis) {
    return switch (analysis) {
      'yes' => ProductAnalysis.yes,
      'no' => ProductAnalysis.no,
      'maybe' => ProductAnalysis.maybe,
      _ => ProductAnalysis.maybe,
    };
  }
}
