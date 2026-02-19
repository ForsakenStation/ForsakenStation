// Web implementation of GamepadService using the Web Gamepad API
// Uses navigator.getGamepads() for polling-based input

import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'debug_service.dart';

/// Maps Web Gamepad API standard button indices to the string keys
/// used by the desktop (IO) implementation's button constants.
///
/// Web Gamepad API standard mapping:
///   0=A, 1=B, 2=X, 3=Y, 4=LB, 5=RB, 6=LT(button), 7=RT(button),
///   8=Select, 9=Start, 10=LS, 11=RS, 12=DUp, 13=DDown, 14=DLeft, 15=DRight, 16=Guide
///
/// IO (Linux joystick) mapping:
///   '0'=A, '1'=B, '2'=X, '3'=Y, '4'=LB, '5'=RB,
///   '6'=Select, '7'=Start, '8'=Guide, '9'=LS, '10'=RS
///   Axes: '6'=DpadX, '7'=DpadY, '2'=LT, '5'=RT
const Map<int, String> _webButtonToKey = {
  0: '0', // A
  1: '1', // B
  2: '2', // X
  3: '3', // Y
  4: '4', // LB
  5: '5', // RB
  // 6 & 7 are triggers - mapped to axes instead
  8: '6', // Select -> IO key '6'
  9: '7', // Start -> IO key '7'
  10: '9', // LS -> IO key '9'
  11: '10', // RS -> IO key '10'
  // 12-15 are D-pad - mapped to axes instead
  16: '8', // Guide -> IO key '8'
};

class GamepadService {
  static GamepadService? _instance;
  final _debug = DebugService.instance;

  // Button constants (matching desktop implementation)
  static const String buttonA = '0';
  static const String buttonB = '1';
  static const String buttonX = '2';
  static const String buttonY = '3';
  static const String buttonLB = '4';
  static const String buttonRB = '5';
  static const String buttonSelect = '6';
  static const String buttonStart = '7';
  static const String buttonGuide = '8';
  static const String buttonLS = '9';
  static const String buttonRS = '10';
  @Deprecated('Use isLeftTriggerPressed() instead')
  static const String buttonLT = '_deprecated_lt';
  @Deprecated('Use isRightTriggerPressed() instead')
  static const String buttonRT = '_deprecated_rt';

  // Axis constants
  static const String axisDpadX = '6';
  static const String axisDpadY = '7';
  static const String axisLeftX = '0';
  static const String axisLeftY = '1';
  static const String axisRightX = '3';
  static const String axisRightY = '4';
  static const String axisLT = '2';
  static const String axisRT = '5';

  // Deadzone
  static const double deadzone = 0.3;

  // Debounce for D-pad / analog stick navigation
  DateTime? _lastDpadEvent;
  static const Duration dpadDebounce = Duration(milliseconds: 50);

  void Function(String gamepadId)? onGamepadConnected;

  bool _debugMode = false;
  String? _connectedGamepadId;

  final Map<String, bool> _buttonStates = {};
  final Map<String, bool> _previousButtonStates = {};
  final Map<String, double> _axisValues = {};
  final Map<String, double> _previousAxisValues = {};

  // JS event listener references (for cleanup via removeEventListener)
  JSFunction? _connectListener;
  JSFunction? _disconnectListener;

  // Polling timer for updating state from navigator.getGamepads()
  Timer? _pollTimer;

  GamepadService._();

  static GamepadService get instance {
    _instance ??= GamepadService._();
    return _instance!;
  }

