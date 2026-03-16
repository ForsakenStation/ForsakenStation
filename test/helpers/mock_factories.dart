import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import the generated mocks (will be created by build_runner)
import 'mock_factories.mocks.dart';

// Generate mocks for these classes
@GenerateMocks([
  SharedPreferences,
  HttpClient,
  File,
  Directory,
  http.Client,
])
void main() {}

/// Factory class for creating configured mock objects for testing.
/// 
/// This class provides convenient methods to create mocks with default
/// configurations, reducing boilerplate in test files.
class MockFactories {
  /// Creates a mock SharedPreferences with optional predefined values.
  /// 
  /// Example:
  /// ```dart
  /// final prefs = MockFactories.createMockSharedPreferences(
  ///   stringValues: {'key': 'value'},
  ///   boolValues: {'enabled': true},
  /// );
  /// ```
  static MockSharedPreferences createMockSharedPreferences({
    Map<String, String>? stringValues,
    Map<String, bool>? boolValues,
    Map<String, int>? intValues,
    Map<String, double>? doubleValues,
    Map<String, List<String>>? stringListValues,
  }) {
    final mock = MockSharedPreferences();
    
    // Default behavior for unset keys (must be set first so specific stubs take precedence)
    when(mock.getString(any)).thenReturn(null);
    when(mock.getBool(any)).thenReturn(null);
    when(mock.getInt(any)).thenReturn(null);
    when(mock.getDouble(any)).thenReturn(null);
    when(mock.getStringList(any)).thenReturn(null);

    // Configure string values (set after defaults so they take precedence)
    if (stringValues != null) {
      stringValues.forEach((key, value) {
        when(mock.getString(key)).thenReturn(value);
      });
    }
    
    // Configure bool values
    if (boolValues != null) {
      boolValues.forEach((key, value) {
        when(mock.getBool(key)).thenReturn(value);
      });
    }
    
    // Configure int values
    if (intValues != null) {
      intValues.forEach((key, value) {
        when(mock.getInt(key)).thenReturn(value);
      });
    }
    
    // Configure double values
    if (doubleValues != null) {
      doubleValues.forEach((key, value) {
        when(mock.getDouble(key)).thenReturn(value);
      });
    }
    
    // Configure string list values
    if (stringListValues != null) {
      stringListValues.forEach((key, value) {
        when(mock.getStringList(key)).thenReturn(value);
      });
    }
    
    // Configure setters to return success by default
    when(mock.setString(any, any)).thenAnswer((_) async => true);
    when(mock.setBool(any, any)).thenAnswer((_) async => true);
    when(mock.setInt(any, any)).thenAnswer((_) async => true);
    when(mock.setDouble(any, any)).thenAnswer((_) async => true);
    when(mock.setStringList(any, any)).thenAnswer((_) async => true);
    when(mock.remove(any)).thenAnswer((_) async => true);
    when(mock.clear()).thenAnswer((_) async => true);
    
    return mock;
  }

  /// Creates a mock http.Client with configurable responses and errors.
  /// 
  /// Example:
  /// ```dart
  /// final client = MockFactories.createMockHttpClient(
  ///   responses: {
  ///     'https://example.com/data.json': '{"key": "value"}',
  ///   },
  ///   errors: {
  ///     'https://example.com/error': Exception('Network error'),
  ///   },
  /// );
  /// ```
  static MockClient createMockHttpClient({
    Map<String, String>? responses,
    Map<String, Exception>? errors,
    int defaultStatusCode = 200,
  }) {
    final mock = MockClient();
    
    // Configure successful responses
    if (responses != null) {
      responses.forEach((url, body) {
        when(mock.get(Uri.parse(url))).thenAnswer(
          (_) async => http.Response(body, defaultStatusCode),
        );
      });
    }
    
    // Configure error responses
    if (errors != null) {
      errors.forEach((url, error) {
        when(mock.get(Uri.parse(url))).thenThrow(error);
      });
    }
    
    return mock;
  }

