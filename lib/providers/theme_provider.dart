import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/debug_service.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeString = prefs.getString(_themeModeKey);

      if (themeModeString != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == themeModeString,
          orElse: () => ThemeMode.system,
        );
        DebugService.instance.info(
          'Loaded theme mode: $_themeMode',
          tag: 'ThemeProvider',
        );
        notifyListeners();
      }
    } catch (e) {
      DebugService.instance.error(
        'Failed to load theme mode',
        tag: 'ThemeProvider',
        error: e,
      );
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, mode.toString());
      DebugService.instance.info(
        'Saved theme mode: $mode',
        tag: 'ThemeProvider',
      );
    } catch (e) {
      DebugService.instance.error(
        'Failed to save theme mode',
        tag: 'ThemeProvider',
        error: e,
      );
    }
  }

  void toggleTheme() {
    switch (_themeMode) {
      case ThemeMode.system:
        setThemeMode(ThemeMode.light);
        break;
      case ThemeMode.light:
        setThemeMode(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        setThemeMode(ThemeMode.system);
        break;
    }
  }
}
