import 'dart:async';
import 'package:gamepads/gamepads.dart';
import 'gamepad_service_base.dart';

/// IO implementation of GamepadService using the gamepads package
class GamepadService extends GamepadServiceBase {
  static GamepadService? _instance;
  StreamSubscription<GamepadEvent>? _gamepadSubscription;

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

  // Callback for when a gamepad is connected
  void Function(String gamepadId)? onGamepadConnected;

  GamepadService._();

  /// Get the singleton instance
  static GamepadService get instance {
    _instance ??= GamepadService._();
    return _instance!;
  }

  /// Initialize gamepad service and start listening
  Future<void> initialize() async {
    debug.info('Initializing GamepadService (IO)...', tag: 'GamepadService');

    // Check for already connected gamepads
    try {
      final connectedGamepads = await Gamepads.list();
      debug.info(
        'Found ${connectedGamepads.length} connected gamepad(s)',
        tag: 'GamepadService',
      );

      for (final gamepad in connectedGamepads) {
        debug.info(
          'Gamepad detected: ${gamepad.name} (ID: ${gamepad.id})',
          tag: 'GamepadService',
        );

        // Connect to the first gamepad found
        if (connectedGamepadId == null) {
          setConnectedGamepadId(gamepad.id);
          debug.info(
            'Connected to gamepad: ${gamepad.name}',
            tag: 'GamepadService',
          );

          // Notify callback
          onGamepadConnected?.call(gamepad.name);
        }
      }
    } catch (e) {
      debug.error(
        'Error listing gamepads: $e',
        tag: 'GamepadService',
        error: e,
      );
    }

    // Listen for gamepad events
    _gamepadSubscription = Gamepads.events.listen(
      _handleGamepadEvent,
      onError: (error) {
        debug.error('Gamepad error: $error', tag: 'GamepadService');
      },
    );

    debug.info('GamepadService initialized', tag: 'GamepadService');
  }

  /// Handle gamepad event
  void _handleGamepadEvent(GamepadEvent event) {
    // Track connected gamepad
    if (connectedGamepadId == null || connectedGamepadId != event.gamepadId) {
      final previousGamepadId = connectedGamepadId;
      setConnectedGamepadId(event.gamepadId);

      debug.info(
        'Gamepad connected via event: ${event.gamepadId}',
        tag: 'GamepadService',
      );

      // Only trigger callback if this is a NEW connection (not just reconnection)
      if (previousGamepadId == null) {
        onGamepadConnected?.call(event.gamepadId);
      }
    }

    // Update button states
    if (event.type == KeyType.button) {
      final wasPressed = buttonStates[event.key] ?? false;
      final isPressed = event.value > 0.5;

      buttonStates[event.key] = isPressed;

      // Log button press/release with detailed info
      if (isPressed && !wasPressed) {
        debug.info(
          '🎮 Button pressed: "${event.key}" (value: ${event.value})',
          tag: 'GamepadService',
        );
      }
    }

    // Update axis values
    if (event.type == KeyType.analog) {
      // Normalize axis value from -32768..32767 to -1.0..1.0
      final normalizedValue = event.value / 32767.0;

      final oldValue = axisValues[event.key] ?? 0.0;
      axisValues[event.key] = normalizedValue;

      // Log analog stick movements (only when crossing deadzone)
      if (oldValue.abs() < GamepadServiceBase.deadzone &&
          normalizedValue.abs() >= GamepadServiceBase.deadzone) {
        debug.info(
          '🕹️ Analog axis: "${event.key}" = ${normalizedValue.toStringAsFixed(2)} (raw: ${event.value})',
          tag: 'GamepadService',
        );
      }
    }
  }

  /// Dispose of resources
  void dispose() {
    _gamepadSubscription?.cancel();
    _gamepadSubscription = null;
    clearInternalStates();
    debug.info('GamepadService disposed', tag: 'GamepadService');
  }
}
