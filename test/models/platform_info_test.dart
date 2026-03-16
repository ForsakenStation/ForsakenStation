import 'package:flutter_test/flutter_test.dart';

import 'package:forsaken/models/platform_info.dart';
import '../helpers/test_data_generators.dart';

void main() {
  group('PlatformInfo', () {
    group('fromJson', () {
      test('creates correct instance from valid JSON', () {
        final json = TestDataGenerators.generateValidPlatformInfoJson();
        final info = PlatformInfo.fromJson(json);

        expect(info.fullName, equals('Super Nintendo Entertainment System'));
        expect(info.manufacturer, equals('Nintendo'));
        expect(info.releaseYear, equals(1990));
        expect(info.generation, equals(4));
        expect(info.description, equals('A 16-bit home video game console.'));
        expect(info.cpu, equals('Ricoh 5A22 @ 3.58 MHz'));
        expect(info.resolution, equals('256x224'));
        expect(info.colors, equals('32768'));
      });

      test('handles null generation', () {
        final json = TestDataGenerators.generateValidPlatformInfoJson();
        json['generation'] = null;
        final info = PlatformInfo.fromJson(json);

        expect(info.generation, isNull);
      });

      test('throws when required field is missing', () {
        final json = TestDataGenerators.generateInvalidPlatformInfoJson();

        expect(() => PlatformInfo.fromJson(json), throwsA(anything));
      });
    });

    group('toJson', () {
      test('produces correct map', () {
        final info = TestDataGenerators.generatePlatformInfo();
        final json = info.toJson();

        expect(json['fullName'], equals(info.fullName));
        expect(json['manufacturer'], equals(info.manufacturer));
        expect(json['releaseYear'], equals(info.releaseYear));
        expect(json['generation'], equals(info.generation));
        expect(json['description'], equals(info.description));
        expect(json['cpu'], equals(info.cpu));
        expect(json['resolution'], equals(info.resolution));
        expect(json['colors'], equals(info.colors));
      });
    });

    group('JSON round-trip', () {
      test('fromJson(toJson()) produces equivalent object', () {
        final original = TestDataGenerators.generatePlatformInfo();
        final roundTripped = PlatformInfo.fromJson(original.toJson());

        expect(roundTripped.fullName, equals(original.fullName));
        expect(roundTripped.manufacturer, equals(original.manufacturer));
        expect(roundTripped.releaseYear, equals(original.releaseYear));
        expect(roundTripped.generation, equals(original.generation));
        expect(roundTripped.description, equals(original.description));
        expect(roundTripped.cpu, equals(original.cpu));
        expect(roundTripped.resolution, equals(original.resolution));
        expect(roundTripped.colors, equals(original.colors));
      });
    });

    // Feature: unit-testing-implementation, Property 2: Model Validation Rejects Invalid Input
    group('property tests', () {
      test('JSON round-trip preserves all fields across 100 generated instances',
          () {
        // Validates: Requirements 2.2
        for (var i = 0; i < 100; i++) {
          final original = PlatformInfo(
            fullName: 'Platform $i',
            manufacturer: 'Manufacturer $i',
            releaseYear: 1970 + i,
            generation: i % 10,
            description: 'Description for platform $i',
            cpu: 'CPU Model $i',
            resolution: '${256 + i}x${224 + i}',
            colors: '${16 + i}',
          );

          final roundTripped = PlatformInfo.fromJson(original.toJson());

          expect(roundTripped.fullName, equals(original.fullName));
          expect(roundTripped.manufacturer, equals(original.manufacturer));
          expect(roundTripped.releaseYear, equals(original.releaseYear));
          expect(roundTripped.generation, equals(original.generation));
          expect(roundTripped.description, equals(original.description));
          expect(roundTripped.cpu, equals(original.cpu));
          expect(roundTripped.resolution, equals(original.resolution));
          expect(roundTripped.colors, equals(original.colors));
        }
      });

      test(
          'generationString is consistent (idempotent) across all generation values',
          () {
        // Validates: Requirements 2.2
        for (var gen = 0; gen <= 20; gen++) {
          final json = TestDataGenerators.generateValidPlatformInfoJson();
          json['generation'] = gen;
          final info = PlatformInfo.fromJson(json);

          final first = info.generationString;
          final second = info.generationString;

          expect(first, equals(second));
        }
      });

      test('fromJson rejects missing required fields', () {
        // Validates: Requirements 2.2
        final requiredFields = [
          'fullName',
          'manufacturer',
          'releaseYear',
          'description',
          'cpu',
          'resolution',
          'colors',
        ];

        for (final field in requiredFields) {
          final json = TestDataGenerators.generateValidPlatformInfoJson();
          json.remove(field);

          expect(
            () => PlatformInfo.fromJson(json),
            throwsA(anything),
            reason: 'Expected fromJson to throw when "$field" is missing',
          );
        }
      });
    });

    group('generationString', () {
      test('returns "Computer / Arcade" for null generation', () {
        final json = TestDataGenerators.generateValidPlatformInfoJson();
        json['generation'] = null;
        final info = PlatformInfo.fromJson(json);

        expect(info.generationString, equals('Computer / Arcade'));
      });

      test('returns "Multiple Generations" for generation 0', () {
        final json = TestDataGenerators.generateValidPlatformInfoJson();
        json['generation'] = 0;
        final info = PlatformInfo.fromJson(json);

        expect(info.generationString, equals('Multiple Generations'));
      });

      test('returns "1st Generation" for generation 1', () {
        final json = TestDataGenerators.generateValidPlatformInfoJson();
        json['generation'] = 1;
        final info = PlatformInfo.fromJson(json);

        expect(info.generationString, equals('1st Generation'));
      });

      test('returns "2nd Generation" for generation 2', () {
        final json = TestDataGenerators.generateValidPlatformInfoJson();
        json['generation'] = 2;
        final info = PlatformInfo.fromJson(json);

        expect(info.generationString, equals('2nd Generation'));
      });

      test('returns "3rd Generation" for generation 3', () {
        final json = TestDataGenerators.generateValidPlatformInfoJson();
        json['generation'] = 3;
        final info = PlatformInfo.fromJson(json);

        expect(info.generationString, equals('3rd Generation'));
      });

      test('returns "4th Generation" for generation 4', () {
        final json = TestDataGenerators.generateValidPlatformInfoJson();
        json['generation'] = 4;
        final info = PlatformInfo.fromJson(json);

        expect(info.generationString, equals('4th Generation'));
      });

      test('returns "11th Generation" for generation 11 (special case)', () {
        final json = TestDataGenerators.generateValidPlatformInfoJson();
        json['generation'] = 11;
        final info = PlatformInfo.fromJson(json);

        expect(info.generationString, equals('11th Generation'));
      });

      test('returns "12th Generation" for generation 12', () {
        final json = TestDataGenerators.generateValidPlatformInfoJson();
        json['generation'] = 12;
        final info = PlatformInfo.fromJson(json);

        expect(info.generationString, equals('12th Generation'));
      });
    });
  });
}
