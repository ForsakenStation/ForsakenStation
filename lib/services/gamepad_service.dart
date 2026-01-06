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
  final Map<String, bool> _buttonStates = {};

  // Analog stick deadzone (0.0 - 1.0)
  static const double deadzone = 0.3;

  // Debounce for analog stick to prevent too many events
  DateTime? _lastDpadEvent;
  static const Duration dpadDebounce = Duration(milliseconds: 150);

  GamepadService._();

  /// Get the singleton instance
  static GamepadService get instance {
    _instance ??= GamepadService._();
    return _instance!;
  }

  /// Initialize gamepad service and start listening
  Future<void> initialize() async {
    _debug.info('Initializing GamepadService...', tag: 'GamepadService');

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
      _connectedGamepadId = event.gamepadId;
      _debug.info(
        'Gamepad connected: ${event.gamepadId}',
        tag: 'GamepadService',
      );
    }

    // Update button states
    if (event.type == KeyType.button) {
      final wasPressed = _buttonStates[event.key] ?? false;
      final isPressed = event.value > 0.5;

      _buttonStates[event.key] = isPressed;

      // Log button press/release
      if (isPressed && !wasPressed) {
        _debug.debug(
          'Button pressed: ${event.key} (value: ${event.value})',
          tag: 'GamepadService',
        );
      }
    }

    // Update axis values
    if (event.type == KeyType.analog) {
      _axisValues[event.key] = event.value;
    }
  }

  /// Check if a button is currently pressed
  bool isButtonPressed(String button) {
    return _buttonStates[button] ?? false;
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

  /// Gamepad button mappings (common across most controllers)
  /// These match Xbox controller layout which is standard for most gamepads
  static const String buttonA = 'A'; // Select/Confirm (Xbox A, PS Cross)
  static const String buttonB = 'B'; // Back/Cancel (Xbox B, PS Circle)
  static const String buttonX = 'X'; // Alternative action
  static const String buttonY = 'Y'; // Alternative action
  static const String buttonLB = 'L1'; // Left bumper
  static const String buttonRB = 'R1'; // Right bumper
  static const String buttonLT = 'L2'; // Left trigger
  static const String buttonRT = 'R2'; // Right trigger
  static const String buttonStart = 'Start'; // Menu/Start
  static const String buttonSelect = 'Select'; // View/Back/Select
  static const String buttonDpadUp = 'dpad_up';
  static const String buttonDpadDown = 'dpad_down';
  static const String buttonDpadLeft = 'dpad_left';
  static const String buttonDpadRight = 'dpad_right';

  // Analog stick axes
  static const String axisLeftX = 'left_analog_stick_x';
  static const String axisLeftY = 'left_analog_stick_y';
  static const String axisRightX = 'right_analog_stick_x';
  static const String axisRightY = 'right_analog_stick_y';

  /// Get navigation direction from D-pad or left analog stick
  /// Returns: 'up', 'down', 'left', 'right', or null
  String? getNavigationDirection() {
    // Check D-pad first (digital input has priority)
    if (isButtonPressed(buttonDpadUp)) return 'up';
    if (isButtonPressed(buttonDpadDown)) return 'down';
    if (isButtonPressed(buttonDpadLeft)) return 'left';
    if (isButtonPressed(buttonDpadRight)) return 'right';

    // Then check left analog stick with debounce
    final now = DateTime.now();
    if (_lastDpadEvent != null &&
        now.difference(_lastDpadEvent!) < dpadDebounce) {
      return null;
    }

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

  /// Check if select button is pressed (A button or Start)
  bool isSelectPressed() {
    return isButtonPressed(buttonA) || isButtonPressed(buttonStart);
  }

  /// Check if back button is pressed (B button or Select)
  bool isBackPressed() {
    return isButtonPressed(buttonB) || isButtonPressed(buttonSelect);
  }

  /// Check if help button is pressed (Y button)
  bool isHelpPressed() {
    return isButtonPressed(buttonY);
  }

  /// Check if search button is pressed (X button)
  bool isSearchPressed() {
    return isButtonPressed(buttonX);
  }

  /// Check if page up is pressed (RB button)
  bool isPageUpPressed() {
    return isButtonPressed(buttonRB);
  }

  /// Check if page down is pressed (LB button)
  bool isPageDownPressed() {
    return isButtonPressed(buttonLB);
  }

  /// Check if view toggle is pressed (Right stick click)
  bool isViewTogglePressed() {
    return isButtonPressed('R3');
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
