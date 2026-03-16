import 'package:flutter_test/flutter_test.dart';
import 'package:forsaken/services/gamelist_download_service.dart';

import '../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => TestHelpers.setupServiceTest());
  tearDown(() => TestHelpers.teardownServiceTest());

  group('GamelistDownloadService - singleton', () {
    test('instance returns the same object', () {
      final a = GamelistDownloadService.instance;
      final b = GamelistDownloadService.instance;
      expect(identical(a, b), isTrue);
    });
  });

  group('GamelistDownloadService - API contract', () {
    // The service delegates to platform_service which requires path_provider.
    // In unit tests we verify the public API surface exists.

    test('exposes isDownloaded method', () {
      expect(GamelistDownloadService.instance.isDownloaded, isA<Function>());
    });

    test('exposes downloadAndExtract method', () {
      expect(
        GamelistDownloadService.instance.downloadAndExtract,
        isA<Function>(),
      );
    });

    test('exposes deleteGamelists method', () {
      expect(GamelistDownloadService.instance.deleteGamelists, isA<Function>());
    });

    test('exposes getDownloadInfo method', () {
      expect(GamelistDownloadService.instance.getDownloadInfo, isA<Function>());
    });
  });
}