  Future<void> initialize() async {
    _debug.info(
      'GamepadService: Initializing Web Gamepad API...',
      tag: 'GamepadService',
    );

    // Listen for connect/disconnect events
    _connectListener = ((web.GamepadEvent event) {
      final gp = event.gamepad;
      _connectedGamepadId = gp.id;
      _debug.info(
        'Gamepad connected: ${gp.id} (index: ${gp.index})',
        tag: 'GamepadService',
      );
      onGamepadConnected?.call(gp.id);
    }).toJS;

    _disconnectListener = ((web.GamepadEvent event) {
      final gp = event.gamepad;
      _debug.info('Gamepad disconnected: ${gp.id}', tag: 'GamepadService');
      _connectedGamepadId = null;
      _buttonStates.clear();
      _previousButtonStates.clear();
      _axisValues.clear();
      _previousAxisValues.clear();
    }).toJS;

    web.window.addEventListener('gamepadconnected', _connectListener);
    web.window.addEventListener('gamepaddisconnected', _disconnectListener);

    // Check for already-connected gamepads
    _pollGamepadState();

    // Start a background poll timer to keep state fresh.
    // The GamepadPollingMixin polls at 50ms for UI, but we also need
    // to detect connection without the mixin being active.
    _pollTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => _pollGamepadState(),
    );

