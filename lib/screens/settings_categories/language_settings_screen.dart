import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../services/keyboard_service.dart';
import '../../services/gamepad_service.dart';
import '../../services/locale_service.dart';
import '../../models/language_info.dart';
import '../../providers/locale_provider.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../widgets/common/controls_bottom_bar.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  final _keyboardService = KeyboardService.instance;
  final _focusNode = FocusNode();
  int _selectedIndex = 0;
  // ignore: unused_field - used for visual feedback in card rendering
  bool _isGamepadNavigating = false;

  List<Locale?> get _localeOptions {
    return [null, ...LocaleService.supportedLocales];
  }

  @override
  void initState() {
    super.initState();
    _initializeSelection();
    _startGamepadPolling();
  }

  void _initializeSelection() {
    final currentLocale = context.read<LocaleProvider>().currentLocale;
    final options = _localeOptions;
    for (int i = 0; i < options.length; i++) {
      if (_localesMatch(options[i], currentLocale)) {
        setState(() {
          _selectedIndex = i;
        });
        break;
      }
    }
  }

  bool _localesMatch(Locale? a, Locale? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    return a.languageCode == b.languageCode && a.countryCode == b.countryCode;
  }

  @override
  void dispose() {
    _stopGamepadPolling();
    _focusNode.dispose();
    super.dispose();
  }

  void _startGamepadPolling() {
    Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!mounted) return;
      final gamepad = GamepadService.instance;
      final direction = gamepad.getNavigationDirection();
      if (direction != null) {
        setState(() {
          _isGamepadNavigating = true;
          if (direction == 'up') {
            _selectedIndex = (_selectedIndex - 1) % _localeOptions.length;
            if (_selectedIndex < 0) _selectedIndex = _localeOptions.length - 1;
          } else if (direction == 'down') {
            _selectedIndex = (_selectedIndex + 1) % _localeOptions.length;
          }
        });
      }
    });
  }

  void _stopGamepadPolling() {
    // Timer will be cancelled automatically when widget is disposed
  }

  void _selectLocale(int index) {
    setState(() {
      _selectedIndex = index;
      _isGamepadNavigating = false;
    });
    final locale = _localeOptions[index];
    context.read<LocaleProvider>().setLocale(locale);
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    if (_keyboardService.isSelectKey(key)) {
      _selectLocale(_selectedIndex);
      return KeyEventResult.handled;
    }

    if (_keyboardService.isBackKey(key)) {
      Navigator.pop(context);
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.arrowUp) {
      setState(() {
        _selectedIndex = (_selectedIndex - 1) % _localeOptions.length;
        if (_selectedIndex < 0) _selectedIndex = _localeOptions.length - 1;
      });
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.arrowDown) {
      setState(() {
        _selectedIndex = (_selectedIndex + 1) % _localeOptions.length;
      });
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  String _getLocaleDisplayName(Locale? locale) {
    if (locale == null) {
      return AppLocalizations.of(context)!.systemDefault;
    }
    return LocaleService.getLocaleName(locale.languageCode);
  }

  String? _getLocaleFlag(Locale? locale) {
    if (locale == null) return null;
    return LanguageInfo.getFlag(locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.language),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<LocaleProvider>(
                builder: (context, localeProvider, _) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _localeOptions.length,
                    itemBuilder: (context, index) {
                      final locale = _localeOptions[index];
                      final isSelected = _localesMatch(
                        locale,
                        localeProvider.currentLocale,
                      );
                      final isFocused = _selectedIndex == index;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Card(
                          elevation: isFocused ? 8 : (isSelected ? 4 : 1),
                          color: isFocused
                              ? Theme.of(context).colorScheme.primaryContainer
                              : (isSelected
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.secondaryContainer
                                    : null),
                          child: InkWell(
                            onTap: () => _selectLocale(index),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  if (_getLocaleFlag(locale) != null)
                                    Text(
                                      _getLocaleFlag(locale)!,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontFamily: 'Noto Color Emoji',
                                        fontFamilyFallback: [
                                          'Apple Color Emoji',
                                          'Segoe UI Emoji',
                                          'Noto Color Emoji',
                                          'Twemoji Mozilla',
                                        ],
                                      ),
                                    )
                                  else
                                    const Icon(
                                      Icons.settings_suggest,
                                      size: 28,
                                    ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      _getLocaleDisplayName(locale),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            ControlsBottomBar(
              actions: [
                BottomBarAction(
                  label: AppLocalizations.of(context)!.back,
                  keyboardKey: 'ESC',
                  gamepadButton: 'B',
                ),
                BottomBarAction(
                  label: AppLocalizations.of(context)!.select,
                  keyboardKey: 'Enter',
                  gamepadButton: 'A',
                ),
              ],
              counterText: '${_selectedIndex + 1} / ${_localeOptions.length}',
            ),
          ],
        ),
      ),
    );
  }
}
