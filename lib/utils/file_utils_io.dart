import 'dart:io';

/// Check if a file exists asynchronously (IO implementation).
Future<bool> fileExists(String path) => File(path).exists();

/// Check if a file exists synchronously (IO implementation).
bool fileExistsSync(String path) => File(path).existsSync();

/// Read a file as a string asynchronously (IO implementation).
Future<String> readFileAsString(String path) => File(path).readAsString();

/// Check if a directory exists asynchronously (IO implementation).
Future<bool> directoryExists(String path) => Directory(path).exists();

/// List files in a directory asynchronously (IO implementation).
Future<List<String>> listFiles(String path) async {
  final dir = Directory(path);
  if (!await dir.exists()) return [];

  final files = <String>[];
  await for (final entity in dir.list()) {
    if (entity is File) {
      files.add(entity.path);
    }
  }
  return files;
}
