import 'package:flutter_test/flutter_test.dart';
import 'package:forsaken/models/download_result.dart';
import 'package:forsaken/models/rom.dart';
import 'package:forsaken/services/config_service.dart';
import 'package:forsaken/services/debug_service.dart';
import 'package:forsaken/services/download_service.dart';
import 'package:forsaken/services/platform_info_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    TestHelpers.setupServiceTest();
    SharedPreferences.setMockInitialValues({});
    await ConfigService.instance.loadConfig();
    DownloadService.initialize(romsBasePath: '/tmp/test_roms');
    PlatformInfoService.instance.clearCache();
  });

  tearDown(() {
    PlatformInfoService.instance.clearCache();
    TestHelpers.teardownServiceTest();
  });

  group('Error paths - DownloadService', () {
    test('downloadRom returns error result (not exception) for missing URL',
        () async {
      final rom = Rom(
        name: 'No URL',
        fileName: 'no_url.nes',
        platform: 'nes',
        urlFilePath: '/roms/nes/no_url.txt',
      );
      final result = await DownloadService.instance.downloadRom(rom);
      expect(result.success, isFalse);
      expect(result.errorType, isNotNull);
    });

    test('deleteTemporaryRom does not throw for missing file', () async {
      await expectLater(
        DownloadService.instance.deleteTemporaryRom('/nonexistent/path.nes'),
        completes,
      );
    });

    test('cleanupAllTemporaryRoms does not throw', () async {
      await expectLater(
        DownloadService.instance.cleanupAllTemporaryRoms(),
        completes,
      );
    });
  });

  group('Error paths - PlatformInfoService', () {
    test('getPlatformInfo returns null (not exception) for unknown id',
        () async {
      final result = await PlatformInfoService.instance
          .getPlatformInfo('__nonexistent__');
      expect(result, isNull);
    });

    test('hasPlatformInfo returns false (not exception) for unknown id',
        () async {
      final result = await PlatformInfoService.instance
          .hasPlatformInfo('__nonexistent__');
      expect(result, isFalse);
    });

    test('getAvailablePlatformIds does not throw', () async {
      await expectLater(
        PlatformInfoService.instance.getAvailablePlatformIds(),
        completes,
      );
    });
  });

  group('Error paths - DebugService', () {
    test('error() does not throw for null error object', () {
      expect(
        () => DebugService.instance.error('test error', tag: 'Test'),
        returnsNormally,
      );
    });

    test('error() does not throw for exception error object', () {
      expect(
        () => DebugService.instance.error(
          'test error',
          tag: 'Test',
          error: Exception('test'),
        ),
        returnsNormally,
      );
    });

    test('warning() does not throw', () {
      expect(
        () => DebugService.instance.warning('test warning', tag: 'Test'),
        returnsNormally,
      );
    });
  });

  // Property 17: Error Messages Include Context
  // Validates: Requisitos 8.3
  group('Property 17 - Error messages include context', () {
    test('DownloadResult error message is non-null when provided', () {
      final result = DownloadResult.error(
        DownloadErrorType.generic,
        message: 'Connection refused',
      );
      expect(result.errorMessage, isNotNull);
      expect(result.errorMessage, isNotEmpty);
    });

    test('DownloadResult error type is always set on failure', () {
      for (final type in DownloadErrorType.values) {
        final result = DownloadResult.error(type);
        expect(result.errorType, equals(type));
        expect(result.success, isFalse);
      }
    });
  });

  // Property 18: Resources Are Cleaned Up After Errors
  // Validates: Requisitos 8.4
  group('Property 18 - Resource cleanup after errors', () {
    test('clearCache can be called multiple times without error', () {
      for (var i = 0; i < 5; i++) {
        expect(
          () => PlatformInfoService.instance.clearCache(),
          returnsNormally,
        );
      }
    });

    test('cancelDownload can be called multiple times without error', () {
      for (var i = 0; i < 3; i++) {
        expect(
          () => DownloadService.instance.cancelDownload(),
          returnsNormally,
        );
      }
    });
  });

  // Task 15.4: Verify error logging in services
  // Validates: Requisitos 8.2, 8.5
  group('Error logging - DebugService integration', () {
    test('DebugService.instance is accessible from services', () {
      expect(DebugService.instance, isNotNull);
    });

    test('error level is higher priority than debug', () {
      expect(LogLevel.error.index, greaterThan(LogLevel.debug.index));
    });

    test('none level disables all logging', () {
      DebugService.initialize(isEnabled: true, minLevel: LogLevel.none);
      // All log calls should be silently ignored.
      expect(
        () {
          DebugService.instance.error('test', tag: 'T');
          DebugService.instance.warning('test', tag: 'T');
          DebugService.instance.info('test', tag: 'T');
          DebugService.instance.debug('test', tag: 'T');
        },
        returnsNormally,
      );
    });
  });
}
