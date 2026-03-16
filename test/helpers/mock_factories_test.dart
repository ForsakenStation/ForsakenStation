import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'mock_factories.dart';

void main() {
  group('MockFactories', () {
    group('createMockSharedPreferences', () {
      test('creates mock with string values', () {
        final prefs = MockFactories.createMockSharedPreferences(
          stringValues: {'key1': 'value1', 'key2': 'value2'},
        );

        expect(prefs.getString('key1'), equals('value1'));
        expect(prefs.getString('key2'), equals('value2'));
        expect(prefs.getString('nonexistent'), isNull);
      });

      test('creates mock with bool values', () {
        final prefs = MockFactories.createMockSharedPreferences(
          boolValues: {'enabled': true, 'disabled': false},
        );

        expect(prefs.getBool('enabled'), isTrue);
        expect(prefs.getBool('disabled'), isFalse);
        expect(prefs.getBool('nonexistent'), isNull);
      });

      test('creates mock with int values', () {
        final prefs = MockFactories.createMockSharedPreferences(
          intValues: {'count': 42, 'zero': 0},
        );

        expect(prefs.getInt('count'), equals(42));
        expect(prefs.getInt('zero'), equals(0));
        expect(prefs.getInt('nonexistent'), isNull);
      });

      test('creates mock with double values', () {
        final prefs = MockFactories.createMockSharedPreferences(
          doubleValues: {'pi': 3.14, 'zero': 0.0},
        );

        expect(prefs.getDouble('pi'), equals(3.14));
        expect(prefs.getDouble('zero'), equals(0.0));
        expect(prefs.getDouble('nonexistent'), isNull);
      });

      test('creates mock with string list values', () {
        final prefs = MockFactories.createMockSharedPreferences(
          stringListValues: {
            'list1': ['a', 'b', 'c'],
            'empty': [],
          },
        );

        expect(prefs.getStringList('list1'), equals(['a', 'b', 'c']));
        expect(prefs.getStringList('empty'), equals([]));
        expect(prefs.getStringList('nonexistent'), isNull);
      });
    });

    group('createMockHttpClient', () {
      test('creates mock with successful responses', () async {
        final client = MockFactories.createMockHttpClient(
          responses: {
            'https://example.com/data': '{"key": "value"}',
            'https://example.com/text': 'plain text',
          },
        );

        final response1 = await client.get(Uri.parse('https://example.com/data'));
        expect(response1.statusCode, equals(200));
        expect(response1.body, equals('{"key": "value"}'));

        final response2 = await client.get(Uri.parse('https://example.com/text'));
        expect(response2.statusCode, equals(200));
        expect(response2.body, equals('plain text'));
      });

      test('creates mock with error responses', () {
        final client = MockFactories.createMockHttpClient(
          errors: {
            'https://example.com/error': Exception('Network error'),
          },
        );

        expect(
          () => client.get(Uri.parse('https://example.com/error')),
          throwsA(isA<Exception>()),
        );
      });

      test('creates mock with custom status code', () async {
        final client = MockFactories.createMockHttpClient(
          responses: {'https://example.com/data': 'content'},
          defaultStatusCode: 201,
        );

        final response = await client.get(Uri.parse('https://example.com/data'));
        expect(response.statusCode, equals(201));
      });
    });

    group('createMockFile', () {
      test('creates mock file that exists', () {
        final file = MockFactories.createMockFile(
          '/path/to/file.txt',
          'file content',
        );

        expect(file.path, equals('/path/to/file.txt'));
        expect(file.existsSync(), isTrue);
        expect(file.readAsStringSync(), equals('file content'));
      });

      test('creates mock file that does not exist', () {
        final file = MockFactories.createMockFile(
          '/path/to/missing.txt',
          '',
          exists: false,
        );

        expect(file.path, equals('/path/to/missing.txt'));
        expect(file.existsSync(), isFalse);
        expect(
          () => file.readAsStringSync(),
          throwsA(isA<FileSystemException>()),
        );
      });

      test('creates mock file with async operations', () async {
        final file = MockFactories.createMockFile(
          '/path/to/file.txt',
          'async content',
        );

        expect(await file.exists(), isTrue);
        expect(await file.readAsString(), equals('async content'));
      });
    });

    group('createMockDirectory', () {
      test('creates mock directory that exists', () {
        final dir = MockFactories.createMockDirectory('/path/to/dir');

        expect(dir.path, equals('/path/to/dir'));
        expect(dir.existsSync(), isTrue);
      });

      test('creates mock directory with files', () {
        final dir = MockFactories.createMockDirectory(
          '/path/to/dir',
          files: ['file1.txt', 'file2.txt'],
        );

        final entities = dir.listSync();
        expect(entities.length, equals(2));
        expect(entities[0].path, equals('/path/to/dir/file1.txt'));
        expect(entities[1].path, equals('/path/to/dir/file2.txt'));
      });

      test('creates mock directory with subdirectories', () {
        final dir = MockFactories.createMockDirectory(
          '/path/to/dir',
          subdirectories: ['subdir1', 'subdir2'],
        );

        final entities = dir.listSync();
        expect(entities.length, equals(2));
        expect(entities[0].path, equals('/path/to/dir/subdir1'));
        expect(entities[1].path, equals('/path/to/dir/subdir2'));
      });

      test('creates mock directory with mixed content', () {
        final dir = MockFactories.createMockDirectory(
          '/path/to/dir',
          files: ['file.txt'],
          subdirectories: ['subdir'],
        );

        final entities = dir.listSync();
        expect(entities.length, equals(2));
      });
    });
  });
}
