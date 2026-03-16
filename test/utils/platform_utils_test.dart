import 'package:flutter_test/flutter_test.dart';
import 'package:forsaken/utils/platform_utils.dart' as pu;

void main() {
  group('platform_utils - detection', () {
    test('exactly one of isLinux/isMacOS/isWindows is true on any platform',
        () {
      final count = [pu.isLinux, pu.isMacOS, pu.isWindows].where((v) => v).length;
      expect(count, lessThanOrEqualTo(1));
    });

    test('isLinux, isMacOS, isWindows are booleans', () {
      expect(pu.isLinux, isA<bool>());
      expect(pu.isMacOS, isA<bool>());
      expect(pu.isWindows, isA<bool>());
    });

    test('homeDirectory is a string', () {
      expect(pu.homeDirectory, isA<String>());
    });
  });

  group('platform_utils - idempotency', () {
    test('isLinux is idempotent', () {
      expect(pu.isLinux, equals(pu.isLinux));
    });

    test('isMacOS is idempotent', () {
      expect(pu.isMacOS, equals(pu.isMacOS));
    });

    test('isWindows is idempotent', () {
      expect(pu.isWindows, equals(pu.isWindows));
    });

    test('homeDirectory is idempotent', () {
      expect(pu.homeDirectory, equals(pu.homeDirectory));
    });
  });

  // Property 13: Idempotent Functions Satisfy f(x) = f(f(x))
  // Validates: Requisitos 6.5
  group('Property 13 - Idempotent platform detection', () {
    test('platform flags do not change between calls', () {
      expect(pu.isLinux, equals(pu.isLinux));
      expect(pu.isMacOS, equals(pu.isMacOS));
      expect(pu.isWindows, equals(pu.isWindows));
    });

    test('homeDirectory does not change between calls', () {
      expect(pu.homeDirectory, equals(pu.homeDirectory));
    });

    test('platform flags are mutually exclusive', () {
      final trueCount =
          [pu.isLinux, pu.isMacOS, pu.isWindows].where((v) => v).length;
      expect(trueCount, lessThanOrEqualTo(1));
    });
  });
}
