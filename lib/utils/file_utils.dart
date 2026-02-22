// Cross-platform file utilities.
//
// This file conditionally imports the IO or web implementation,
// providing a unified API for file operations used in models.
import 'file_utils_io.dart'
    if (dart.library.js_interop) 'file_utils_web.dart'
    as platform_file;

/// Check if a file exists asynchronously.
Future<bool> fileExists(String path) => platform_file.fileExists(path);

/// Check if a file exists synchronously.
/// On web, always returns false.
bool fileExistsSync(String path) => platform_file.fileExistsSync(path);

/// Read a file as a string asynchronously.
Future<String> readFileAsString(String path) =>
    platform_file.readFileAsString(path);

/// Check if a directory exists asynchronously.
Future<bool> directoryExists(String path) =>
    platform_file.directoryExists(path);

/// List files in a directory asynchronously. Returns paths.
Future<List<String>> listFiles(String path) => platform_file.listFiles(path);
