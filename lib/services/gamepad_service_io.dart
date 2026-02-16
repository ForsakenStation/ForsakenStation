import 'dart:async';
import 'package:gamepads/gamepads.dart';
import 'debug_service.dart';

/// Service for unified gamepad management across the application
/// Handles gamepad input and maps it to navigation actions
class GamepadService {
  static GamepadService? _instance;
  final _debug = DebugService.instance;

  StreamSubscription<GamepadEvent>? _gamepadSubscription;
  String? _connectedGamepadId;
  final Map<String, double> _axisValues = {};
  final Map<String, double> _previousAxisValues =
      {}; // Track previous axis values
  final Map<String, bool> _buttonStates = {};
  final Map<String, bool> _previousButtonStates =
      {}; // Track previous state for edge detection

  // Debug mode flag - when true, action methods return false
  bool _debugMode = false;

  // Callback for when a gamepad is connected
  void Function(String gamepadId)? onGamepadConnected;

  // Analog stick deadzone (0.0 - 1.0)
  static const double deadzone = 0.3;

  // Debounce for analog stick to prevent too many events
  DateTime? _lastDpadEvent;
  static const Duration dpadDebounce = Duration(
    milliseconds: 50,
  ); // Reduced from 150ms for better responsiveness

  GamepadService._();

  /// Get the singleton instance
  static GamepadService get instance {
    _instance ??= GamepadService._();
    return _instance!;
  }

  /// Initialize gamepad service and start listening
  Future<void> initialize() async {
    _debug.info('Initializing GamepadService...', tag: 'GamepadService');

    // Check for already connected gamepads
    try {
      final connectedGamepads = await Gamepads.list();
      _debug.info(
        'Found ${connectedGamepads.length} connected gamepad(s)',
        tag: 'GamepadService',
      );

      for (final gamepad in connectedGamepads) {
        _debug.info(
          'Gamepad detected: ${gamepad.name} (ID: ${gamepad.id})',
          tag: 'GamepadService',
        );

        // Connect to the first gamepad found
        if (_connectedGamepadId == null) {
          _connectedGamepadId = gamepad.id;
          _debug.info(
            'Connected to gamepad: ${gamepad.name}',
            tag: 'GamepadService',
          );

          // Notify callback
          onGamepadConnected?.call(gamepad.name);
        }
      }
    } catch (e) {
      _debug.error(
        'Error listing gamepads: $e',
        tag: 'GamepadService',
        error: e,
      );
    }

    // Listen for gamepad events
    _gamepadSubscription = Gamepads.events.listen(
      _handleGamepadEvent,
      onError: (error) {
        _debug.error('Gamepad error: $error', tag: 'GamepadService');
      },
    );

    _debug.info('GamepadService initialized', tag: 'GamepadService');
  }

