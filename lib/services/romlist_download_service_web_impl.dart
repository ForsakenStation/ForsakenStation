// Web implementation stub for RomlistDownloadService
// On web, romlists are fetched directly from GitHub on demand

Future<String> getJsonlPath() async {
  return 'web-github-romlists';
}

Future<bool> isDownloaded() async {
  return true;
}

Future<bool> downloadAndExtract({
  void Function(double progress, int received, int total)? onProgress,
}) async {
  return true;
}

Future<bool> deleteRomlists() async {
  return true;
}

Future<Map<String, dynamic>> getDownloadInfo() async {
  return {
    'isDownloaded': true,
    'fileCount': 0,
    'totalSize': 0,
    'source': 'GitHub (fetched on demand)',
  };
}
