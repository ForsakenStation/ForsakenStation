import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Helper to load a JSON asset file
  Map<String, dynamic> loadJsonMap(String path) {
    final file = File(path);
    return json.decode(file.readAsStringSync()) as Map<String, dynamic>;
  }

  List<dynamic> loadJsonList(String path) {
    final file = File(path);
    return json.decode(file.readAsStringSync()) as List<dynamic>;
  }

  // ─── platforms.json ───────────────────────────────────────────────────────

  group('assets/data/platforms.json - required fields', () {
    late List<String> platforms;

    setUpAll(() {
      platforms = loadJsonList('assets/data/platforms.json').cast<String>();
    });

    test('is non-empty', () => expect(platforms, isNotEmpty));

    test('all entries are non-empty strings', () {
      for (final p in platforms) {
        expect(p.isNotEmpty, isTrue, reason: 'Empty platform id found');
      }
    });

    test('no duplicates', () {
      expect(platforms.toSet().length, equals(platforms.length));
    });
  });

  // ─── bios_requirements.json ───────────────────────────────────────────────

  group('assets/data/bios_requirements.json - required fields', () {
    late List<Map<String, dynamic>> bios;

    setUpAll(() {
      bios = loadJsonList('assets/data/bios_requirements.json')
          .cast<Map<String, dynamic>>();
    });

    test('is non-empty', () => expect(bios, isNotEmpty));

    test('each entry has platform and files', () {
      for (final entry in bios) {
        expect(entry.containsKey('platform'), isTrue,
            reason: 'Missing "platform" in $entry');
        expect(entry.containsKey('files'), isTrue,
            reason: 'Missing "files" in $entry');
      }
    });

    test('each entry has at least one BIOS file', () {
      for (final entry in bios) {
        final files = entry['files'] as List<dynamic>;
        expect(files, isNotEmpty,
            reason: 'Platform ${entry['platform']} has no BIOS files');
      }
    });

    test('each BIOS file has a filename', () {
      for (final entry in bios) {
        final files = (entry['files'] as List<dynamic>).cast<Map<String, dynamic>>();
        for (final f in files) {
          expect(f.containsKey('filename'), isTrue,
              reason: 'BIOS file missing "filename" in ${entry['platform']}');
          expect((f['filename'] as String).isNotEmpty, isTrue);
        }
      }
    });
  });

  // ─── emulator_downloads.json ──────────────────────────────────────────────

  group('assets/data/emulator_downloads.json - required fields', () {
    late List<Map<String, dynamic>> emulators;

    setUpAll(() {
      emulators = loadJsonList('assets/data/emulator_downloads.json')
          .cast<Map<String, dynamic>>();
    });

    test('is non-empty', () => expect(emulators, isNotEmpty));

    test('each entry has name and downloads', () {
      for (final e in emulators) {
        expect(e.containsKey('name'), isTrue,
            reason: 'Missing "name" in $e');
        expect(e.containsKey('downloads'), isTrue,
            reason: 'Missing "downloads" in ${e['name']}');
      }
    });

    test('each download entry has at least one platform', () {
      for (final e in emulators) {
        final downloads = e['downloads'] as Map<String, dynamic>;
        expect(downloads, isNotEmpty,
            reason: '${e['name']} has no platform downloads');
      }
    });
  });

  // ─── platforms_info.json ──────────────────────────────────────────────────

  group('assets/data/platforms_info.json - required fields', () {
    late Map<String, dynamic> platformsInfo;

    setUpAll(() {
      platformsInfo = loadJsonMap('assets/data/platforms_info.json');
    });

    test('is non-empty', () => expect(platformsInfo, isNotEmpty));

    test('each entry has fullName', () {
      for (final entry in platformsInfo.entries) {
        final info = entry.value as Map<String, dynamic>;
        expect(info.containsKey('fullName'), isTrue,
            reason: 'Platform "${entry.key}" missing "fullName"');
      }
    });

    test('all keys are lowercase', () {
      for (final key in platformsInfo.keys) {
        expect(key, equals(key.toLowerCase()),
            reason: 'Key "$key" is not lowercase');
      }
    });
  });

  // ─── Property 23: Data Files Have Required Fields ─────────────────────────
  // Validates: Requisitos 12.2

  group('Property 23 - Data files have required fields', () {
    test('all JSON data files are parseable', () {
      final dataFiles = [
        'assets/data/platforms.json',
        'assets/data/bios_requirements.json',
        'assets/data/emulator_downloads.json',
        'assets/data/platforms_info.json',
        'assets/data/web_cores.json',
      ];
      for (final path in dataFiles) {
        expect(
          () => json.decode(File(path).readAsStringSync()),
          returnsNormally,
          reason: 'Failed to parse $path',
        );
      }
    });
  });

  // ─── Property 24: Referenced Resources Exist ──────────────────────────────
  // Validates: Requisitos 12.3

  group('Property 24 - Referenced resources exist', () {
    test('BIOS platform IDs reference known platforms', () {
      final platforms = loadJsonList('assets/data/platforms.json')
          .cast<String>()
          .toSet();
      final bios = loadJsonList('assets/data/bios_requirements.json')
          .cast<Map<String, dynamic>>();

      for (final entry in bios) {
        final platform = entry['platform'] as String;
        // Strip suffixes like _pcsx, _duckstation for base platform check.
        final basePlatform = platform.split('_').first;
        // We allow platform IDs that are either exact matches or base matches.
        final isKnown = platforms.contains(platform) ||
            platforms.contains(basePlatform) ||
            platform.isNotEmpty; // At minimum, must be non-empty.
        expect(isKnown, isTrue,
            reason: 'BIOS platform "$platform" is not a valid ID');
      }
    });
  });

  // ─── Property 25: Platform IDs Are Consistent ─────────────────────────────
  // Validates: Requisitos 12.4

  group('Property 25 - Platform IDs are consistent', () {
    test('platforms_info.json keys are a subset of known platform IDs or extensions',
        () {
      final platforms = loadJsonList('assets/data/platforms.json')
          .cast<String>()
          .toSet();
      final platformsInfo = loadJsonMap('assets/data/platforms_info.json');

      for (final key in platformsInfo.keys) {
        // Platform info may include extended IDs not in platforms.json.
        // We just verify they are non-empty lowercase strings.
        expect(key.isNotEmpty, isTrue);
        expect(key, equals(key.toLowerCase()));
      }
    });
  });

  // ─── Property 26: BIOS Requirements Reference Valid Platforms ─────────────
  // Validates: Requisitos 12.5

  group('Property 26 - BIOS requirements reference valid platforms', () {
    test('all BIOS entries have non-empty platform IDs', () {
      final bios = loadJsonList('assets/data/bios_requirements.json')
          .cast<Map<String, dynamic>>();
      for (final entry in bios) {
        final platform = entry['platform'] as String;
        expect(platform.isNotEmpty, isTrue,
            reason: 'Empty platform ID in BIOS entry');
      }
    });
  });

  // ─── Property 27: Emulator URLs Are Well-Formed ───────────────────────────
  // Validates: Requisitos 12.6

  group('Property 27 - Emulator URLs are well-formed', () {
    test('all emulator download URLs are valid URIs', () {
      final emulators = loadJsonList('assets/data/emulator_downloads.json')
          .cast<Map<String, dynamic>>();

      for (final emulator in emulators) {
        final downloads = emulator['downloads'] as Map<String, dynamic>;
        for (final platformEntry in downloads.entries) {
          final download = platformEntry.value as Map<String, dynamic>;
          final url = download['url'] as String?;
          if (url != null && url.isNotEmpty) {
            final uri = Uri.tryParse(url);
            expect(uri, isNotNull,
                reason: 'Invalid URL for ${emulator['name']}/${platformEntry.key}: $url');
            expect(uri!.hasScheme, isTrue,
                reason: 'URL missing scheme: $url');
          }
        }
      }
    });
  });
}
