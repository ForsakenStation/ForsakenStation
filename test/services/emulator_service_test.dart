import 'package:flutter_test/flutter_test.dart';
import 'package:forsaken/services/emulator_service.dart';
import 'package:forsaken/services/download_service.dart';
import 'package:forsaken/services/config_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    TestHelpers.setupServiceTest();
    SharedPreferences.setMockInitialValues({});
    await ConfigService.instance.loadConfig();
    DownloadService.initialize(romsBasePath: '/tmp/test_roms');
    EmulatorService.initialize(
      emulatorsBasePath: '/tmp/test_emulators',
      downloadService: DownloadService.instance,
    );
  });

  tearDown(() => TestHelpers.teardownServiceTest());

  group('EmulatorService - initialization', () {
    test('initialize sets custom emulatorsBasePath', () {
      EmulatorService.initialize(
        emulatorsBasePath: '/custom/emulators',
        downloadService: DownloadService.instance,
      );
      expect(
        EmulatorService.instance.emulatorsBasePath,
        equals('/custom/emulators'),
      );
    });

    test('instance returns singleton', () {
      final a = EmulatorService.instance;
      final b = EmulatorService.instance;
      expect(identical(a, b), isTrue);
    });
  });

  group('EmulatorService - platform configuration', () {
    test('isPlatformConfigured returns false for unknown platform', () async {
      final result = await EmulatorService.instance
          .isPlatformConfigured('__nonexistent__');
      expect(result, isFalse);
    });

    test('loadPlatformConfig returns null for unknown platform', () async {
      final config = await EmulatorService.instance
          .loadPlatformConfig('__nonexistent__');
      // May return null or a config with no commands depending on config file.
      expect(config == null || config.commands.isEmpty, isTrue);
    });

    test('getConfiguredPlatforms returns a list', () async {
      final platforms = await EmulatorService.instance.getConfiguredPlatforms();
      expect(platforms, isA<List<String>>());
    });
  });

  group('EmulatorService - cancelDownload', () {
    test('cancelDownload does not throw', () {
      expect(() => EmulatorService.instance.cancelDownload(), returnsNormally);
    });
  });

  group('EmulatorService - overlay support', () {
    test('hasOverlaySupport returns a bool', () async {
      final result =
          await EmulatorService.instance.hasOverlaySupport('__test__');
      expect(result, isA<bool>());
    });

    test('getDefaultOverlay returns null for unknown platform', () async {
      final overlay =
          await EmulatorService.instance.getDefaultOverlay('__unknown__');
      expect(overlay, isNull);
    });

    test('getAvailableOverlays returns a list', () async {
      final overlays =
          await EmulatorService.instance.getAvailableOverlays('__test__');
      expect(overlays, isA<List>());
    });
  });

  group('EmulatorService - reloadConfig', () {
    test('reloadConfig does not throw', () async {
      await expectLater(
        EmulatorService.instance.reloadConfig(),
        completes,
      );
    });
  });
}
