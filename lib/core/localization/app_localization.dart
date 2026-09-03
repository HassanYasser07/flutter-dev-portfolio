import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Supported locales and helpers for the locale switcher.
class AppLocalization {
  const AppLocalization._();

  static const String translationsPath = 'assets/translations';

  static const Locale fallbackLocale = Locale('en');

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
    Locale('fr'),
    Locale('de'),
  ];

  static const Map<String, String> languageLabels = {
    'en': 'locale.en',
    'ar': 'locale.ar',
    'fr': 'locale.fr',
    'de': 'locale.de',
  };

  static Future<void> setLocale(BuildContext context, Locale locale) {
    return context.setLocale(locale);
  }

  static Locale cycle(Locale current) {
    final index = supportedLocales.indexWhere(
      (locale) => locale.languageCode == current.languageCode,
    );
    final next = (index + 1) % supportedLocales.length;
    return supportedLocales[next];
  }

  static String codeOf(Locale locale) => locale.languageCode.toUpperCase();
}
