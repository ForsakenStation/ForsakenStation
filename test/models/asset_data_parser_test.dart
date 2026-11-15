import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:forsaken/models/platform_info.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('assets/data/platforms.json', () {
    late List<dynamic> platforms;

    setUpAll(() {
      final file = File('assets/data/platforms.json');
      platforms = json.decode(file.readAsStringSync()) as List<dynamic>;
    });

    test('parses as a non-empty list', () {
      expect(platforms, isA<List>());
      expect(platforms, isNotEmpty);
    });

    test('all entries are non-empty strings', () {
      for (final p in platforms) {
        expect(p, isA<String>());
        expect((p as String).isNotEmpty, isTrue);
      }
    });

    test('platform IDs are lowercase', () {
      for (final p in platforms) {
        final id = p as String;
        expect(id, equals(id.toLowerCase()), reason: 'Platform "$id" is not lowercase');
      }
    });

    test('no duplicate platform IDs', () {
      final ids = platforms.cast<String>().toList();
      final unique = ids.toSet();
      expect(unique.length, equals(ids.length));
    });
  });

  group('assets/data/bios_requirements.json', () {
    late List<dynamic> biosRequirements;

    setUpAll(() {
      final file = File('assets/data/bios_requirements.json');
      biosRequirements = json.decode(file.readAsStringSync()) as List<dynamic>;
    });

    test('parses as a non-empty list', () {
      expect(biosRequirements, isA<List>());
      expect(biosRequirements, isNotEmpty);
    });

    test('each entry has required fields', () {
      for (final entry in biosRequirements) {
        final map = entry as Map<String, dynamic>;
        expect(map.containsKey('platform'), isTrue,
            reason: 'Missing "platform" in $map');
        expect(map.containsKey('files'), isTrue,
            reason: 'Missing "files" in $map');
      }
    });

    test('each BIOS entry has at least one file', () {
      for (final entry in biosRequirements) {
        final map = entry as Map<String, dynamic>;
        final files = map['files'] as List<dynamic>;
        expect(files, isNotEmpty,
            reason: 'Platform ${map['platform']} has no BIOS files');
      }
    });
  });

  group('assets/data/emulator_downloads.json', () {
    late List<dynamic> emulatorDownloads;

    setUpAll(() {
      final file = File('assets/data/emulator_downloads.json');
      emulatorDownloads =
          json.decode(file.readAsStringSync()) as List<dynamic>;
    });

    test('parses as a non-empty list', () {
      expect(emulatorDownloads, isA<List>());
      expect(emulatorDownloads, isNotEmpty);
    });

    test('each entry has a name field', () {
      for (final entry in emulatorDownloads) {
        final map = entry as Map<String, dynamic>;
        expect(map.containsKey('name'), isTrue,
            reason: 'Entry missing "name": $map');
      }
    });

    test('each entry has a downloads field', () {
      for (final entry in emulatorDownloads) {
        final map = entry as Map<String, dynamic>;
        expect(map.containsKey('downloads'), isTrue,
            reason: 'Entry "${map['name']}" missing "downloads"');
      }
    });
  });

  group('assets/data/platforms_info.json', () {
    late Map<String, dynamic> platformsInfo;

    setUpAll(() {
      final file = File('assets/data/platforms_info.json');
      platformsInfo =
          json.decode(file.readAsStringSync()) as Map<String, dynamic>;
    });

    test('parses as a non-empty map', () {
      expect(platformsInfo, isA<Map>());
      expect(platformsInfo, isNotEmpty);
    });

    test('each entry can be parsed as PlatformInfo', () {
      for (final entry in platformsInfo.entries) {
        expect(
          () => PlatformInfo.fromJson(entry.value as Map<String, dynamic>),
          returnsNormally,
          reason: 'Failed to parse PlatformInfo for "${entry.key}"',
        );
      }
    });

    test('all platform IDs are lowercase strings', () {
      for (final key in platformsInfo.keys) {
        expect(key, equals(key.toLowerCase()),
            reason: 'Key "$key" is not lowercase');
      }
    });
  });
}
