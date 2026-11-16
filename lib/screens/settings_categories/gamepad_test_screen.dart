import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/gamepad_service.dart';
import '../../services/keyboard_service.dart';
import '../../widgets/common/animated_lucide_icon.dart';
import '../../widgets/common/controls_bottom_bar.dart';
import '../../l10n/generated/app_localizations.dart';

/// Screen for testing and debugging gamepad input
/// Shows real-time button states and axis values
class GamepadTestScreen extends StatefulWidget {
  const GamepadTestScreen({super.key, this.debugForceConnected});

  @visibleForTesting
  final bool? debugForceConnected;

  @override
  State<GamepadTestScreen> createState() => _GamepadTestScreenState();
}

class _GamepadTestScreenState extends State<GamepadTestScreen> {
  final _gamepadService = GamepadService.instance;
  final _keyboardService = KeyboardService.instance;
  final _focusNode = FocusNode();
  Timer? _updateTimer;
  Map<String, bool> _buttonStates = {};
  Map<String, double> _axisValues = {};
  String? _lastAction;
  bool _exitComboPressed = false;

  @override
  void initState() {
    super.initState();
    // Enable debug mode to prevent actions
    _gamepadService.setDebugMode(true);
    if (widget.debugForceConnected == true) {
      _buttonStates = {
        '0': true,
        '1': false,
        '2': false,
        '3': false,
      };
      _axisValues = {
        '0': 0.65,
        '1': -0.25,
        '2': 0.0,
        '3': 0.0,
      };
      _lastAction = 'A (Select)';
    } else {
      _startPolling();
    }
  }

