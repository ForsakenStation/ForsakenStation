import 'debug_service.dart';

/// Base logic for GamepadService to avoid duplication between IO and Web implementations
abstract class GamepadServiceBase {
  final debug = DebugService.instance;

  String? _connectedGamepadId;
  final Map<String, double> _axisValues = {};
  final Map<String, double> _previousAxisValues = {};
  final Map<String, bool> _buttonStates = {};
  final Map<String, bool> _previousButtonStates = {};

  bool _debugMode = false;
  DateTime? _lastDpadEvent;

  // Configuration
  static const double deadzone = 0.3;
  static const Duration dpadDebounce = Duration(milliseconds: 50);

  // Gamepad button mappings (standardized across implementations)
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

  // Axis constants
  static const String axisDpadX = '6';
  static const String axisDpadY = '7';
  static const String axisLeftX = '0';
  static const String axisLeftY = '1';
  static const String axisRightX = '3';
  static const String axisRightY = '4';
  static const String axisLT = '2';
  static const String axisRT = '5';

  // Getters
  bool get isGamepadConnected => _connectedGamepadId != null;
  String? get connectedGamepadId => _connectedGamepadId;
  bool get isDebugMode => _debugMode;

  Map<String, double> get axisValues => _axisValues;
  Map<String, bool> get buttonStates => _buttonStates;

  void setDebugMode(bool enabled) {
    _debugMode = enabled;
    debug.info(
      'GamepadService debug mode: ${enabled ? "ENABLED" : "DISABLED"}',
      tag: 'GamepadService',
    );
  }

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

  // --- Specific action checks ---

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

  void clearInternalStates() {
    _connectedGamepadId = null;
    _buttonStates.clear();
    _previousButtonStates.clear();
    _axisValues.clear();
    _previousAxisValues.clear();
  }

  // Helper for protected access to internal states in subclasses
  void setConnectedGamepadId(String? id) => _connectedGamepadId = id;
}