    _debug.info(
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
        if (_connectedGamepadId == null) {
          _connectedGamepadId = gp.id;
          _debug.info(
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
        final cur = _axisValues[axisDpadY] ?? 0.0;
        _axisValues[axisDpadY] = pressed ? -1.0 : (cur == -1.0 ? 0.0 : cur);
      } else if (i == 13) {
        final cur = _axisValues[axisDpadY] ?? 0.0;
        _axisValues[axisDpadY] = pressed ? 1.0 : (cur == 1.0 ? 0.0 : cur);
      } else if (i == 14) {
        final cur = _axisValues[axisDpadX] ?? 0.0;
        _axisValues[axisDpadX] = pressed ? -1.0 : (cur == -1.0 ? 0.0 : cur);
      } else if (i == 15) {
        final cur = _axisValues[axisDpadX] ?? 0.0;
        _axisValues[axisDpadX] = pressed ? 1.0 : (cur == 1.0 ? 0.0 : cur);
      } else if (i == 6) {
        _axisValues[axisLT] = value.toDouble();
      } else if (i == 7) {
        _axisValues[axisRT] = value.toDouble();
      } else {
        final key = _webButtonToKey[i];
        if (key != null) {
          _buttonStates[key] = pressed;
        }
      }
    }

    // Update analog stick axes
    final axes = activeGamepad.axes;
    if (axes.length > 0) {
      _axisValues[axisLeftX] = axes[0].toDartDouble;
    }
    if (axes.length > 1) {
      _axisValues[axisLeftY] = axes[1].toDartDouble;
    }
    if (axes.length > 2) {
      _axisValues[axisRightX] = axes[2].toDartDouble;
    }
    if (axes.length > 3) {
      _axisValues[axisRightY] = axes[3].toDartDouble;
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
    _connectedGamepadId = null;
    _buttonStates.clear();
    _previousButtonStates.clear();
    _axisValues.clear();
    _previousAxisValues.clear();
    _debug.info('GamepadService disposed', tag: 'GamepadService');
  }

  bool get isGamepadConnected => _connectedGamepadId != null;
  String? get connectedGamepadId => _connectedGamepadId;
  bool get debugMode => _debugMode;
  set debugMode(bool value) => _debugMode = value;

  void setDebugMode(bool enabled) {
    _debugMode = enabled;
    _debug.info(
      'GamepadService debug mode: ${enabled ? "ENABLED" : "DISABLED"}',
      tag: 'GamepadService',
    );
  }

  // --- Button state methods ---

  bool isButtonPressed(String button) {
    return _buttonStates[button] ?? false;
  }

  bool wasButtonJustPressed(String button) {
    final currentState = _buttonStates[button] ?? false;
    final previousState = _previousButtonStates[button] ?? false;
    return currentState && !previousState;
  }

  void updatePreviousButtonStates() {
    _previousButtonStates.clear();
    _previousButtonStates.addAll(_buttonStates);
    _previousAxisValues.clear();
    _previousAxisValues.addAll(_axisValues);
  }

  double getAxisValue(String axis) {
    final value = _axisValues[axis] ?? 0.0;
    if (value.abs() < deadzone) return 0.0;
    return value;
  }

  Map<String, bool> getAllButtonStates() => Map.from(_buttonStates);
  Map<String, double> getAllAxisValues() => Map.from(_axisValues);

  // --- Navigation direction ---

  String? getNavigationDirection() {
    if (_debugMode) return null;

    final now = DateTime.now();
    if (_lastDpadEvent != null &&
        now.difference(_lastDpadEvent!) < dpadDebounce) {
      return null;
    }

    // D-pad axes
    final dpadX = getAxisValue(axisDpadX);
    final dpadY = getAxisValue(axisDpadY);

    if (dpadY < -deadzone) {
      _lastDpadEvent = now;
      return 'up';
    }
    if (dpadY > deadzone) {
      _lastDpadEvent = now;
      return 'down';
    }
    if (dpadX < -deadzone) {
      _lastDpadEvent = now;
      return 'left';
    }
    if (dpadX > deadzone) {
      _lastDpadEvent = now;
      return 'right';
    }

    // Left analog stick
    final leftX = getAxisValue(axisLeftX);
    final leftY = getAxisValue(axisLeftY);

    if (leftY.abs() > leftX.abs()) {
      if (leftY < -deadzone) {
        _lastDpadEvent = now;
        return 'up';
      }
      if (leftY > deadzone) {
        _lastDpadEvent = now;
        return 'down';
      }
    } else {
      if (leftX < -deadzone) {
        _lastDpadEvent = now;
        return 'left';
      }
      if (leftX > deadzone) {
        _lastDpadEvent = now;
        return 'right';
      }
    }

    return null;
  }

  // --- Navigation action methods (edge detection) ---

  bool wasUpPressed() => wasButtonJustPressed('_dpad_up');
  bool wasDownPressed() => wasButtonJustPressed('_dpad_down');
  bool wasLeftPressed() => wasButtonJustPressed('_dpad_left');
  bool wasRightPressed() => wasButtonJustPressed('_dpad_right');
  bool wasConfirmPressed() => wasButtonJustPressed(buttonA);
  bool wasCancelPressed() => wasButtonJustPressed(buttonB);
  bool wasMenuPressed() => wasButtonJustPressed(buttonStart);
  bool wasShoulderLeftPressed() => wasButtonJustPressed(buttonLB);
  bool wasShoulderRightPressed() => wasButtonJustPressed(buttonRB);
  bool wasTriggerLeftPressed() => isLeftTriggerPressed();
  bool wasTriggerRightPressed() => isRightTriggerPressed();
  bool wasViewPressed() => wasButtonJustPressed(buttonSelect);
  bool wasGuidePressed() => wasButtonJustPressed(buttonGuide);
  bool wasLeftStickPressed() => wasButtonJustPressed(buttonLS);
  bool wasRightStickPressed() => wasButtonJustPressed(buttonRS);
  bool wasXPressed() => wasButtonJustPressed(buttonX);
  bool wasYPressed() => wasButtonJustPressed(buttonY);

  // --- Specific action checks (matching IO interface) ---

  bool isSelectPressed() {
    if (_debugMode) return false;
    return wasButtonJustPressed(buttonA);
  }

  bool isBackPressed() {
    if (_debugMode) return false;
    return wasButtonJustPressed(buttonB);
  }

  bool isSettingsPressed() {
    return wasButtonJustPressed(buttonSelect);
  }

  bool isMenuPressed() {
    return wasButtonJustPressed(buttonStart);
  }

  bool isLeftStickPressed() {
    if (_debugMode) return false;
    return wasButtonJustPressed(buttonLS);
  }

  bool isHelpPressed() {
    if (_debugMode) return false;
    return wasButtonJustPressed(buttonY);
  }

  bool isSearchPressed() {
    if (_debugMode) return false;
    return wasButtonJustPressed(buttonX);
  }

  bool isPageUpPressed() {
    if (_debugMode) return false;
    return wasButtonJustPressed(buttonRB);
  }

  bool isPageDownPressed() {
    if (_debugMode) return false;
    return wasButtonJustPressed(buttonLB);
  }

  bool isLeftTriggerPressed() {
    if (_debugMode) return false;
    final currentState = getAxisValue(axisLT) > 0.5;
    final previousValue = _previousAxisValues[axisLT] ?? 0.0;
    final previousState =
        (previousValue.abs() < deadzone ? 0.0 : previousValue) > 0.5;
    return currentState && !previousState;
  }

  bool isRightTriggerPressed() {
    if (_debugMode) return false;
    final currentState = getAxisValue(axisRT) > 0.5;
    final previousValue = _previousAxisValues[axisRT] ?? 0.0;
    final previousState =
        (previousValue.abs() < deadzone ? 0.0 : previousValue) > 0.5;
    return currentState && !previousState;
  }

  bool isViewTogglePressed() {
    if (_debugMode) return false;
    return wasButtonJustPressed(buttonRS);
  }

  // --- State getters (held = currently pressed, no edge detection) ---

  bool isUpHeld() =>
      getAxisValue(axisDpadY) < -deadzone ||
      getAxisValue(axisLeftY) < -deadzone;
  bool isDownHeld() =>
      getAxisValue(axisDpadY) > deadzone || getAxisValue(axisLeftY) > deadzone;
  bool isLeftHeld() =>
      getAxisValue(axisDpadX) < -deadzone ||
      getAxisValue(axisLeftX) < -deadzone;
  bool isRightHeld() =>
      getAxisValue(axisDpadX) > deadzone || getAxisValue(axisLeftX) > deadzone;
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
    _buttonStates.clear();
    _previousButtonStates.clear();
    _axisValues.clear();
    _previousAxisValues.clear();
  }

