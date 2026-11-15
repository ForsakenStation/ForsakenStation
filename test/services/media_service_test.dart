import 'package:flutter_test/flutter_test.dart';
import 'package:forsaken/models/media.dart';
import 'package:forsaken/models/rom.dart';
import 'package:forsaken/services/media_service.dart';
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
  });

  tearDown(() => TestHelpers.teardownServiceTest());

  group('MediaService - singleton', () {
    test('instance returns the same object', () {
      final a = MediaService.instance;
      final b = MediaService.instance;
      expect(identical(a, b), isTrue);
    });
  });

  group('MediaService - getMediaForRom with non-existent paths', () {
    test('returns RomMedia with no media for ROM with non-existent paths',
        () async {
      final rom = TestDataGenerators.generateRom(platform: 'nes');
      final media = await MediaService.instance.getMediaForRom(rom);
      expect(media, isA<RomMedia>());
      expect(media.romName, isNotEmpty);
      expect(media.platform, equals('nes'));
    });

    test('hasAnyMedia is false when no media files exist', () async {
      final rom = TestDataGenerators.generateRom(platform: 'nes');
      final media = await MediaService.instance.getMediaForRom(rom);
      expect(media.hasAnyMedia, isFalse);
    });

    test('allMedia is empty when no media files exist', () async {
      final rom = TestDataGenerators.generateRom(platform: 'nes');
      final media = await MediaService.instance.getMediaForRom(rom);
      expect(media.allMedia, isEmpty);
    });
  });

  group('MediaService - getBestImagePath', () {
    test('returns null when RomMedia has no media', () {
      final romMedia = RomMedia(romName: 'test', platform: 'nes');
      final path = MediaService.instance.getBestImagePath(romMedia);
      expect(path, isNull);
    });

    test('returns box3d path when box3d exists', () {
      final romMedia = RomMedia(
        romName: 'test',
        platform: 'nes',
        box3d: Media(
          romName: 'test',
          platform: 'nes',
          type: MediaType.box3d,
          path: '/media/nes/3dboxes/test.png',
          existsVerified: true,
        ),
      );
      expect(MediaService.instance.getBestImagePath(romMedia), isNotNull);
    });
  });

  group('MediaService - getBestImagePathForCarousel', () {
    test('returns null when RomMedia has no media', () {
      final romMedia = RomMedia(romName: 'test', platform: 'nes');
      final path = MediaService.instance.getBestImagePathForCarousel(romMedia);
      expect(path, isNull);
    });

    test('prefers mixImage over box3d', () {
      final romMedia = RomMedia(
        romName: 'test',
        platform: 'nes',
        mixImage: Media(
          romName: 'test',
          platform: 'nes',
          type: MediaType.mixImage,
          path: '/media/nes/miximages/test.png',
          existsVerified: true,
        ),
        box3d: Media(
          romName: 'test',
          platform: 'nes',
          type: MediaType.box3d,
          path: '/media/nes/3dboxes/test.png',
          existsVerified: true,
        ),
      );
      final path = MediaService.instance.getBestImagePathForCarousel(romMedia);
      expect(path, contains('miximages'));
    });
  });

  group('MediaService - getLaunchImagePath', () {
    test('returns null when no launch image exists', () {
      final romMedia = RomMedia(romName: 'test', platform: 'nes');
      expect(MediaService.instance.getLaunchImagePath(romMedia), isNull);
    });

    test('returns marquee path when marquee exists', () {
      final romMedia = RomMedia(
        romName: 'test',
        platform: 'nes',
        marquee: Media(
          romName: 'test',
          platform: 'nes',
          type: MediaType.marquee,
          path: '/media/nes/marquee/test.png',
          existsVerified: true,
        ),
      );
      expect(MediaService.instance.getLaunchImagePath(romMedia), isNotNull);
    });
  });

  group('MediaService - hasAnyMedia', () {
    test('returns false for ROM with no media files', () async {
      final rom = Rom(
        name: 'No Media Rom',
        fileName: 'no_media.nes',
        platform: 'nes',
        urlFilePath: '/roms/nes/no_media.txt',
      );
      final result = await MediaService.instance.hasAnyMedia(rom);
      expect(result, isFalse);
    });
  });

  group('MediaService - getSystemImage', () {
    test('returns a string or null for unknown platform', () async {
      final result =
          await MediaService.instance.getSystemImage('__unknown_platform__');
      // May return null or a default path — both are valid.
      expect(result, anyOf(isNull, isA<String>()));
    });
  });

  group('MediaService - getSystemBackground', () {
    test('returns a non-empty string', () async {
      final result =
          await MediaService.instance.getSystemBackground('__unknown__');
      expect(result, isA<String>());
      expect(result.isNotEmpty, isTrue);
    });
  });

  group('RomMedia - model', () {
    test('empty RomMedia has no media', () {
      final romMedia = RomMedia(romName: 'test', platform: 'nes');
      expect(romMedia.hasAnyMedia, isFalse);
      expect(romMedia.allMedia, isEmpty);
      expect(romMedia.manualPath, isNull);
    });

    test('toString includes romName', () {
      final romMedia = RomMedia(romName: 'my_rom', platform: 'snes');
      expect(romMedia.toString(), contains('my_rom'));
    });
  });

  group('Media - model', () {
    test('isImage is true for non-video types', () {
      final media = Media(
        romName: 'test',
        platform: 'nes',
        type: MediaType.cover,
        path: '/path/cover.png',
        existsVerified: false,
      );
      expect(media.isImage, isTrue);
      expect(media.isVideo, isFalse);
    });

    test('isVideo is true for video type', () {
      final media = Media(
        romName: 'test',
        platform: 'nes',
        type: MediaType.video,
        path: '/path/video.mp4',
        existsVerified: false,
      );
      expect(media.isVideo, isTrue);
      expect(media.isImage, isFalse);
    });

    test('typeName is non-empty for all MediaType values', () {
      for (final type in MediaType.values) {
        final media = Media(
          romName: 'test',
          platform: 'nes',
          type: type,
          path: '/path/file',
          existsVerified: false,
        );
        expect(media.typeName, isNotEmpty, reason: 'type=$type');
      }
    });
  });
}
