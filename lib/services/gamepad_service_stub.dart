// Stub for web platform - GamepadService uses gamepads package which doesn't support web
import 'dart:async';

class GamepadService {
  static GamepadService? _instance;

  GamepadService._();

  static GamepadService get instance {
    _instance ??= GamepadService._();
    return _instance!;
  }

  void Function(String gamepadId)? onGamepadConnected;

  Future<void> initialize() async {
    // No-op on web - gamepads package doesn't support web
  }

  void dispose() {}

  bool get isGamepadConnected => false;
  String? get connectedGamepadId => null;
}
