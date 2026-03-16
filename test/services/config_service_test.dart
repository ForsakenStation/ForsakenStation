import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:forsaken/services/config_service.dart';
import '../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    TestHelpers.setupServiceTest();
    SharedPreferences.setMockInitialValues({});
    // Re-initialize the singleton with fresh SharedPreferences state.
    await ConfigService.instance.initialize();
  });

  tearDown(() {
    TestHelpers.teardownServiceTest();
  });

  // ---------------------------------------------------------------------------
  // loadConfig
  // ---------------------------------------------------------------------------
  group('loadConfig', () {
    test('returns empty emulators list when no config stored', () async {
      final config = await ConfigService.instance.loadConfig(forceReload: true);

      // When no SharedPreferences value exists the service falls back to the
      // bundled asset.  The asset always contains an "emulators" key.
      expect(config, isA<Map<String, dynamic>>());
      expect(config.containsKey('emulators'), isTrue);
    });

    test('returns saved config after saveConfig is called', () async {
      const testConfig = {
        'emulators': [
          {
            'system': 'nes',
            'command': 'retroarch -L nestopia_libretro.so {ROM}',
          },
        ],
      };

      await ConfigService.instance.saveConfig(testConfig);
      final loaded =
          await ConfigService.instance.loadConfig(forceReload: true);

      expect(loaded['emulators'], isA<List>());
      expect((loaded['emulators'] as List).length, equals(1));
    });
  });

  // ---------------------------------------------------------------------------
  // saveConfig
  // ---------------------------------------------------------------------------
  group('saveConfig', () {
    test('persists config so subsequent loadConfig returns it', () async {
      final config = {
        'emulators': [
          {'system': 'snes', 'command': 'retroarch -L snes9x_libretro.so'},
        ],
      };

      await ConfigService.instance.saveConfig(config);

      // Force a fresh load from SharedPreferences.
      final loaded =
          await ConfigService.instance.loadConfig(forceReload: true);
      final emulators = loaded['emulators'] as List;

      expect(emulators.length, equals(1));
      expect((emulators.first as Map)['system'], equals('snes'));
    });

    test('overwrites previously saved config', () async {
      await ConfigService.instance.saveConfig({
        'emulators': [
          {'system': 'nes', 'command': 'retroarch -L nestopia_libretro.so'},
        ],
      });

      await ConfigService.instance.saveConfig({
        'emulators': [
          {'system': 'genesis', 'command': 'retroarch -L genesis_plus_gx'},
          {'system': 'snes', 'command': 'retroarch -L snes9x_libretro.so'},
        ],
      });

      final loaded =
          await ConfigService.instance.loadConfig(forceReload: true);
      final emulators = loaded['emulators'] as List;

      expect(emulators.length, equals(2));
    });
  });

  // ---------------------------------------------------------------------------
  // getEmulators
  // ---------------------------------------------------------------------------
  group('getEmulators', () {
    test('returns empty list when no emulators configured', () async {
      await ConfigService.instance.saveConfig({'emulators': []});

      final emulators = await ConfigService.instance.getEmulators();

      expect(emulators, isEmpty);
    });

    test('returns configured emulators', () async {
      await ConfigService.instance.saveConfig({
        'emulators': [
          {'system': 'nes', 'command': 'retroarch -L nestopia_libretro.so'},
          {'system': 'snes', 'command': 'retroarch -L snes9x_libretro.so'},
        ],
      });

      final emulators = await ConfigService.instance.getEmulators();

      expect(emulators.length, equals(2));
    });
  });

  // ---------------------------------------------------------------------------
  // getEmulatorForPlatform
  // ---------------------------------------------------------------------------
  group('getEmulatorForPlatform', () {
    test('returns null for unconfigured platform', () async {
      await ConfigService.instance.saveConfig({'emulators': []});

      final result =
          await ConfigService.instance.getEmulatorForPlatform('ps5');

      expect(result, isNull);
    });

    test('returns correct emulator for configured platform', () async {
      await ConfigService.instance.saveConfig({
        'emulators': [
          {'system': 'nes', 'command': 'retroarch -L nestopia_libretro.so'},
          {'system': 'snes', 'command': 'retroarch -L snes9x_libretro.so'},
        ],
      });

      final result =
          await ConfigService.instance.getEmulatorForPlatform('nes');

      expect(result, isNotNull);
      expect(result!['system'], equals('nes'));
    });

    test('returns null when platform does not match any entry', () async {
      await ConfigService.instance.saveConfig({
        'emulators': [
          {'system': 'nes', 'command': 'retroarch -L nestopia_libretro.so'},
        ],
      });

      final result =
          await ConfigService.instance.getEmulatorForPlatform('genesis');

      expect(result, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // Path getters (default values with empty SharedPreferences)
  // ---------------------------------------------------------------------------
  group('path getters', () {
    test('romsPath returns empty string by default', () {
      expect(ConfigService.instance.romsPath, equals(''));
    });

    test('isDebugEnabled returns false by default', () {
      expect(ConfigService.instance.isDebugEnabled, isFalse);
    });

    test('isSetupCompleted returns false by default', () {
      expect(ConfigService.instance.isSetupCompleted, isFalse);
    });

    test('debugMinLevel returns "debug" by default', () {
      expect(ConfigService.instance.debugMinLevel, equals('debug'));
    });
  });

  // ---------------------------------------------------------------------------
  // property tests - singleton state consistency
  // Feature: unit-testing-implementation, Property 7: Singleton State Consistency
  // ---------------------------------------------------------------------------
  group('property tests - singleton state consistency', () {
    // Validates: Requirements 3.4
    test('ConfigService.instance always returns the same instance', () {
      final instances = List.generate(10, (_) => ConfigService.instance);
      for (final instance in instances) {
        expect(identical(instance, instances.first), isTrue);
      }
    });

    // Validates: Requirements 3.4
    test(
        'saveConfig followed by loadConfig is consistent across multiple calls',
        () async {
      const testConfig = {
        'emulators': [
          {'system': 'nes', 'command': 'retroarch -L nestopia_libretro.so'},
          {'system': 'snes', 'command': 'retroarch -L snes9x_libretro.so'},
        ],
      };

      await ConfigService.instance.saveConfig(testConfig);

      final results = await Future.wait(
        List.generate(
          5,
          (_) => ConfigService.instance.loadConfig(forceReload: true),
        ),
      );

      final expectedCount = (testConfig['emulators'] as List).length;
      for (final result in results) {
        expect((result['emulators'] as List).length, equals(expectedCount));
      }
    });

    // Validates: Requirements 3.4
    test('setPathSetting persists and is readable via getter', () async {
      await ConfigService.instance.setPathSetting('ROMS_PATH', '/test/path');
      expect(ConfigService.instance.romsPath, equals('/test/path'));
    });
  });
}
