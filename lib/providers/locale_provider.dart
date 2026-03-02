import 'package:flutter/material.dart';

import '../services/locale_service.dart';

class LocaleProvider extends ChangeNotifier {
  final LocaleService _localeService = LocaleService.instance;

  Locale? get currentLocale => _localeService.currentLocale;

  Future<void> setLocale(Locale? locale) async {
    await _localeService.setLocale(locale);
    notifyListeners();
  }

  Future<void> resetToSystem() async {
    await _localeService.setLocale(null);
    notifyListeners();
  }

  static String getLocaleName(Locale? locale) {
    if (locale == null) {
      return 'System default';
    }
    return LocaleService.getLocaleName(locale.languageCode);
  }
}
