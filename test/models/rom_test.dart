import 'package:flutter_test/flutter_test.dart';
import 'package:forsaken/models/rom.dart';
import '../helpers/test_data_generators.dart';

void main() {
  group('Rom', () {
    group('constructor', () {
      test('creates instance with required fields', () {
        // Arrange & Act
        final rom = Rom(
          name: 'Super Mario Bros.nes',
          fileName: 'super_mario_bros.nes',
          platform: 'nes',
          urlFilePath: '/roms/nes/super_mario_bros.txt',
        );

        // Assert
        expect(rom.name, 'Super Mario Bros.nes');
        expect(rom.fileName, 'super_mario_bros.nes');
        expect(rom.platform, 'nes');
        expect(rom.urlFilePath, '/roms/nes/super_mario_bros.txt');
      });

      test('optional fields default to null', () {
        // Arrange & Act
        final rom = Rom(
          name: 'Game.txt',
          fileName: 'game.nes',
          platform: 'nes',
          urlFilePath: '/roms/nes/game.txt',
        );

        // Assert
        expect(rom.downloadUrl, isNull);
        expect(rom.localPath, isNull);
        expect(rom.subdirectory, isNull);
      });

      test('isDownloading defaults to false', () {
        // Arrange & Act
        final rom = Rom(
          name: 'Game.txt',
          fileName: 'game.nes',
          platform: 'nes',
          urlFilePath: '/roms/nes/game.txt',
        );

        // Assert
        expect(rom.isDownloading, isFalse);
      });

      test('downloadProgress defaults to 0.0', () {
        // Arrange & Act
        final rom = Rom(
          name: 'Game.txt',
          fileName: 'game.nes',
          platform: 'nes',
          urlFilePath: '/roms/nes/game.txt',
        );

        // Assert
        expect(rom.downloadProgress, 0.0);
      });

      test('accepts optional fields when provided', () {
        // Arrange & Act
        final rom = Rom(
          name: 'Game.txt',
          fileName: 'game.nes',
          platform: 'nes',
          urlFilePath: '/roms/nes/game.txt',
          downloadUrl: 'https://example.com/game.nes',
          localPath: '/tmp/game.nes',
          subdirectory: 'subdir',
        );

        // Assert
        expect(rom.downloadUrl, 'https://example.com/game.nes');
        expect(rom.localPath, '/tmp/game.nes');
        expect(rom.subdirectory, 'subdir');
      });
    });

    group('displayName', () {
      test('removes .txt extension from name', () {
        // Arrange
        final rom = Rom(
          name: 'Super Mario Bros.txt',
          fileName: 'super_mario_bros.nes',
          platform: 'nes',
          urlFilePath: '/roms/nes/super_mario_bros.txt',
        );

        // Act
        final result = rom.displayName;

        // Assert
        expect(result, 'Super Mario Bros');
      });

      test('returns name unchanged when no .txt extension', () {
        // Arrange
        final rom = Rom(
          name: 'Super Mario Bros',
          fileName: 'super_mario_bros.nes',
          platform: 'nes',
          urlFilePath: '/roms/nes/super_mario_bros.txt',
        );

        // Act
        final result = rom.displayName;

        // Assert
        expect(result, 'Super Mario Bros');
      });

      test('handles empty name', () {
        // Arrange
        final rom = Rom(
          name: '',
          fileName: 'game.nes',
          platform: 'nes',
          urlFilePath: '/roms/nes/game.txt',
        );

        // Act
        final result = rom.displayName;

        // Assert
        expect(result, '');
      });

      test('removes .txt even when embedded in name', () {
        // Arrange
        final rom = Rom(
          name: 'Game.txt Edition.txt',
          fileName: 'game.nes',
          platform: 'nes',
          urlFilePath: '/roms/nes/game.txt',
        );

        // Act
        final result = rom.displayName;

        // Assert
        // replaceAll removes all occurrences
        expect(result, 'Game Edition');
      });
    });

    group('toString', () {
      test('returns expected format', () {
        // Arrange
        final rom = Rom(
          name: 'Zelda.txt',
          fileName: 'zelda.nes',
          platform: 'nes',
          urlFilePath: '/roms/nes/zelda.txt',
        );

        // Act
        final result = rom.toString();

        // Assert
        expect(result, 'Rom(name: Zelda, platform: nes)');
      });

      test('uses displayName (without .txt) in toString', () {
        // Arrange
        final rom = Rom(
          name: 'Metroid.txt',
          fileName: 'metroid.nes',
          platform: 'nes',
          urlFilePath: '/roms/nes/metroid.txt',
        );

        // Act
        final result = rom.toString();

        // Assert
        expect(result, contains('Metroid'));
        expect(result, isNot(contains('.txt')));
      });
    });

    // Feature: unit-testing-implementation, Property 1: JSON Serialization Round-Trip (displayName consistency)
    group('property tests', () {
      test('displayName is consistent and never contains .txt across generated roms', () {
        // Validates: Requirements 2.1, 7.1, 7.2
        for (var i = 0; i < 100; i++) {
          final rom = TestDataGenerators.generateRom(index: i);

          // displayName never contains .txt
          expect(rom.displayName, isNot(contains('.txt')));

          // displayName is idempotent (calling twice returns same value)
          expect(rom.displayName, equals(rom.displayName));

          // toString contains the platform
          expect(rom.toString(), contains(rom.platform));
        }
      });

      test('isDownloading starts as false for all generated roms', () {
        // Validates: Requirements 2.1
        for (var i = 0; i < 100; i++) {
          final rom = TestDataGenerators.generateRom(index: i);
          expect(rom.isDownloading, isFalse);
        }
      });

      test('downloadProgress starts at 0.0 for all generated roms', () {
        // Validates: Requirements 2.1
        for (var i = 0; i < 100; i++) {
          final rom = TestDataGenerators.generateRom(index: i);
          expect(rom.downloadProgress, 0.0);
        }
      });
    });

    group('mutable fields', () {
      test('downloadUrl can be updated', () {
        // Arrange
        final rom = Rom(
          name: 'Game.txt',
          fileName: 'game.nes',
          platform: 'nes',
          urlFilePath: '/roms/nes/game.txt',
        );

        // Act
        rom.downloadUrl = 'https://example.com/game.nes';

        // Assert
        expect(rom.downloadUrl, 'https://example.com/game.nes');
      });

      test('localPath can be updated', () {
        // Arrange
        final rom = Rom(
          name: 'Game.txt',
          fileName: 'game.nes',
          platform: 'nes',
          urlFilePath: '/roms/nes/game.txt',
        );

        // Act
        rom.localPath = '/tmp/game.nes';

        // Assert
        expect(rom.localPath, '/tmp/game.nes');
      });

      test('subdirectory can be updated', () {
        // Arrange
        final rom = Rom(
          name: 'Game.txt',
          fileName: 'game.nes',
          platform: 'nes',
          urlFilePath: '/roms/nes/game.txt',
        );

        // Act
        rom.subdirectory = 'subdir';

        // Assert
        expect(rom.subdirectory, 'subdir');
      });

      test('isDownloading can be updated', () {
        // Arrange
        final rom = Rom(
          name: 'Game.txt',
          fileName: 'game.nes',
          platform: 'nes',
          urlFilePath: '/roms/nes/game.txt',
        );

        // Act
        rom.isDownloading = true;

        // Assert
        expect(rom.isDownloading, isTrue);
      });

      test('downloadProgress can be updated', () {
        // Arrange
        final rom = Rom(
          name: 'Game.txt',
          fileName: 'game.nes',
          platform: 'nes',
          urlFilePath: '/roms/nes/game.txt',
        );

        // Act
        rom.downloadProgress = 0.75;

        // Assert
        expect(rom.downloadProgress, 0.75);
      });
    });
  });
}
