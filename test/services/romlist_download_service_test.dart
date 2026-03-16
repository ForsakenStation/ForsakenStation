import 'package:flutter_test/flutter_test.dart';
import 'package:forsaken/services/romlist_download_service.dart';

import '../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => TestHelpers.setupServiceTest());
  tearDown(() => TestHelpers.teardownServiceTest());

  group('RomlistDownloadService - singleton', () {
    test('instance returns the same object', () {
      final a = RomlistDownloadService.instance;
      final b = RomlistDownloadService.instance;
      expect(identical(a, b), isTrue);
    });

    test('RomListDownloadService typedef resolves to same instance', () {
      expect(
        identical(RomlistDownloadService.instance, RomListDownloadService.instance),
        isTrue,
      );
    });
  });

  group('RomlistDownloadService - API contract', () {
    // getJsonlPath, isDownloaded, getDownloadInfo, deleteRomlists all delegate
    // to platform_service which requires path_provider — not available in unit
    // tests. We verify the methods exist and are callable via reflection only.

    test('instance exposes getJsonlPath method', () {
      expect(RomlistDownloadService.instance.getJsonlPath, isA<Function>());
    });

    test('instance exposes isDownloaded method', () {
      expect(RomlistDownloadService.instance.isDownloaded, isA<Function>());
    });

    test('instance exposes getDownloadInfo method', () {
      expect(RomlistDownloadService.instance.getDownloadInfo, isA<Function>());
    });

    test('instance exposes deleteRomlists method', () {
      expect(RomlistDownloadService.instance.deleteRomlists, isA<Function>());
    });
  });

  group('RomlistDownloadService - legacy API', () {
    test('instance exposes isGameListsDownloaded method', () {
      expect(
        RomlistDownloadService.instance.isGameListsDownloaded,
        isA<Function>(),
      );
    });

    test('instance exposes downloadGameLists method', () {
      expect(
        RomlistDownloadService.instance.downloadGameLists,
        isA<Function>(),
      );
    });
  });
}
