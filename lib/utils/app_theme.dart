import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom color schemes for the app
class AppColors {
  // Light Theme Colors
  static const lightPrimary = Color(0xFF6750A4);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightPrimaryContainer = Color(0xFFEADDFF);
  static const lightOnPrimaryContainer = Color(0xFF21005D);

  static const lightSecondary = Color(0xFF625B71);
  static const lightOnSecondary = Color(0xFFFFFFFF);
  static const lightSecondaryContainer = Color(0xFFE8DEF8);
  static const lightOnSecondaryContainer = Color(0xFF1D192B);

  static const lightTertiary = Color(0xFF7D5260);
  static const lightOnTertiary = Color(0xFFFFFFFF);
  static const lightTertiaryContainer = Color(0xFFFFD8E4);
  static const lightOnTertiaryContainer = Color(0xFF31111D);

  static const lightSurface = Color(0xFFFFFBFE);
  static const lightOnSurface = Color(0xFF1C1B1F);
  static const lightSurfaceVariant = Color(0xFFE7E0EC);
  static const lightOnSurfaceVariant = Color(0xFF49454F);

  static const lightBackground = Color(0xFFFFFBFE);
  static const lightOnBackground = Color(0xFF1C1B1F);

  static const lightError = Color(0xFFB3261E);
  static const lightOnError = Color(0xFFFFFFFF);

  // Dark Theme Colors
  static const darkPrimary = Color(0xFFD0BCFF);
  static const darkOnPrimary = Color(0xFF381E72);
  static const darkPrimaryContainer = Color(0xFF4F378B);
  static const darkOnPrimaryContainer = Color(0xFFEADDFF);

  static const darkSecondary = Color(0xFFCCC2DC);
  static const darkOnSecondary = Color(0xFF332D41);
  static const darkSecondaryContainer = Color(0xFF4A4458);
  static const darkOnSecondaryContainer = Color(0xFFE8DEF8);

  static const darkTertiary = Color(0xFFEFB8C8);
  static const darkOnTertiary = Color(0xFF492532);
  static const darkTertiaryContainer = Color(0xFF633B48);
  static const darkOnTertiaryContainer = Color(0xFFFFD8E4);

  static const darkSurface = Color(0xFF1C1B1F);
  static const darkOnSurface = Color(0xFFE6E1E5);
  static const darkSurfaceVariant = Color(0xFF49454F);
  static const darkOnSurfaceVariant = Color(0xFFCAC4D0);

  static const darkBackground = Color(0xFF1C1B1F);
  static const darkOnBackground = Color(0xFFE6E1E5);

  static const darkError = Color(0xFFF2B8B5);
  static const darkOnError = Color(0xFF601410);
}

/// App theme definitions
class AppTheme {
  /// Light theme
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.lightPrimary,
        onPrimary: AppColors.lightOnPrimary,
        primaryContainer: AppColors.lightPrimaryContainer,
        onPrimaryContainer: AppColors.lightOnPrimaryContainer,
        secondary: AppColors.lightSecondary,
        onSecondary: AppColors.lightOnSecondary,
        secondaryContainer: AppColors.lightSecondaryContainer,
        onSecondaryContainer: AppColors.lightOnSecondaryContainer,
        tertiary: AppColors.lightTertiary,
        onTertiary: AppColors.lightOnTertiary,
        tertiaryContainer: AppColors.lightTertiaryContainer,
        onTertiaryContainer: AppColors.lightOnTertiaryContainer,
        error: AppColors.lightError,
        onError: AppColors.lightOnError,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightOnSurface,
        surfaceContainerHighest: AppColors.lightSurfaceVariant,
        onSurfaceVariant: AppColors.lightOnSurfaceVariant,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.lightOnSurface,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: AppColors.lightSurfaceVariant.withOpacity(0.3),
      ),
      fontFamily: GoogleFonts.orbitron().fontFamily,
    );
  }

  /// Dark theme
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkOnPrimary,
        primaryContainer: AppColors.darkPrimaryContainer,
        onPrimaryContainer: AppColors.darkOnPrimaryContainer,
        secondary: AppColors.darkSecondary,
        onSecondary: AppColors.darkOnSecondary,
        secondaryContainer: AppColors.darkSecondaryContainer,
        onSecondaryContainer: AppColors.darkOnSecondaryContainer,
        tertiary: AppColors.darkTertiary,
        onTertiary: AppColors.darkOnTertiary,
        tertiaryContainer: AppColors.darkTertiaryContainer,
        onTertiaryContainer: AppColors.darkOnTertiaryContainer,
        error: AppColors.darkError,
        onError: AppColors.darkOnError,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
        surfaceContainerHighest: AppColors.darkSurfaceVariant,
        onSurfaceVariant: AppColors.darkOnSurfaceVariant,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkOnSurface,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: AppColors.darkSurfaceVariant.withOpacity(0.3),
      ),
      fontFamily: GoogleFonts.orbitron().fontFamily,
    );
  }
}
