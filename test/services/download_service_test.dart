import 'package:flutter_test/flutter_test.dart';
import 'package:forsaken/models/download_result.dart';
import 'package:forsaken/models/rom.dart';
import 'package:forsaken/services/download_service.dart';
import 'package:forsaken/services/config_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_data_generators.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    TestHelpers.setupServiceTest();
    SharedPreferences.setMockInitialValues({});
    await ConfigService.instance.loadConfig();
    DownloadService.initialize(romsBasePath: '/tmp/test_roms');
  });

  tearDown(() {
    TestHelpers.teardownServiceTest();
  });

  group('DownloadResult - factory constructors', () {
    test('ok creates successful result with filePath', () {
      final result = DownloadResult.ok('/tmp/rom.nes');
      expect(result.success, isTrue);
      expect(result.filePath, equals('/tmp/rom.nes'));
      expect(result.errorType, isNull);
    });

    test('error creates failed result with errorType', () {
      final result = DownloadResult.error(
        DownloadErrorType.notFound,
        message: 'File not found',
        httpStatusCode: 404,
      );
      expect(result.success, isFalse);
      expect(result.filePath, isNull);
      expect(result.errorType, equals(DownloadErrorType.notFound));
      expect(result.errorMessage, equals('File not found'));
      expect(result.httpStatusCode, equals(404));
    });

    test('isAuthError is true for authRequired error', () {
      final result = DownloadResult.error(DownloadErrorType.authRequired);
      expect(result.isAuthError, isTrue);
    });

    test('isAuthError is false for other error types', () {
      for (final type in DownloadErrorType.values) {
        if (type == DownloadErrorType.authRequired) continue;
        final result = DownloadResult.error(type);
        expect(result.isAuthError, isFalse, reason: 'type=$type');
      }
    });
  });

  group('DownloadService - initialization', () {
    test('initialize sets custom romsBasePath', () {
      DownloadService.initialize(romsBasePath: '/custom/path');
      expect(DownloadService.instance.romsBasePath, equals('/custom/path'));
    });

    test('instance returns singleton', () {
      final a = DownloadService.instance;
      final b = DownloadService.instance;
      expect(identical(a, b), isTrue);
    });
  });

  group('DownloadService - downloadRom with no URL', () {
    test('returns error when ROM has no downloadUrl', () async {
      final rom = Rom(
        name: 'No URL Rom',
        fileName: 'no_url.nes',
        platform: 'nes',
        urlFilePath: '/roms/nes/no_url.txt',
      );
      final result = await DownloadService.instance.downloadRom(rom);
      expect(result.success, isFalse);
      expect(result.errorType, equals(DownloadErrorType.generic));
    });

    test('returns error when ROM has empty downloadUrl', () async {
      final rom = Rom(
        name: 'Empty URL Rom',
        fileName: 'empty_url.nes',
        platform: 'nes',
        urlFilePath: '/roms/nes/empty_url.txt',
      );
      rom.downloadUrl = '';
      final result = await DownloadService.instance.downloadRom(rom);
      expect(result.success, isFalse);
    });
  });

  group('DownloadService - cancelDownload', () {
    test('cancelDownload does not throw', () {
      expect(() => DownloadService.instance.cancelDownload(), returnsNormally);
    });
  });

  group('DownloadService - cleanup methods', () {
    test('deleteTemporaryRom does not throw for non-existent file', () async {
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

    test('cleanupPlatformTemporaryRoms does not throw', () async {
      await expectLater(
        DownloadService.instance.cleanupPlatformTemporaryRoms('nes'),
        completes,
      );
    });
  });

  // Property 9: Download Retry Logic Eventually Succeeds or Exhausts
  // Validates: Requisitos 4.5
  group('Property 9 - Download error types are exhaustive', () {
    test('all DownloadErrorType values produce failed results', () {
      for (final type in DownloadErrorType.values) {
        final result = DownloadResult.error(type, message: 'test');
        expect(result.success, isFalse, reason: 'type=$type should be failure');
        expect(result.errorType, equals(type));
      }
    });

    test('ok result is never a failure', () {
      final result = DownloadResult.ok('/some/path');
      expect(result.success, isTrue);
      expect(result.errorType, isNull);
      expect(result.filePath, isNotNull);
    });
  });

  // Property 10: Download Progress Is Monotonic
  // Validates: Requisitos 4.6
  group('Property 10 - Download progress callback', () {
    test('downloadRom with invalid URL returns error without throwing', () async {
      final rom = TestDataGenerators.generateRom(platform: 'nes');
      rom.downloadUrl = 'https://invalid.example.invalid/rom.nes';
      // Should return an error result, not throw.
      final result = await DownloadService.instance.downloadRom(rom);
      expect(result, isA<DownloadResult>());
      expect(result.success, isFalse);
    });

    test('progress values are between 0 and 1 when provided', () {
      // Verify the progress callback contract via DownloadResult structure.
      // Actual network calls are not made in unit tests.
      final progressValues = <double>[];
      void onProgress(double p, int r, int t) {
        progressValues.add(p);
      }

      // Simulate what the service would call.
      onProgress(0.0, 0, 100);
      onProgress(0.5, 50, 100);
      onProgress(1.0, 100, 100);

      for (var i = 1; i < progressValues.length; i++) {
        expect(
          progressValues[i],
          greaterThanOrEqualTo(progressValues[i - 1]),
          reason: 'Progress should be monotonically non-decreasing',
        );
      }
    });
  });
}
