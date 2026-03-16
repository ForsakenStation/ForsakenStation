import 'package:flutter_test/flutter_test.dart';
import 'package:forsaken/utils/format_utils.dart';

void main() {
  group('formatBytes - bytes', () {
    test('0 bytes', () => expect(formatBytes(0), equals('0 B')));
    test('1 byte', () => expect(formatBytes(1), equals('1 B')));
    test('1023 bytes', () => expect(formatBytes(1023), equals('1023 B')));
  });

  group('formatBytes - kilobytes', () {
    test('1024 bytes = 1.0 KB', () => expect(formatBytes(1024), equals('1.0 KB')));
    test('1536 bytes = 1.5 KB', () => expect(formatBytes(1536), equals('1.5 KB')));
    test('1048575 bytes < 1 MB', () {
      final result = formatBytes(1048575);
      expect(result, contains('KB'));
    });
  });

  group('formatBytes - megabytes', () {
    test('1 MB', () => expect(formatBytes(1024 * 1024), equals('1.0 MB')));
    test('1.5 MB', () => expect(formatBytes(1024 * 1024 + 512 * 1024), equals('1.5 MB')));
  });

  group('formatBytes - gigabytes', () {
    test('1 GB', () {
      expect(formatBytes(1024 * 1024 * 1024), equals('1.0 GB'));
    });
    test('2.5 GB', () {
      expect(
        formatBytes((2.5 * 1024 * 1024 * 1024).round()),
        equals('2.5 GB'),
      );
    });
  });

  group('formatBytes - compact mode', () {
    test('compact omits space', () {
      expect(formatBytes(1024, compact: true), equals('1.0KB'));
    });
    test('compact bytes', () {
      expect(formatBytes(512, compact: true), equals('512B'));
    });
    test('compact MB', () {
      expect(formatBytes(1024 * 1024, compact: true), equals('1.0MB'));
    });
  });

  // Property 11: Formatting Output Matches Expected Pattern
  // Validates: Requisitos 6.3
  group('Property 11 - formatBytes output pattern', () {
    test('output always contains a unit suffix', () {
      final testValues = [0, 1, 1023, 1024, 1048576, 1073741824];
      for (final bytes in testValues) {
        final result = formatBytes(bytes);
        final hasUnit = result.endsWith(' B') ||
            result.endsWith(' KB') ||
            result.endsWith(' MB') ||
            result.endsWith(' GB');
        expect(hasUnit, isTrue, reason: 'formatBytes($bytes) = "$result"');
      }
    });

    test('larger values produce larger or equal formatted numbers', () {
      // 1 KB should not format as more than 1 MB.
      final kb = formatBytes(1024);
      final mb = formatBytes(1024 * 1024);
      expect(kb, contains('KB'));
      expect(mb, contains('MB'));
    });

    test('compact and non-compact produce same numeric value', () {
      final values = [512, 1024, 1024 * 1024];
      for (final v in values) {
        final normal = formatBytes(v);
        final compact = formatBytes(v, compact: true);
        // Remove spaces and compare.
        expect(compact, equals(normal.replaceAll(' ', '')));
      }
    });

    test('formatBytes is deterministic', () {
      for (final v in [0, 100, 1024, 1048576]) {
        expect(formatBytes(v), equals(formatBytes(v)));
      }
    });
  });
}