  @override
  void dispose() {
    // Disable debug mode when leaving
    _gamepadService.setDebugMode(false);
    _updateTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _startPolling() {
    _updateTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!mounted) return;

      // Check for exit combination (Start + Select) - both must be held
      // Use isButtonPressed to detect simultaneous hold, not edge detection
      final startPressed = _gamepadService.isButtonPressed(
        GamepadService.buttonStart,
      );
      final selectPressed = _gamepadService.isButtonPressed(
        GamepadService.buttonSelect,
      );

      if (startPressed && selectPressed) {
        if (!_exitComboPressed) {
          _exitComboPressed = true;
          // Delay to ensure we don't trigger other actions
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          });
        }
        return;
      } else {
        _exitComboPressed = false;
      }

      setState(() {
        _buttonStates = _gamepadService.getAllButtonStates();
        _axisValues = _gamepadService.getAllAxisValues();
      });

      // Update previous states for edge detection
      _gamepadService.updatePreviousButtonStates();
    });
  }

  void _testAction(String action) {
    // Only visual feedback, no actual actions executed
    setState(() {
      _lastAction = action;
    });
    // Clear after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          if (_lastAction == action) _lastAction = null;
        });
      }
    });
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    // Handle ESC to go back (always works, even without gamepad)
    if (_keyboardService.isBackKey(key)) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  /// Calculate navigation direction for D-pad + Left Stick
  /// This bypasses the debug mode block in GamepadService
  String? _getLeftNavigationDirection() {
    const deadzone = 0.3;

    // Check D-pad axes first (digital input has priority)
    final dpadX = _axisValues[GamepadService.axisDpadX] ?? 0.0;
    final dpadY = _axisValues[GamepadService.axisDpadY] ?? 0.0;

    if (dpadY < -deadzone) return 'up';
    if (dpadY > deadzone) return 'down';
    if (dpadX < -deadzone) return 'left';
    if (dpadX > deadzone) return 'right';

    // Then check left analog stick
    final leftX = _axisValues[GamepadService.axisLeftX] ?? 0.0;
    final leftY = _axisValues[GamepadService.axisLeftY] ?? 0.0;

    // Determine primary direction (only one at a time for navigation)
    if (leftY.abs() > leftX.abs()) {
      // Vertical movement
      if (leftY < -deadzone) return 'up';
      if (leftY > deadzone) return 'down';
    } else {
      // Horizontal movement
      if (leftX < -deadzone) return 'left';
      if (leftX > deadzone) return 'right';
    }

    return null;
  }

  /// Calculate navigation direction for Right Stick only
  String? _getRightNavigationDirection() {
    const deadzone = 0.3;

    final rightX = _axisValues[GamepadService.axisRightX] ?? 0.0;
    final rightY = _axisValues[GamepadService.axisRightY] ?? 0.0;

    // Determine primary direction
    if (rightY.abs() > rightX.abs()) {
      // Vertical movement
      if (rightY < -deadzone) return 'up';
      if (rightY > deadzone) return 'down';
    } else {
      // Horizontal movement
      if (rightX < -deadzone) return 'left';
      if (rightX > deadzone) return 'right';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isConnected =
        widget.debugForceConnected ?? _gamepadService.isGamepadConnected;

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) => _handleKeyEvent(event),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.gamepadTest),
        ),
        body: Column(
          children: [
            Expanded(
              child: !isConnected
                  ? _buildNotConnected()
                  : Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1120),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildConnectionStatus(),
                              const SizedBox(height: 12),
                              _buildLastAction(),
                              const SizedBox(height: 12),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Left column
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Expanded(child: _buildButtonTests()),
                                          const SizedBox(height: 12),
                                          Expanded(
                                            child: _buildLeftNavigationTest(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Middle column
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Expanded(child: _buildButtonStates()),
                                          const SizedBox(height: 12),
                                          const Expanded(child: SizedBox()),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Right column
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Expanded(child: _buildAxisValues()),
                                          const SizedBox(height: 12),
                                          Expanded(
                                            child: _buildRightNavigationTest(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
            ControlsBottomBar(
              actions: [
                BottomBarAction(
                  label: AppLocalizations.of(context)!.back,
                  keyboardKey: 'ESC',
                  gamepadButton: 'B',
                ),
                if (isConnected)
                  BottomBarAction(
                    label: AppLocalizations.of(context)!.exit,
                    keyboardKey: 'Start+Select',
                    gamepadButton: 'Start+Select',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _panelDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
    );
  }

  Widget _buildNotConnected() {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: AnimatedLucideIcon(
                type: AnimatedLucideIconType.gamepad,
                size: 56,
                animate: true,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.noGamepadConnected,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.connectGamepadPrompt,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Container(
      decoration: _panelDecoration(context),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF30D158),
            size: 22,
          ),
          const SizedBox(width: 12),
          Text(
            AppLocalizations.of(context)!.gamepadConnected,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildLastAction() {
    return Container(
      decoration: _panelDecoration(context),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          const Icon(
            Icons.touch_app_rounded,
            color: Color(0xFF0A84FF),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _lastAction ?? AppLocalizations.of(context)!.pressButtonToTest,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonTests() {
    return Container(
      decoration: _panelDecoration(context),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.buttonFunctionTests,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTestButton(
                      AppLocalizations.of(context)!.gamepadASelect,
                      _gamepadService.isButtonPressed(GamepadService.buttonA),
                    ),
                    _buildTestButton(
                      AppLocalizations.of(context)!.gamepadBBack,
                      _gamepadService.isButtonPressed(GamepadService.buttonB),
                    ),
                    _buildTestButton(
                      AppLocalizations.of(context)!.gamepadXSearch,
                      _gamepadService.isButtonPressed(GamepadService.buttonX),
                    ),
                    _buildTestButton(
                      AppLocalizations.of(context)!.gamepadYHelp,
                      _gamepadService.isButtonPressed(GamepadService.buttonY),
                    ),
                    _buildTestButton(
                      AppLocalizations.of(context)!.gamepadLBPageDown,
                      _gamepadService.isButtonPressed(GamepadService.buttonLB),
                    ),
                    _buildTestButton(
                      AppLocalizations.of(context)!.gamepadRBPageUp,
                      _gamepadService.isButtonPressed(GamepadService.buttonRB),
                    ),
                    _buildTestButton(
                      AppLocalizations.of(context)!.gamepadStartMenu,
                      _gamepadService.isButtonPressed(
                        GamepadService.buttonStart,
                      ),
                    ),
                    _buildTestButton(
                      AppLocalizations.of(context)!.gamepadSelectSettings,
                      _gamepadService.isButtonPressed(
                        GamepadService.buttonSelect,
                      ),
                    ),
                    _buildTestButton(
                      AppLocalizations.of(context)!.gamepadLSClick,
                      _gamepadService.isButtonPressed(GamepadService.buttonLS),
                    ),
                    _buildTestButton(
                      AppLocalizations.of(context)!.gamepadRSView,
                      _gamepadService.isButtonPressed(GamepadService.buttonRS),
                    ),
                    _buildTestButton(
                      AppLocalizations.of(context)!.gamepadLTTrigger,
                      _gamepadService.getAxisValue(GamepadService.axisLT) > 0.5,
                    ),
                    _buildTestButton(
                      AppLocalizations.of(context)!.gamepadRTTrigger,
                      _gamepadService.getAxisValue(GamepadService.axisRT) > 0.5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(String label, bool isPressed) {
    if (isPressed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _testAction(label);
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPressed ? Colors.green : Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isPressed ? Colors.green : Colors.grey.shade400,
                fontWeight: isPressed ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonStates() {
    return Container(
      decoration: _panelDecoration(context),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.rawButtonStates,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: _buttonStates.isEmpty
                    ? Text(
                        AppLocalizations.of(context)!.noButtonsPressed,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                      )
                    : Column(
                        children: _buttonStates.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1),
                            child: Text(
                              'Button ${entry.key}: ${entry.value ? "PRESSED" : "released"}',
                              style: TextStyle(
                                color: entry.value
                                    ? Colors.green
                                    : Colors.grey.shade600,
                                fontFamily: 'monospace',
                                fontSize: 12,
                                fontWeight: entry.value
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAxisValues() {
    return Container(
      decoration: _panelDecoration(context),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.axisValues,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: _axisValues.isEmpty
                    ? Text(
                        AppLocalizations.of(context)!.noAxisMovement,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                      )
                    : Column(
                        children: _axisValues.entries.map((entry) {
                          final value = entry.value;
                          final absValue = value.abs();
                          final color = absValue > 0.3
                              ? const Color(0xFF30D158)
                              : absValue > 0.1
                              ? const Color(0xFFFF9F0A)
                              : Colors.grey.shade600;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: Text(
                                    'Axis ${entry.key}:',
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        value.toStringAsFixed(2).padLeft(6),
                                        style: TextStyle(
                                          color: color,
                                          fontFamily: 'monospace',
                                          fontSize: 12,
                                          fontWeight: absValue > 0.3
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: SizedBox(
                                          height: 8,
                                          child: LinearProgressIndicator(
                                            value: (value + 1.0) / 2.0,
                                            backgroundColor:
                                                Colors.grey.shade700,
                                            valueColor:
                                                AlwaysStoppedAnimation(color),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftNavigationTest() {
    final direction = _getLeftNavigationDirection();

    return Container(
      decoration: _panelDecoration(context),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.dpadLeftStick,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDirectionIndicator('up', direction == 'up'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildDirectionIndicator('left', direction == 'left'),
                          const SizedBox(width: 20),
                          _buildDirectionIndicator(
                            'right',
                            direction == 'right',
                          ),
                        ],
                      ),
                      _buildDirectionIndicator('down', direction == 'down'),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                direction?.toUpperCase() ?? ' ',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightNavigationTest() {
    final direction = _getRightNavigationDirection();

    return Container(
      decoration: _panelDecoration(context),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.rightStick,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDirectionIndicator('up', direction == 'up'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildDirectionIndicator('left', direction == 'left'),
                          const SizedBox(width: 20),
                          _buildDirectionIndicator(
                            'right',
                            direction == 'right',
                          ),
                        ],
                      ),
                      _buildDirectionIndicator('down', direction == 'down'),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                direction?.toUpperCase() ?? ' ',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectionIndicator(String direction, bool isActive) {
    IconData icon;
    switch (direction) {
      case 'up':
        icon = Icons.arrow_upward;
        break;
      case 'down':
        icon = Icons.arrow_downward;
        break;
      case 'left':
        icon = Icons.arrow_back;
        break;
      case 'right':
        icon = Icons.arrow_forward;
        break;
      default:
        icon = Icons.circle;
    }

    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isActive ? Colors.green : Colors.grey.shade700,
          width: 2,
        ),
      ),
      child: Icon(
        icon,
        size: 28,
        color: isActive ? Colors.white : Colors.grey.shade600,
      ),
    );
  }
}
