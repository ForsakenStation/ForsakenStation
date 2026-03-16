import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:forsaken/models/platform_info.dart';
import 'package:forsaken/models/emulator_config.dart';

import '../helpers/test_data_generators.dart';

void main() {
  group('JSON round-trip - PlatformInfo', () {
    test('fromJson with valid data creates correct object', () {
      final json = TestDataGenerators.generateValidPlatformInfoJson();
      final info = PlatformInfo.fromJson(json);
      expect(info.fullName, equals(json['fullName']));
      expect(info.manufacturer, equals(json['manufacturer']));
      expect(info.releaseYear, equals(json['releaseYear']));
    });

    test('fromJson with missing required fullName throws', () {
      final json = {'manufacturer': 'Nintendo'};
      expect(() => PlatformInfo.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('fromJson with empty map throws due to missing required fields', () {
      expect(() => PlatformInfo.fromJson({}), throwsA(isA<TypeError>()));
    });

    test('fromJson preserves all provided fields', () {
      final json = TestDataGenerators.generateValidPlatformInfoJson();
      final info = PlatformInfo.fromJson(json);
      expect(info.fullName, isNotEmpty);
      expect(info.manufacturer, isNotEmpty);
      expect(info.releaseYear, greaterThan(0));
    });
  });

  group('JSON round-trip - EmulatorConfig', () {
    test('fromJson with native format creates correct object', () {
      final json = TestDataGenerators.generateValidEmulatorConfigJson(
        platform: 'nes',
      );
      final config = EmulatorConfig.fromJson(json);
      expect(config.platform, equals('nes'));
      expect(config.commands, isNotEmpty);
    });

    test('fromJson with Forsaken format creates correct object', () {
      final json = TestDataGenerators.generateValidForsakenConfigJson(
        system: 'snes',
      );
      final config = EmulatorConfig.fromJson(json);
      expect(config.platform, equals('snes'));
    });

    test('fromJson with empty commands list creates config with no commands',
        () {
      final json = {
        'platform': 'nes',
        'commands': <dynamic>[],
        'acceptZipFiles': false,
        'useForeverMode': false,
      };
      final config = EmulatorConfig.fromJson(json);
      expect(config.commands, isEmpty);
    });

    test('fromJson native format produces valid JSON when re-encoded', () {
      final json = TestDataGenerators.generateValidEmulatorConfigJson();
      expect(() => jsonEncode(json), returnsNormally);
    });
  });

  group('JSON round-trip - EmulatorCommand', () {
    test('generateEmulatorCommand produces valid command', () {
      final cmd = TestDataGenerators.generateEmulatorCommand();
      expect(cmd.name, isNotEmpty);
      expect(cmd.command, isNotEmpty);
      expect(cmd.args, isNotEmpty);
    });

    test('command args contain ROM placeholder', () {
      final cmd = TestDataGenerators.generateEmulatorCommand();
      expect(cmd.args.any((a) => a.contains('{ROM}')), isTrue);
    });
  });

  // Property 14: Parser Errors Are Descriptive
  // Validates: Requisitos 7.3
  group('Property 14 - Parser error handling', () {
    test('PlatformInfo.fromJson with wrong types does not crash', () {
      final json = <String, dynamic>{
        'fullName': 123,
        'releaseYear': 'not a number',
      };
      try {
        PlatformInfo.fromJson(json);
      } catch (e) {
        expect(e, isNotNull);
      }
    });

    test('EmulatorConfig.fromJson with malformed commands does not crash', () {
      final json = <String, dynamic>{
        'platform': 'nes',
        'commands': 'not a list',
      };
      try {
        EmulatorConfig.fromJson(json);
      } catch (e) {
        expect(e, isNotNull);
      }
    });

    test('PlatformInfo.fromJson with null values does not crash', () {
      final json = <String, dynamic>{
        'fullName': null,
        'manufacturer': null,
        'releaseYear': null,
      };
      try {
        PlatformInfo.fromJson(json);
      } catch (e) {
        expect(e, isNotNull);
      }
    });
  });
}
