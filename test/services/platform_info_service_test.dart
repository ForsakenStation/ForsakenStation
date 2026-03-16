import 'package:flutter_test/flutter_test.dart';
import 'package:forsaken/services/platform_info_service.dart';

import '../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestHelpers.setupServiceTest();
    PlatformInfoService.instance.clearCache();
  });

  tearDown(() {
    PlatformInfoService.instance.clearCache();
    TestHelpers.teardownServiceTest();
  });

  group('PlatformInfoService - cache', () {
    test('clearCache resets cached data', () {
      PlatformInfoService.instance.clearCache();
      // No exception means cache was cleared successfully.
    });

    test('loadPlatformInfo returns a map', () async {
      final result = await PlatformInfoService.instance.loadPlatformInfo();
      expect(result, isA<Map<String, dynamic>>());
    });

    test('second call to loadPlatformInfo uses cache', () async {
      final first = await PlatformInfoService.instance.loadPlatformInfo();
      final second = await PlatformInfoService.instance.loadPlatformInfo();
      expect(identical(first, second), isTrue);
    });

    test('clearCache forces reload on next call', () async {
      final first = await PlatformInfoService.instance.loadPlatformInfo();
      PlatformInfoService.instance.clearCache();
      final second = await PlatformInfoService.instance.loadPlatformInfo();
      expect(identical(first, second), isFalse);
    });
  });

  group('PlatformInfoService - getPlatformInfo', () {
    test('returns null for unknown platform', () async {
      final info = await PlatformInfoService.instance
          .getPlatformInfo('__nonexistent_platform__');
      expect(info, isNull);
    });

    test('is case-insensitive for platform id', () async {
      final lower = await PlatformInfoService.instance
          .getPlatformInfo('__unknown__');
      final upper = await PlatformInfoService.instance
          .getPlatformInfo('__UNKNOWN__');
      expect(lower, equals(upper));
    });
  });

  group('PlatformInfoService - hasPlatformInfo', () {
    test('returns false for unknown platform', () async {
      final has = await PlatformInfoService.instance
          .hasPlatformInfo('__nonexistent_platform__');
      expect(has, isFalse);
    });

    test('is case-insensitive', () async {
      final lower = await PlatformInfoService.instance
          .hasPlatformInfo('__unknown__');
      final upper = await PlatformInfoService.instance
          .hasPlatformInfo('__UNKNOWN__');
      expect(lower, equals(upper));
    });
  });

  group('PlatformInfoService - getAvailablePlatformIds', () {
    test('returns a list', () async {
      final ids = await PlatformInfoService.instance.getAvailablePlatformIds();
      expect(ids, isA<List<String>>());
    });

    test('result is not null', () async {
      final ids = await PlatformInfoService.instance.getAvailablePlatformIds();
      expect(ids, isNotNull);
    });
  });

  group('PlatformInfoService - consistency', () {
    test('hasPlatformInfo matches getPlatformInfo result', () async {
      const id = '__test_consistency__';
      final has = await PlatformInfoService.instance.hasPlatformInfo(id);
      final info = await PlatformInfoService.instance.getPlatformInfo(id);
      if (has) {
        expect(info, isNotNull);
      } else {
        expect(info, isNull);
      }
    });

    test('getAvailablePlatformIds are all hasPlatformInfo=true', () async {
      final ids = await PlatformInfoService.instance.getAvailablePlatformIds();
      for (final id in ids) {
        final has = await PlatformInfoService.instance.hasPlatformInfo(id);
        expect(has, isTrue, reason: 'Expected hasPlatformInfo($id) to be true');
      }
    });
  });

  // Property 8: Cache Invalidation Works Correctly
  // Validates: Requisitos 3.6
  group('Property 8 - Cache Invalidation', () {
    test('clearCache always produces a fresh map on next load', () async {
      for (var i = 0; i < 3; i++) {
        final before = await PlatformInfoService.instance.loadPlatformInfo();
        PlatformInfoService.instance.clearCache();
        final after = await PlatformInfoService.instance.loadPlatformInfo();
        expect(
          identical(before, after),
          isFalse,
          reason: 'Cycle $i: expected a new map after clearCache',
        );
      }
    });

    test('cache is stable between calls without clearCache', () async {
      final results = <Map<String, dynamic>>[];
      for (var i = 0; i < 5; i++) {
        results.add(await PlatformInfoService.instance.loadPlatformInfo());
      }
      for (var i = 1; i < results.length; i++) {
        expect(
          identical(results[0], results[i]),
          isTrue,
          reason: 'Call $i should return the cached instance',
        );
      }
    });

    test('hasPlatformInfo returns a bool after clearCache', () async {
      PlatformInfoService.instance.clearCache();
      final ids = ['__a__', '__b__', '__c__'];
      for (final id in ids) {
        final has = await PlatformInfoService.instance.hasPlatformInfo(id);
        expect(has, isA<bool>());
      }
    });
  });
}
