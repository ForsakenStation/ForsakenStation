import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../services/keyboard_service.dart';
import '../../services/gamepad_service.dart';
import '../../services/locale_service.dart';
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

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.language),
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<LocaleProvider>(
                builder: (context, localeProvider, _) {
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 960),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount = constraints.maxWidth >= 820
                              ? 3
                              : constraints.maxWidth >= 560
                                  ? 2
                                  : 1;
                          return GridView.builder(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              mainAxisExtent: 68,
                            ),
                            itemCount: _localeOptions.length,
                            itemBuilder: (context, index) {
                              final locale = _localeOptions[index];
                              final isSelected = _localesMatch(
                                locale,
                                localeProvider.currentLocale,
                              );
                              final isFocused = _selectedIndex == index;
                              final colorScheme = Theme.of(context).colorScheme;
                              final code = locale?.languageCode.toUpperCase();

                              return Material(
                                color: colorScheme.surfaceContainerLow,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  side: BorderSide(
                                    color: isFocused
                                        ? Colors.white.withValues(alpha: 0.45)
                                        : isSelected
                                            ? const Color(
                                              0xFF0A84FF,
                                            ).withValues(alpha: 0.7)
                                            : Colors.white.withValues(
                                              alpha: 0.08,
                                            ),
                                    width: isFocused || isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () => _selectLocale(index),
                                  borderRadius: BorderRadius.circular(14),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 38,
                                          height: 38,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? const Color(
                                                  0xFF0A84FF,
                                                ).withValues(alpha: 0.16)
                                                : Colors.white.withValues(
                                                  alpha: 0.06,
                                                ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: code != null
                                              ? Text(
                                                  code,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 0.5,
                                                    color: isSelected
                                                        ? const Color(
                                                          0xFF0A84FF,
                                                        )
                                                        : colorScheme.onSurface
                                                            .withValues(
                                                              alpha: 0.85,
                                                            ),
                                                  ),
                                                )
                                              : Icon(
                                                  Icons.auto_awesome_rounded,
                                                  size: 18,
                                                  color: isSelected
                                                      ? const Color(0xFF0A84FF)
                                                      : colorScheme.onSurface
                                                          .withValues(
                                                            alpha: 0.85,
                                                          ),
                                                ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            _getLocaleDisplayName(locale),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  fontWeight: isSelected
                                                      ? FontWeight.w600
                                                      : FontWeight.w500,
                                                ),
                                          ),
                                        ),
                                        if (isSelected)
                                          const Icon(
                                            Icons.check_circle_rounded,
                                            size: 20,
                                            color: Color(0xFF0A84FF),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
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
