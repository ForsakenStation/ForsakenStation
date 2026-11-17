import 'package:flutter_test/flutter_test.dart';
import 'package:forsaken/utils/security_validator.dart';

void main() {
  group('SecurityValidator.isValidDownloadUrl', () {
    test('accepts valid http and https URLs', () {
      expect(
        SecurityValidator.isValidDownloadUrl(
          'https://archive.org/download/rom/game.zip',
        ),
        isTrue,
      );
      expect(
        SecurityValidator.isValidDownloadUrl(
          'http://192.168.1.10:8080/roms/game.iso',
        ),
        isTrue,
      );
    });

    test('rejects null, empty, and dangerous schemes', () {
      expect(SecurityValidator.isValidDownloadUrl(null), isFalse);
      expect(SecurityValidator.isValidDownloadUrl('   '), isFalse);
      expect(
        SecurityValidator.isValidDownloadUrl('file:///etc/passwd'),
        isFalse,
      );
      expect(
        SecurityValidator.isValidDownloadUrl('javascript:alert(1)'),
        isFalse,
      );
      expect(
        SecurityValidator.isValidDownloadUrl('https://user:pass@example.com/a'),
        isFalse,
      );
    });
  });

  group('SecurityValidator.isSafePathWithinBase', () {
    test('allows paths inside base directory', () {
      expect(
        SecurityValidator.isSafePathWithinBase(
          '/tmp/roms/snes',
          '/tmp/roms/snes/mario.sfc',
        ),
        isTrue,
      );
    });

    test('blocks directory traversal and null bytes', () {
      expect(
        SecurityValidator.isSafePathWithinBase(
          '/tmp/roms/snes',
          '/tmp/roms/snes/../../etc/passwd',
        ),
        isFalse,
      );
      expect(
        SecurityValidator.isSafePathWithinBase(
          '/tmp/roms/snes',
          '/tmp/roms/snes/game\x00.sfc',
        ),
        isFalse,
      );
    });
  });

  group('SecurityValidator.sanitizeFileName', () {
    test('strips traversal segments and separators', () {
      expect(
        SecurityValidator.sanitizeFileName('../../evil/game.zip'),
        'game.zip',
      );
      expect(SecurityValidator.sanitizeFileName('..\\..\\game.iso'), 'game.iso');
      expect(SecurityValidator.sanitizeFileName('..'), 'unnamed');
    });
  });
}
