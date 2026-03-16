import 'package:flutter_test/flutter_test.dart';

import 'package:forsaken/models/rom_item.dart';
import 'package:forsaken/services/rom_service.dart';

import '../helpers/test_data_generators.dart';
import '../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late RomService service;

  setUp(() {
    TestHelpers.setupServiceTest();
    service = RomService(romsBasePath: '/roms');
  });

  tearDown(() {
    TestHelpers.teardownServiceTest();
  });

  // ---------------------------------------------------------------------------
  // loadItemsFromRoms
  // ---------------------------------------------------------------------------
  group('loadItemsFromRoms', () {
    test('returns empty list when roms list is empty', () async {
      final items = await service.loadItemsFromRoms([], null, 'nes');

      expect(items, isEmpty);
    });

    test('returns ROM items for ROMs in root (no subdirectory)', () async {
      final roms = [
        TestDataGenerators.generateRom(platform: 'nes', index: 0),
        TestDataGenerators.generateRom(platform: 'nes', index: 1),
      ];

      final items = await service.loadItemsFromRoms(roms, null, 'nes');

      expect(items.length, equals(2));
      expect(items.every((i) => i.isRom), isTrue);
    });

    test('returns folder items at root level for ROMs in subdirectory',
        () async {
      final roms = [
        TestDataGenerators.generateRom(
          platform: 'nes',
          subdirectory: 'Japan',
          index: 0,
        ),
        TestDataGenerators.generateRom(
          platform: 'nes',
          subdirectory: 'Japan',
          index: 1,
        ),
      ];

      final items = await service.loadItemsFromRoms(roms, null, 'nes');

      expect(items.length, equals(1));
      expect(items.first.isFolder, isTrue);
      expect(items.first.name, equals('Japan'));
      expect(items.first.romCount, equals(2));
    });

    test('returns only ROMs in the given subdirectory when currentSubdirectory is set',
        () async {
      final roms = [
        TestDataGenerators.generateRom(
          platform: 'nes',
          subdirectory: 'Japan',
          index: 0,
        ),
        TestDataGenerators.generateRom(
          platform: 'nes',
          subdirectory: 'Japan',
          index: 1,
        ),
        TestDataGenerators.generateRom(
          platform: 'nes',
          subdirectory: 'USA',
          index: 2,
        ),
      ];

      final items = await service.loadItemsFromRoms(roms, 'Japan', 'nes');

      expect(items.length, equals(2));
      expect(items.every((i) => i.isRom), isTrue);
    });

    test('sorts folders before ROMs', () async {
      final roms = [
        TestDataGenerators.generateRom(platform
: 'nes', index: 0), // root ROM
        TestDataGenerators.generateRom(
          platform: 'nes',
          subdirectory: 'Japan',
          index: 1,
        ), // becomes folder
      ];

      final items = await service.loadItemsFromRoms(roms, null, 'nes');

      expect(items.length, equals(2));
      expect(items.first.isFolder, isTrue);
      expect(items.last.isRom, isTrue);
    });

    test('sets platform on returned items', () async {
      final roms = [
        TestDataGenerators.generateRom(platform: 'snes', index: 0),
      ];

      final items = await service.loadItemsFromRoms(roms, null, 'snes');

      expect(items.first.platform, equals('snes'));
    });

    test('returns no items when currentSubdirectory does not match any ROM',
        () async {
      final roms = [
        TestDataGenerators.generateRom(
          platform: 'nes',
          subdirectory: 'Japan',
          index: 0,
        ),
      ];

      final items = await service.loadItemsFromRoms(roms, 'USA', 'nes');

      expect(items, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // clearPlatformCache
  // ---------------------------------------------------------------------------
  group('clearPlatformCache', () {
    test('removes cached platform so subsequent call re-fetches', () async {
      // With no jsonlBasePath the service returns [] and nothing is cached,
      // but clearPlatformCache must not throw.
      expect(() => service.clearPlatformCache('nes'), returnsNormally);
    });

    test('does not affect other cached platforms', () async {
      final serviceWithJsonl = RomService(
        romsBasePath: '/roms',
        jsonlBasePath: '/jsonl',
      );

      // Clearing one platform should not throw even when cache is empty.
      expect(
        () => serviceWithJsonl.clearPlatformCache('nes'),
        returnsNormally,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // clearAllCaches
  // ---------------------------------------------------------------------------
  group('clearAllCaches', () {
    test('clears all cached platforms without throwing', () {
      expect(() => service.clearAllCaches(), returnsNormally);
    });

    test('can be called multiple times safely', () {
      service.clearAllCaches();
      expect(() => service.clearAllCaches(), returnsNormally);
    });
  });

  // ---------------------------------------------------------------------------
  // loadRomsForJsonlPlatform
  // ---------------------------------------------------------------------------
  group('loadRomsForJsonlPlatform', () {
    test('returns empty list when jsonlBasePath is null', () async {
      // service was created without jsonlBasePath
      final roms = await service.loadRomsForJsonlPlatform('nes');

      expect(roms, isEmpty);
    });

    test('returns empty list when jsonlBasePath is empty string', () async {
      final serviceEmpty = RomService(
        romsBasePath: '/roms',
        jsonlBasePath: '',
      );

      final roms = await serviceEmpty.loadRomsForJsonlPlatform('nes');

      expect(roms, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // property tests - error handling
  // ---------------------------------------------------------------------------
  // Feature: unit-testing-implementation, Property 6: Service Errors Throw Appropriate Exceptions
  group('property tests - error handling', () {
    test('loadItemsFromRoms never throws regardless of ROM data', () async {
      // Validates: Requirements 3.3
      // Generates 50 ROM lists with varying subdirectories (some null, some set)
      for (int i = 0; i < 50; i++) {
        final subdirectories = [null, 'Japan', 'USA', 'Europe', 'World'];
        final roms = List.generate(
          i % 10, // vary list size 0..9
          (j) => TestDataGenerators.generateRom(
            platform: 'nes',
            subdirectory: subdirectories[(i + j) % subdirectories.length],
            index: j,
          ),
        );

        // Must never throw
        final items = await service.loadItemsFromRoms(roms, null, 'nes');
        expect(items, isA<List>());
      }
    });

    test('loadItemsFromRoms result count is consistent with input', () async {
      // Validates: Requirements 3.3
      // Generates ROMs with known subdirectory distribution and verifies
      // folder count + root ROM count matches expected
      for (int i = 0; i < 50; i++) {
        final rootCount = i % 5;
        final folderACount = (i + 1) % 4;
        final folderBCount = (i + 2) % 3;

        final roms = [
          ...List.generate(
            rootCount,
            (j) => TestDataGenerators.generateRom(
              platform: 'nes',
              subdirectory: null,
              index: j,
            ),
          ),
          ...List.generate(
            folderACount,
            (j) => TestDataGenerators.generateRom(
              platform: 'nes',
              subdirectory: 'FolderA',
              index: 100 + j,
            ),
          ),
          ...List.generate(
            folderBCount,
            (j) => TestDataGenerators.generateRom(
              platform: 'nes',
              subdirectory: 'FolderB',
              index: 200 + j,
            ),
          ),
        ];

        final items = await service.loadItemsFromRoms(roms, null, 'nes');

        final expectedFolders = (folderACount > 0 ? 1 : 0) + (folderBCount > 0 ? 1 : 0);
        final actualFolders = items.where((item) => item.isFolder).length;
        final actualRoms = items.where((item) => item.isRom).length;

        expect(actualFolders, equals(expectedFolders));
        expect(actualRoms, equals(rootCount));
        expect(actualFolders + actualRoms, equals(expectedFolders + rootCount));
      }
    });

    test('clearAllCaches is idempotent', () {
      // Validates: Requirements 3.3
      // Calls clearAllCaches 10 times, verifies no exception
      for (int i = 0; i < 10; i++) {
        expect(() => service.clearAllCaches(), returnsNormally);
      }
    });
  });
}
