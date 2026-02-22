// Web implementation of GamepadService using the Web Gamepad API
// Uses navigator.getGamepads() for polling-based input

import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'gamepad_service_base.dart';

/// Maps Web Gamepad API standard button indices to the string keys
/// used by the desktop (IO) implementation's button constants.
const Map<int, String> _webButtonToKey = {
  0: GamepadServiceBase.buttonA,
  1: GamepadServiceBase.buttonB,
  2: GamepadServiceBase.buttonX,
  3: GamepadServiceBase.buttonY,
  4: GamepadServiceBase.buttonLB,
  5: GamepadServiceBase.buttonRB,
  // 6 & 7 are triggers - mapped to axes instead
  8: GamepadServiceBase.buttonSelect,
  9: GamepadServiceBase.buttonStart,
  10: GamepadServiceBase.buttonLS,
  11: GamepadServiceBase.buttonRS,
  16: GamepadServiceBase.buttonGuide,
};

class GamepadService extends GamepadServiceBase {
  static GamepadService? _instance;

  // Button constants (matching base class)
  static const String buttonA = GamepadServiceBase.buttonA;
  static const String buttonB = GamepadServiceBase.buttonB;
  static const String buttonX = GamepadServiceBase.buttonX;
  static const String buttonY = GamepadServiceBase.buttonY;
  static const String buttonLB = GamepadServiceBase.buttonLB;
  static const String buttonRB = GamepadServiceBase.buttonRB;
  static const String buttonSelect = GamepadServiceBase.buttonSelect;
  static const String buttonStart = GamepadServiceBase.buttonStart;
  static const String buttonGuide = GamepadServiceBase.buttonGuide;
  static const String buttonLS = GamepadServiceBase.buttonLS;
  static const String buttonRS = GamepadServiceBase.buttonRS;

  // Axis constants
  static const String axisDpadX = GamepadServiceBase.axisDpadX;
  static const String axisDpadY = GamepadServiceBase.axisDpadY;
  static const String axisLeftX = GamepadServiceBase.axisLeftX;
  static const String axisLeftY = GamepadServiceBase.axisLeftY;
  static const String axisRightX = GamepadServiceBase.axisRightX;
  static const String axisRightY = GamepadServiceBase.axisRightY;
  static const String axisLT = GamepadServiceBase.axisLT;
  static const String axisRT = GamepadServiceBase.axisRT;

  void Function(String gamepadId)? onGamepadConnected;

  // JS event listener references
  JSFunction? _connectListener;
  JSFunction? _disconnectListener;

  // Polling timer
  Timer? _pollTimer;

  GamepadService._();

  static GamepadService get instance {
    _instance ??= GamepadService._();
    return _instance!;
  }

  Future<void> initialize() async {
    debug.info(
      'GamepadService: Initializing Web Gamepad API...',
      tag: 'GamepadService',
    );

    // Listen for connect/disconnect events
    _connectListener = ((web.GamepadEvent event) {
      final gp = event.gamepad;
      setConnectedGamepadId(gp.id);
      debug.info(
        'Gamepad connected: ${gp.id} (index: ${gp.index})',
        tag: 'GamepadService',
      );
      onGamepadConnected?.call(gp.id);
    }).toJS;

    _disconnectListener = ((web.GamepadEvent event) {
      final gp = event.gamepad;
      debug.info('Gamepad disconnected: ${gp.id}', tag: 'GamepadService');
      setConnectedGamepadId(null);
      buttonStates.clear();
      axisValues.clear();
    }).toJS;

    web.window.addEventListener('gamepadconnected', _connectListener);
    web.window.addEventListener('gamepaddisconnected', _disconnectListener);

    // Check for already-connected gamepads
    _pollGamepadState();

    _pollTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => _pollGamepadState(),
    );