  /// Creates a mock File with specified path and content.
  /// 
  /// Example:
  /// ```dart
  /// final file = MockFactories.createMockFile(
  ///   '/path/to/file.txt',
  ///   'file content',
  /// );
  /// ```
  static MockFile createMockFile(
    String path,
    String content, {
    bool exists = true,
  }) {
    final mock = MockFile();
    
    when(mock.path).thenReturn(path);
    when(mock.existsSync()).thenReturn(exists);
    when(mock.exists()).thenAnswer((_) async => exists);
    
    if (exists) {
      when(mock.readAsStringSync()).thenReturn(content);
      when(mock.readAsString()).thenAnswer((_) async => content);
      when(mock.readAsBytesSync()).thenReturn(Uint8List.fromList(content.codeUnits));
      when(mock.readAsBytes()).thenAnswer((_) async => Uint8List.fromList(content.codeUnits));
    } else {
      when(mock.readAsStringSync()).thenThrow(
        FileSystemException('File not found', path),
      );
      when(mock.readAsString()).thenThrow(
        FileSystemException('File not found', path),
      );
    }
    
    // Configure write operations
    when(mock.writeAsStringSync(any)).thenReturn(null);
    when(mock.writeAsString(any)).thenAnswer((_) async => mock);
    when(mock.writeAsBytesSync(any)).thenReturn(null);
    when(mock.writeAsBytes(any)).thenAnswer((_) async => mock);
    when(mock.deleteSync()).thenReturn(null);
    when(mock.delete()).thenAnswer((_) async => mock);
    
    return mock;
  }

  /// Creates a mock Directory with specified path and optional child files.
  /// 
  /// Example:
  /// ```dart
  /// final dir = MockFactories.createMockDirectory(
  ///   '/path/to/dir',
  ///   files: ['file1.txt', 'file2.txt'],
  /// );
  /// ```
  static MockDirectory createMockDirectory(
    String path, {
    bool exists = true,
    List<String>? files,
    List<String>? subdirectories,
  }) {
    final mock = MockDirectory();
    
    when(mock.path).thenReturn(path);
    when(mock.existsSync()).thenReturn(exists);
    when(mock.exists()).thenAnswer((_) async => exists);
    
    // Configure list operations
    final entities = <FileSystemEntity>[];
    
    if (files != null) {
      for (final fileName in files) {
        final filePath = '$path/$fileName';
        final mockFile = createMockFile(filePath, '', exists: true);
        entities.add(mockFile);
      }
    }
    
    if (subdirectories != null) {
      for (final dirName in subdirectories) {
        final dirPath = '$path/$dirName';
        final mockDir = createMockDirectory(dirPath, exists: true);
        entities.add(mockDir);
      }
    }
    
    when(mock.listSync()).thenReturn(entities);
    when(mock.list()).thenAnswer((_) => Stream.fromIterable(entities));
    
    // Configure create/delete operations
    when(mock.createSync(recursive: anyNamed('recursive'))).thenReturn(null);
    when(mock.create(recursive: anyNamed('recursive')))
        .thenAnswer((_) async => mock);
    when(mock.deleteSync(recursive: anyNamed('recursive'))).thenReturn(null);
    when(mock.delete(recursive: anyNamed('recursive')))
        .thenAnswer((_) async => mock);
    
    return mock;
  }

  /// Creates a mock HttpClient (dart:io) with configurable responses.
  /// 
  /// Note: For most HTTP testing, prefer using MockClient (http package).
  /// This is for testing code that uses dart:io HttpClient directly.
  /// 
  /// Example:
  /// ```dart
  /// final httpClient = MockFactories.createMockDartHttpClient();
  /// ```
  static MockHttpClient createMockDartHttpClient() {
    final mock = MockHttpClient();
    
    // Default configuration - can be customized in tests
    when(mock.close()).thenReturn(null);
    
    return mock;
  }
}
