import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'debug_service.dart';

class LocaleService {
  static LocaleService? _instance;
  static const String _localeKey = 'forsaken_locale';

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('es'),
    Locale('pt'),
    Locale('fr'),
    Locale('de'),
    Locale('it'),
    Locale('ja'),
    Locale('zh'),
    Locale('ko'),
    Locale('ar'),
    Locale('ru'),
    Locale('ca'),
    Locale('eu'),
    Locale('gl'),
  ];

  static const Map<String, String> localeNames = {
    'en': 'English',
    'es': 'Español',
    'pt': 'Português',
    'fr': 'Français',
    'de': 'Deutsch',
    'it': 'Italiano',
    'ja': '日本語',
    'zh': '中文',
    'ko': '한국어',
    'ar': 'العربية',
    'ru': 'Русский',
    'ca': 'Català',
    'eu': 'Euskera',
    'gl': 'Galego',
  };

  static const Map<String, String> localeCountryCodes = {
    'en': 'US',
    'es': 'ES',
    'pt': 'BR',
    'fr': 'FR',
    'de': 'DE',
    'it': 'IT',
    'ja': 'JP',
    'zh': 'CN',
    'ko': 'KR',
    'ar': 'SA',
    'ru': 'RU',
    'ca': 'CA',
    'eu': 'EU',
    'gl': 'GL',
  };

  Locale? _currentLocale;

  LocaleService._();

  static LocaleService get instance {
    _instance ??= LocaleService._();
    return _instance!;
  }

  Locale? get currentLocale => _currentLocale;

  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeCode = prefs.getString(_localeKey);

      if (localeCode != null && localeCode.isNotEmpty) {
        final parts = localeCode.split('_');
        if (parts.length == 2) {
          _currentLocale = Locale(parts[0], parts[1]);
        } else {
          _currentLocale = Locale(parts[0]);
        }
        DebugService.instance.info(
          'Locale loaded: $localeCode',
          tag: 'LocaleService',
        );
      } else {
        DebugService.instance.info(
          'No locale saved, using system default',
          tag: 'LocaleService',
        );
      }
    } catch (e) {
      DebugService.instance.error(
        'Error initializing LocaleService: $e',
        tag: 'LocaleService',
      );
    }
  }

  Future<void> setLocale(Locale? locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentLocale = locale;

      if (locale == null) {
        await prefs.remove(_localeKey);
        DebugService.instance.info(
          'Locale reset to system default',
          tag: 'LocaleService',
        );
      } else {
        final localeString = locale.countryCode != null
            ? '${locale.languageCode}_${locale.countryCode}'
            : locale.languageCode;
        await prefs.setString(_localeKey, localeString);
        DebugService.instance.info(
          'Locale set to: $localeString',
          tag: 'LocaleService',
        );
      }
    } catch (e) {
      DebugService.instance.error(
        'Error saving locale: $e',
        tag: 'LocaleService',
      );
    }
  }

  static String getLocaleName(String languageCode) {
    return localeNames[languageCode] ?? languageCode;
  }

  static Locale? localeFromCode(String code) {
    final parts = code.split('_');
    if (parts.length == 2) {
      return Locale(parts[0], parts[1]);
    }
    return Locale(parts[0]);
  }
}
