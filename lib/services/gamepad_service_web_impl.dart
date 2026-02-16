// Web stub for GamepadService
// The gamepads package doesn't support web, so this is a no-op implementation
// TODO: Implement using Web Gamepad API in the future

import 'dart:async';
import 'debug_service.dart';

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
  static const String buttonLT = '_deprecated_lt';
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

  void Function(String gamepadId)? onGamepadConnected;

  bool _debugMode = false;

  GamepadService._();

  static GamepadService get instance {
    _instance ??= GamepadService._();
    return _instance!;
  }

  Future<void> initialize() async {
    _debug.info(
      'GamepadService: Web platform - using stub (gamepads not supported)',
      tag: 'GamepadService',
    );
  }

  void dispose() {}

  bool get isGamepadConnected => false;
  String? get connectedGamepadId => null;
  bool get debugMode => _debugMode;
  set debugMode(bool value) => _debugMode = value;

  void setDebugMode(bool enabled) {
    _debugMode = enabled;
  }

  // Button state methods
  bool isButtonPressed(String button) => false;
  bool wasButtonJustPressed(String button) => false;
  void updatePreviousButtonStates() {}
  double getAxisValue(String axis) => 0.0;

  // Get all states
  Map<String, bool> getAllButtonStates() => {};
  Map<String, double> getAllAxisValues() => {};

  // Navigation direction
  String? getNavigationDirection() => null;

  // Navigation action methods - all return false on web
  bool wasUpPressed() => false;
  bool wasDownPressed() => false;
  bool wasLeftPressed() => false;
  bool wasRightPressed() => false;
  bool wasConfirmPressed() => false;
  bool wasCancelPressed() => false;
  bool wasMenuPressed() => false;
  bool wasShoulderLeftPressed() => false;
  bool wasShoulderRightPressed() => false;
  bool wasTriggerLeftPressed() => false;
  bool wasTriggerRightPressed() => false;
  bool wasViewPressed() => false;
  bool wasGuidePressed() => false;
  bool wasLeftStickPressed() => false;
  bool wasRightStickPressed() => false;
  bool wasXPressed() => false;
  bool wasYPressed() => false;

  // Specific action checks
  bool isSelectPressed() => false;
  bool isBackPressed() => false;
  bool isSettingsPressed() => false;
  bool isMenuPressed() => false;
  bool isLeftStickPressed() => false;
  bool isHelpPressed() => false;
  bool isSearchPressed() => false;
  bool isPageUpPressed() => false;
  bool isPageDownPressed() => false;
  bool isLeftTriggerPressed() => false;
  bool isRightTriggerPressed() => false;
  bool isViewTogglePressed() => false;

  // State getters
  bool isUpHeld() => false;
  bool isDownHeld() => false;
  bool isLeftHeld() => false;
  bool isRightHeld() => false;
  bool isConfirmHeld() => false;
  bool isCancelHeld() => false;

  // Axis values
  double getLeftStickX() => 0.0;
  double getLeftStickY() => 0.0;
  double getRightStickX() => 0.0;
  double getRightStickY() => 0.0;
  double getLeftTrigger() => 0.0;
  double getRightTrigger() => 0.0;

  void resetAllStates() {}

  // Grid navigation - returns null (no navigation) on web
  int? handleGridNavigation({
    required int currentIndex,
    required int itemCount,
    required int columns,
  }) => null;

  // List navigation
  int? handleListNavigation({
    required int currentIndex,
    required int itemCount,
  }) => null;

  // Carousel navigation
  int? handleCarouselNavigation({
    required int currentIndex,
    required int itemCount,
    bool loop = true,
  }) => null;
}
