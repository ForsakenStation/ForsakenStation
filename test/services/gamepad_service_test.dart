import 'package:flutter_test/flutter_test.dart';
import 'package:forsaken/services/gamepad_service.dart';

import '../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => TestHelpers.setupServiceTest());
  tearDown(() => TestHelpers.teardownServiceTest());

  group('GamepadService - singleton', () {
    test('instance returns the same object', () {
      final a = GamepadService.instance;
      final b = GamepadService.instance;
      expect(identical(a, b), isTrue);
    });
  });

  group('GamepadService - initial state', () {
    test('isGamepadConnected is false initially', () {
      expect(GamepadService.instance.isGamepadConnected, isFalse);
    });

    test('connectedGamepadId is null initially', () {
      expect(GamepadService.instance.connectedGamepadId, isNull);
    });

    test('axisValues is empty initially', () {
      expect(GamepadService.instance.axisValues, isEmpty);
    });

    test('buttonStates is empty initially', () {
      expect(GamepadService.instance.buttonStates, isEmpty);
    });

    test('isDebugMode is false initially', () {
      expect(GamepadService.instance.isDebugMode, isFalse);
    });
  });

  group('GamepadService - button constants', () {
    test('button constants are defined', () {
      expect(GamepadService.buttonA, isNotEmpty);
      expect(GamepadService.buttonB, isNotEmpty);
      expect(GamepadService.buttonX, isNotEmpty);
      expect(GamepadService.buttonY, isNotEmpty);
      expect(GamepadService.buttonStart, isNotEmpty);
      expect(GamepadService.buttonSelect, isNotEmpty);
    });

    test('axis constants are defined', () {
      expect(GamepadService.axisDpadX, isNotEmpty);
      expect(GamepadService.axisDpadY, isNotEmpty);
      expect(GamepadService.axisLeftX, isNotEmpty);
      expect(GamepadService.axisLeftY, isNotEmpty);
    });

    test('button constants are unique', () {
      final buttons = {
        GamepadService.buttonA,
        GamepadService.buttonB,
        GamepadService.buttonX,
        GamepadService.buttonY,
        GamepadService.buttonLB,
        GamepadService.buttonRB,
        GamepadService.buttonSelect,
        GamepadService.buttonStart,
      };
      expect(buttons.length, equals(8));
    });
  });

  group('GamepadService - isButtonPressed', () {
    test('isButtonPressed returns false for unknown button', () {
      expect(
        GamepadService.instance.isButtonPressed('__unknown__'),
        isFalse,
      );
    });
  });

  group('GamepadService - setDebugMode', () {
    test('setDebugMode toggles debug mode', () {
      GamepadService.instance.setDebugMode(true);
      expect(GamepadService.instance.isDebugMode, isTrue);
      GamepadService.instance.setDebugMode(false);
      expect(GamepadService.instance.isDebugMode, isFalse);
    });
  });
}
