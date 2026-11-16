import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../services/debug_service.dart';
import '../../services/gamepad_service.dart';
import '../../services/keyboard_service.dart';
import '../../widgets/common/animated_lucide_icon.dart';
import '../../widgets/common/controls_bottom_bar.dart';

/// Full-screen Debug Mode configuration view.
class DebugSettingsScreen extends StatefulWidget {
  const DebugSettingsScreen({super.key});

  @override
  State<DebugSettingsScreen> createState() => _DebugSettingsScreenState();
}

class _DebugSettingsScreenState extends State<DebugSettingsScreen> {
  final _focusNode = FocusNode();
  final _gamepadService = GamepadService.instance;
  final _keyboardService = KeyboardService.instance;
  Timer? _gamepadTimer;
  DateTime _lastInputTime = DateTime.now();
  bool _isHoveredOrFocused = false;

  @override
  void initState() {
    super.initState();
    _gamepadTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => _pollGamepad(),
    );
  }

  @override
  void dispose() {
    _gamepadTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleDebug() {
    setState(() {
      DebugService.instance.toggleDebug();
    });
  }

  void _pollGamepad() {
    if (!mounted || !_gamepadService.isGamepadConnected) return;
    final now = DateTime.now();
    if (now.difference(_lastInputTime).inMilliseconds < 200) return;

    if (_gamepadService.isButtonPressed(GamepadService.buttonB)) {
      _lastInputTime = now;
      Navigator.of(context).pop();
    } else if (_gamepadService.isButtonPressed(GamepadService.buttonA)) {
      _lastInputTime = now;
      _toggleDebug();
    }
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (_keyboardService.isBackKey(event.logicalKey)) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }
    if (_keyboardService.isSelectKey(event.logicalKey)) {
      _toggleDebug();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = DebugService.instance.isDebugEnabled;
    final statusColor = isEnabled
        ? const Color(0xFF30D158)
        : colorScheme.onSurface.withValues(alpha: 0.55);

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (_, event) => _handleKeyEvent(event),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.debugMode.replaceAll(':', '').trim())),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Material(
                      color: colorScheme.surfaceContainerLow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.14),
                          width: 1.2,
                        ),
                      ),
                      child: InkWell(
                        onTap: _toggleDebug,
                        onHover: (hovered) =>
                            setState(() => _isHoveredOrFocused = hovered),
                        onFocusChange: (focused) =>
                            setState(() => _isHoveredOrFocused = focused),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.07),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: AnimatedLucideIcon(
                                  type: AnimatedLucideIconType.bug,
                                  size: 26,
                                  animate: _isHoveredOrFocused || isEnabled,
                                  color: isEnabled
                                      ? const Color(0xFF30D158)
                                      : colorScheme.onSurface.withValues(
                                          alpha: 0.8,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.debugMode
                                          .replaceAll(':', '')
                                          .trim(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isEnabled
                                            ? const Color(
                                                0xFF30D158,
                                              ).withValues(alpha: 0.14)
                                            : Colors.white.withValues(
                                                alpha: 0.07,
                                              ),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                      child: Text(
                                        isEnabled
                                            ? l10n.enabled
                                            : l10n.disabled,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: statusColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: isEnabled,
                                onChanged: (_) => _toggleDebug(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ControlsBottomBar(
              actions: [
                BottomBarAction(
                  label: l10n.back,
                  keyboardKey: 'ESC',
                  gamepadButton: 'B',
                ),
                BottomBarAction(
                  label: l10n.toggleDebugMode,
                  keyboardKey: 'Enter',
                  gamepadButton: 'A',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
