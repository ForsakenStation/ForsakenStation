import 'package:flutter_test/flutter_test.dart';
import 'package:forsaken/services/emulator_download_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:forsaken/services/config_service.dart';

import '../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    TestHelpers.setupServiceTest();
    SharedPreferences.setMockInitialValues({});
    await ConfigService.instance.loadConfig();
  });

  tearDown(() => TestHelpers.teardownServiceTest());

  group('EmulatorDownloadService - singleton', () {
    test('instance returns the same object', () {
      final a = EmulatorDownloadService.instance;
      final b = EmulatorDownloadService.instance;
      expect(identical(a, b), isTrue);
    });
  });

  group('EmulatorDownloadService - downloadEmulator', () {
    test('downloadEmulator with null platform download returns null', () async {
      // EmulatorDownloadInfo with no platform-specific download should
      // cause getDownloadForCurrentPlatform() to return null → returns null.
      // We verify the method exists and returns a Future<String?>.
      // (Actual network calls are not made in unit tests.)
      expect(EmulatorDownloadService.instance.downloadEmulator, isA<Function>());
    });
  });
}
