/// Check if a file exists asynchronously (web stub).
/// Files don't exist on web.
Future<bool> fileExists(String path) async => false;

/// Check if a file exists synchronously (web stub).
/// Files don't exist on web.
bool fileExistsSync(String path) => false;

/// Read a file as a string asynchronously (web stub).
/// Throws on web since local files are not accessible.
Future<String> readFileAsString(String path) async {
  throw UnsupportedError('Cannot read local files on web');
}

/// Check if a directory exists asynchronously (web stub).
Future<bool> directoryExists(String path) async => false;

/// List files in a directory asynchronously (web stub).
Future<List<String>> listFiles(String path) async => [];
