import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:forsaken/utils/file_utils.dart';

import '../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('fileExists', () {
    test('returns false for non-existent path', () async {
      final result = await fileExists('/nonexistent/__test_file__.txt');
      expect(result, isFalse);
    });

    test('returns true for existing file', () async {
      final dir = await TestHelpers.createTempTestDirectory();
      try {
        final file = File('${dir.path}/test.txt');
        await file.writeAsString('hello');
        expect(await fileExists(file.path), isTrue);
      } finally {
        await TestHelpers.cleanupTempDirectory(dir);
      }
    });
  });

  group('fileExistsSync', () {
    test('returns false for non-existent path', () {
      expect(fileExistsSync('/nonexistent/__test_file__.txt'), isFalse);
    });

    test('returns true for existing file', () async {
      final dir = await TestHelpers.createTempTestDirectory();
      try {
        final file = File('${dir.path}/test.txt');
        await file.writeAsString('hello');
        expect(fileExistsSync(file.path), isTrue);
      } finally {
        await TestHelpers.cleanupTempDirectory(dir);
      }
    });
  });

  group('directoryExists', () {
    test('returns false for non-existent directory', () async {
      final result = await directoryExists('/nonexistent/__test_dir__');
      expect(result, isFalse);
    });

    test('returns true for existing directory', () async {
      final dir = await TestHelpers.createTempTestDirectory();
      try {
        expect(await directoryExists(dir.path), isTrue);
      } finally {
        await TestHelpers.cleanupTempDirectory(dir);
      }
    });
  });

  group('listFiles', () {
    test('returns empty list for non-existent directory', () async {
      final files = await listFiles('/nonexistent/__test_dir__');
      expect(files, isEmpty);
    });

    test('returns file paths for existing directory', () async {
      final dir = await TestHelpers.createTempTestDirectory();
      try {
        await File('${dir.path}/a.txt').writeAsString('a');
        await File('${dir.path}/b.txt').writeAsString('b');
        final files = await listFiles(dir.path);
        expect(files.length, equals(2));
      } finally {
        await TestHelpers.cleanupTempDirectory(dir);
      }
    });
  });

  group('readFileAsString', () {
    test('reads file content correctly', () async {
      final dir = await TestHelpers.createTempTestDirectory();
      try {
        final file = File('${dir.path}/content.txt');
        await file.writeAsString('hello world');
        final content = await readFileAsString(file.path);
        expect(content, equals('hello world'));
      } finally {
        await TestHelpers.cleanupTempDirectory(dir);
      }
    });
  });

  // Property 12: File Path Utilities Handle Cross-Platform Paths
  // Validates: Requisitos 6.4
  group('Property 12 - Cross-platform path handling', () {
    test('fileExists is consistent with fileExistsSync', () async {
      final dir = await TestHelpers.createTempTestDirectory();
      try {
        final file = File('${dir.path}/prop_test.txt');
        await file.writeAsString('data');

        final async = await fileExists(file.path);
        final sync = fileExistsSync(file.path);
        expect(async, equals(sync));
      } finally {
        await TestHelpers.cleanupTempDirectory(dir);
      }
    });

    test('fileExists returns false for empty string path', () async {
      final result = await fileExists('');
      expect(result, isFalse);
    });

    test('directoryExists returns false for empty string path', () async {
      final result = await directoryExists('');
      expect(result, isFalse);
    });
  });
}
