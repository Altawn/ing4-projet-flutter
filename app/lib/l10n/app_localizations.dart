import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  static const List<Locale> supportedLocales = <Locale>[Locale('fr')];

  String get my_scans_screen_title;

  String get my_scans_screen_description;

  String get my_scans_screen_button;

  String get nova_group;

  String get nutriscore;

  String get greenscore;

  String get product_quantity;

  String get product_countries;

  String get product_vegan;

  String get product_vegetarian;

  String get product_tab_summary;

  String get product_tab_properties;

  String get product_tab_nutrition;

  String get product_tab_nutrition_facts;

  String get product_nutrition_facts_per_100g;

  String get product_nutrition_facts_per_serving;

  String get product_nutrition_facts_energy;

  String get product_nutrition_facts_fat;

  String get product_nutrition_facts_saturated_fats;

  String get product_nutrition_facts_carbohydrates;

  String get product_nutrition_facts_sugars;

  String get product_nutrition_facts_fiber;

  String get product_nutrition_facts_proteins;

  String get product_nutrition_facts_salt;

  String get product_nutrition_facts_sodium;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