  // --- Grid / list / carousel navigation ---

  int? handleGridNavigation({
    required int currentIndex,
    required int itemCount,
    required int columns,
  }) {
    if (itemCount == 0) return null;

    final direction = getNavigationDirection();
    if (direction == null) return null;

    int newIndex = currentIndex;

    switch (direction) {
      case 'up':
        newIndex = currentIndex - columns;
        break;
      case 'down':
        newIndex = currentIndex + columns;
        break;
      case 'left':
        newIndex = currentIndex - 1;
        break;
      case 'right':
        newIndex = currentIndex + 1;
        break;
    }

    if (isPageUpPressed()) {
      newIndex = currentIndex - (columns * 3);
    } else if (isPageDownPressed()) {
      newIndex = currentIndex + (columns * 3);
    }

    if (newIndex < 0) newIndex = 0;
    if (newIndex >= itemCount) newIndex = itemCount - 1;

    return newIndex != currentIndex ? newIndex : null;
  }

  int? handleListNavigation({
    required int currentIndex,
    required int itemCount,
  }) {
    return handleGridNavigation(
      currentIndex: currentIndex,
      itemCount: itemCount,
      columns: 1,
    );
  }

  int? handleCarouselNavigation({
    required int currentIndex,
    required int itemCount,
    bool loop = true,
  }) {
    if (itemCount == 0) return null;

    final direction = getNavigationDirection();
    if (direction == null) return null;

    int newIndex = currentIndex;

    if (direction == 'left') {
      newIndex = currentIndex - 1;
      if (newIndex < 0) {
        newIndex = loop ? itemCount - 1 : 0;
      }
    } else if (direction == 'right') {
      newIndex = currentIndex + 1;
      if (newIndex >= itemCount) {
        newIndex = loop ? 0 : itemCount - 1;
      }
    }

    if (isPageUpPressed()) {
      newIndex = currentIndex - 10;
      if (newIndex < 0) {
        newIndex = loop ? itemCount - 1 : 0;
      }
    } else if (isPageDownPressed()) {
      newIndex = currentIndex + 10;
      if (newIndex >= itemCount) {
        newIndex = loop ? 0 : itemCount - 1;
      }
    }

    return newIndex != currentIndex ? newIndex : null;
  }
}