    debug.info(
      'GamepadService: Web Gamepad API initialized',
      tag: 'GamepadService',
    );
  }

  /// Poll navigator.getGamepads() and update internal state
  void _pollGamepadState() {
    final gamepads = web.window.navigator.getGamepads();

    web.Gamepad? activeGamepad;
    for (var i = 0; i < gamepads.length; i++) {
      final gp = gamepads[i];
      if (gp != null && gp.connected) {
        activeGamepad = gp;
        if (connectedGamepadId == null) {
          setConnectedGamepadId(gp.id);
          debug.info(
            'Gamepad detected via polling: ${gp.id}',
            tag: 'GamepadService',
          );
          onGamepadConnected?.call(gp.id);
        }
        break; // Use first connected gamepad
      }
    }

    if (activeGamepad == null) return;

    // Update button states
    final buttons = activeGamepad.buttons;
    for (var i = 0; i < buttons.length; i++) {
      final btn = buttons[i];
      final value = btn.value;
      final pressed = btn.pressed || value > 0.5;

      // D-pad buttons (12-15) -> axis values
      if (i == 12) {
        final cur = axisValues[axisDpadY] ?? 0.0;
        axisValues[axisDpadY] = pressed ? -1.0 : (cur == -1.0 ? 0.0 : cur);
      } else if (i == 13) {
        final cur = axisValues[axisDpadY] ?? 0.0;
        axisValues[axisDpadY] = pressed ? 1.0 : (cur == 1.0 ? 0.0 : cur);
      } else if (i == 14) {
        final cur = axisValues[axisDpadX] ?? 0.0;
        axisValues[axisDpadX] = pressed ? -1.0 : (cur == -1.0 ? 0.0 : cur);
      } else if (i == 15) {
        final cur = axisValues[axisDpadX] ?? 0.0;
        axisValues[axisDpadX] = pressed ? 1.0 : (cur == 1.0 ? 0.0 : cur);
      } else if (i == 6) {
        axisValues[axisLT] = value.toDouble();
      } else if (i == 7) {
        axisValues[axisRT] = value.toDouble();
      } else {
        final key = _webButtonToKey[i];
        if (key != null) {
          buttonStates[key] = pressed;
        }
      }
    }

    // Update analog stick axes
    final axes = activeGamepad.axes;
    if (axes.length > 0) {
      axisValues[axisLeftX] = axes[0].toDartDouble;
    }
    if (axes.length > 1) {
      axisValues[axisLeftY] = axes[1].toDartDouble;
    }
    if (axes.length > 2) {
      axisValues[axisRightX] = axes[2].toDartDouble;
    }
    if (axes.length > 3) {
      axisValues[axisRightY] = axes[3].toDartDouble;
    }
  }

  void dispose() {
    if (_connectListener != null) {
      web.window.removeEventListener('gamepadconnected', _connectListener);
    }
    if (_disconnectListener != null) {
      web.window.removeEventListener(
        'gamepaddisconnected',
        _disconnectListener,
      );
    }
    _connectListener = null;
    _disconnectListener = null;
    _pollTimer?.cancel();
    clearInternalStates();
    debug.info('GamepadService disposed', tag: 'GamepadService');
  }

  // --- State getters (held = currently pressed, no edge detection) ---

  bool isUpHeld() =>
      getAxisValue(axisDpadY) < -GamepadServiceBase.deadzone ||
      getAxisValue(axisLeftY) < -GamepadServiceBase.deadzone;
  bool isDownHeld() =>
      getAxisValue(axisDpadY) > GamepadServiceBase.deadzone ||
      getAxisValue(axisLeftY) > GamepadServiceBase.deadzone;
  bool isLeftHeld() =>
      getAxisValue(axisDpadX) < -GamepadServiceBase.deadzone ||
      getAxisValue(axisLeftX) < -GamepadServiceBase.deadzone;
  bool isRightHeld() =>
      getAxisValue(axisDpadX) > GamepadServiceBase.deadzone ||
      getAxisValue(axisLeftX) > GamepadServiceBase.deadzone;
  bool isConfirmHeld() => isButtonPressed(buttonA);
  bool isCancelHeld() => isButtonPressed(buttonB);

  // --- Axis value getters ---

  double getLeftStickX() => getAxisValue(axisLeftX);
  double getLeftStickY() => getAxisValue(axisLeftY);
  double getRightStickX() => getAxisValue(axisRightX);
  double getRightStickY() => getAxisValue(axisRightY);
  double getLeftTrigger() => getAxisValue(axisLT);
  double getRightTrigger() => getAxisValue(axisRT);

  void resetAllStates() {
    clearInternalStates();
  }
}