  /// Handle gamepad event
  void _handleGamepadEvent(GamepadEvent event) {
    // Track connected gamepad
    if (_connectedGamepadId == null || _connectedGamepadId != event.gamepadId) {
      final previousGamepadId = _connectedGamepadId;
      _connectedGamepadId = event.gamepadId;

      _debug.info(
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
      final wasPressed = _buttonStates[event.key] ?? false;
      final isPressed = event.value > 0.5;

      _buttonStates[event.key] = isPressed;

      // Log button press/release with detailed info
      if (isPressed && !wasPressed) {
        _debug.info(
          '🎮 Button pressed: "${event.key}" (value: ${event.value})',
          tag: 'GamepadService',
        );
      }
    }

    // Update axis values
    if (event.type == KeyType.analog) {
      // Normalize axis value from -32768..32767 to -1.0..1.0
      final normalizedValue = event.value / 32767.0;

      final oldValue = _axisValues[event.key] ?? 0.0;
      _axisValues[event.key] = normalizedValue;

      // Log analog stick movements (only when crossing deadzone)
      if (oldValue.abs() < deadzone && normalizedValue.abs() >= deadzone) {
        _debug.info(
          '🕹️ Analog axis: "${event.key}" = ${normalizedValue.toStringAsFixed(2)} (raw: ${event.value})',
          tag: 'GamepadService',
        );
      }
    }
  }

  /// Check if a button is currently pressed
  bool isButtonPressed(String button) {
    return _buttonStates[button] ?? false;
  }

  /// Check if a button was just pressed (edge detection: false -> true)
  /// This returns true only once per button press, not while holding
  bool wasButtonJustPressed(String button) {
    final currentState = _buttonStates[button] ?? false;
    final previousState = _previousButtonStates[button] ?? false;

    // Detect rising edge: was false, now true
    return currentState && !previousState;
  }

  /// Update previous button states for edge detection
  /// Should be called after processing all button actions in a polling cycle
  void updatePreviousButtonStates() {
    _previousButtonStates.clear();
    _previousButtonStates.addAll(_buttonStates);
    _previousAxisValues.clear();
    _previousAxisValues.addAll(_axisValues);
  }

  /// Get all current button states (for debugging)
  Map<String, bool> getAllButtonStates() {
    return Map.from(_buttonStates);
  }

  /// Get all current axis values (for debugging)
  Map<String, double> getAllAxisValues() {
    return Map.from(_axisValues);
  }

  /// Get current value of an axis (-1.0 to 1.0)
  double getAxisValue(String axis) {
    final value = _axisValues[axis] ?? 0.0;
    // Apply deadzone
    if (value.abs() < deadzone) return 0.0;
    return value;
  }

  /// Check if any gamepad is connected
  bool get isGamepadConnected => _connectedGamepadId != null;

  /// Gamepad button mappings for Xbox controller (using numeric indices)
  /// Based on standard Linux joystick mapping for Xbox controllers
  static const String buttonA = '0'; // A button - Select/Confirm
  static const String buttonB = '1'; // B button - Back/Cancel
  static const String buttonX = '2'; // X button - Alternative action
  static const String buttonY = '3'; // Y button - Alternative action
  static const String buttonLB = '4'; // Left bumper
  static const String buttonRB = '5'; // Right bumper
  static const String buttonSelect = '6'; // Select/Back button
  static const String buttonStart = '7'; // Start button
  static const String buttonGuide = '8'; // Xbox/Guide button
  static const String buttonLS = '9'; // Left stick click
  static const String buttonRS = '10'; // Right stick click

  // Deprecated button names for backward compatibility
  // These are now axes, use isLeftTriggerPressed() and isRightTriggerPressed() instead
  @Deprecated('Use isLeftTriggerPressed() instead')
  static const String buttonLT = '_deprecated_lt';
  @Deprecated('Use isRightTriggerPressed() instead')
  static const String buttonRT = '_deprecated_rt';

  // D-pad is typically on axes 6 and 7 for Xbox controllers
  static const String axisDpadX = '6'; // D-pad horizontal axis
  static const String axisDpadY = '7'; // D-pad vertical axis

  // Analog stick axes
  static const String axisLeftX = '0'; // Left stick horizontal
  static const String axisLeftY = '1'; // Left stick vertical
  static const String axisRightX = '3'; // Right stick horizontal
  static const String axisRightY = '4'; // Right stick vertical
  static const String axisLT = '2'; // Left trigger axis
  static const String axisRT = '5'; // Right trigger axis

  /// Get navigation direction from D-pad or left analog stick
  /// Returns: 'up', 'down', 'left', 'right', or null
  String? getNavigationDirection() {
    if (_debugMode) return null; // Disable navigation in debug mode

    final now = DateTime.now();

    // Check if we need to debounce
    if (_lastDpadEvent != null &&
        now.difference(_lastDpadEvent!) < dpadDebounce) {
      return null;
    }

    // Check D-pad axes first (digital input has priority)
    // D-pad X axis: -1 = left, +1 = right
    // D-pad Y axis: -1 = up, +1 = down
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

    // Then check left analog stick
    final leftX = getAxisValue(axisLeftX);
    final leftY = getAxisValue(axisLeftY);

    // Determine primary direction (only one at a time for navigation)
    if (leftY.abs() > leftX.abs()) {
      // Vertical movement
      if (leftY < -deadzone) {
        _lastDpadEvent = now;
        return 'up';
      }
      if (leftY > deadzone) {
        _lastDpadEvent = now;
        return 'down';
      }
    } else {
      // Horizontal movement
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

  /// Enable or disable debug mode
  /// When debug mode is enabled, action methods return false to prevent handlers from executing
  void setDebugMode(bool enabled) {
    _debugMode = enabled;
    _debug.info(
      'GamepadService debug mode: ${enabled ? "ENABLED" : "DISABLED"}',
      tag: 'GamepadService',
    );
  }

  /// Check if debug mode is enabled
  bool get isDebugMode => _debugMode;

  /// Check if select button is pressed (A button only)
  /// Uses edge detection - returns true only on the moment of press
  bool isSelectPressed() {
    if (_debugMode) return false;
    return wasButtonJustPressed(buttonA);
  }

  /// Check if back button is pressed (B button only)
  /// Uses edge detection - returns true only on the moment of press
  bool isBackPressed() {
    if (_debugMode) return false;
    return wasButtonJustPressed(buttonB);
  }

  /// Check if settings button is pressed (Select button)
  /// Uses edge detection - returns true only on the moment of press
  bool isSettingsPressed() {
    return wasButtonJustPressed(buttonSelect);
  }

  /// Check if menu button is pressed (Start button)
  /// Uses edge detection - returns true only on the moment of press
  bool isMenuPressed() {
    return wasButtonJustPressed(buttonStart);
  }

  /// Check if Left Stick Click is pressed
  /// Uses edge detection - returns true only on the moment of press
  bool isLeftStickPressed() {
    if (_debugMode) return false;
    return wasButtonJustPressed(buttonLS);
  }

  /// Check if help button is pressed (Y button)
  /// Uses edge detection - returns true only on the moment of press
  bool isHelpPressed() {
    if (_debugMode) return false;
    return wasButtonJustPressed(buttonY);
  }

  /// Check if search button is pressed (X button)
  /// Uses edge detection - returns true only on the moment of press
  bool isSearchPressed() {
    if (_debugMode) return false;
    return wasButtonJustPressed(buttonX);
  }

  /// Check if page up is pressed (RB button)
  /// Uses edge detection - returns true only on the moment of press
  bool isPageUpPressed() {
    if (_debugMode) return false;
    return wasButtonJustPressed(buttonRB);
  }

  /// Check if page down is pressed (LB button)
  /// Uses edge detection - returns true only on the moment of press
  bool isPageDownPressed() {
    if (_debugMode) return false;
    return wasButtonJustPressed(buttonLB);
  }

  /// Check if left trigger is pressed
  /// Uses edge detection - returns true only on the moment of press
  bool isLeftTriggerPressed() {
    if (_debugMode) return false;
    final currentState = getAxisValue(axisLT) > 0.5;
    final previousValue = _previousAxisValues[axisLT] ?? 0.0;
    final previousState =
        (previousValue.abs() < deadzone ? 0.0 : previousValue) > 0.5;
    return currentState && !previousState;
  }

  /// Check if right trigger is pressed
  /// Uses edge detection - returns true only on the moment of press
  bool isRightTriggerPressed() {
    if (_debugMode) return false;
    final currentState = getAxisValue(axisRT) > 0.5;
    final previousValue = _previousAxisValues[axisRT] ?? 0.0;
    final previousState =
        (previousValue.abs() < deadzone ? 0.0 : previousValue) > 0.5;
    return currentState && !previousState;
  }

  /// Check if view toggle is pressed (Right stick click)
  /// Uses edge detection - returns true only on the moment of press
  bool isViewTogglePressed() {
    if (_debugMode) return false;
    return wasButtonJustPressed(buttonRS);
  }

  /// Handle grid navigation with gamepad
  /// Returns new index or null if navigation not possible
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

    // Handle page navigation
    if (isPageUpPressed()) {
      newIndex = currentIndex - (columns * 3);
    } else if (isPageDownPressed()) {
      newIndex = currentIndex + (columns * 3);
    }

    // Clamp to valid range
    if (newIndex < 0) newIndex = 0;
    if (newIndex >= itemCount) newIndex = itemCount - 1;

    _debug.debug(
      'Gamepad grid navigation: $currentIndex -> $newIndex (direction: $direction)',
      tag: 'GamepadService',
    );

    return newIndex != currentIndex ? newIndex : null;
  }

  /// Handle list navigation with gamepad
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

  /// Handle carousel navigation with gamepad
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

    // Handle page navigation
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

    _debug.debug(
      'Gamepad carousel navigation: $currentIndex -> $newIndex (direction: $direction)',
      tag: 'GamepadService',
    );

    return newIndex != currentIndex ? newIndex : null;
  }

  /// Dispose of resources
  void dispose() {
    _gamepadSubscription?.cancel();
    _gamepadSubscription = null;
    _connectedGamepadId = null;
    _axisValues.clear();
    _buttonStates.clear();
    _debug.info('GamepadService disposed', tag: 'GamepadService');
  }
}
