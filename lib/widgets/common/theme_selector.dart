import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../providers/theme_provider.dart';

/// A widget that allows users to select the theme mode (light, dark, or system)
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<ThemeMode>(
      icon: Icon(_getIconForThemeMode(themeProvider.themeMode)),
      tooltip: l10n.changeTheme,
      onSelected: (ThemeMode mode) {
        themeProvider.setThemeMode(mode);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ThemeMode>>[
        PopupMenuItem<ThemeMode>(
          value: ThemeMode.light,
          child: Row(
            children: [
              Icon(
                Icons.light_mode,
                color: themeProvider.themeMode == ThemeMode.light
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                l10n.lightTheme,
                style: TextStyle(
                  fontWeight: themeProvider.themeMode == ThemeMode.light
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<ThemeMode>(
          value: ThemeMode.dark,
          child: Row(
            children: [
              Icon(
                Icons.dark_mode,
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                l10n.darkTheme,
                style: TextStyle(
                  fontWeight: themeProvider.themeMode == ThemeMode.dark
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<ThemeMode>(
          value: ThemeMode.system,
          child: Row(
            children: [
              Icon(
                Icons.brightness_auto,
                color: themeProvider.themeMode == ThemeMode.system
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                l10n.systemTheme,
                style: TextStyle(
                  fontWeight: themeProvider.themeMode == ThemeMode.system
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getIconForThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
