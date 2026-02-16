// Stub for web platform - RomlistDownloadService uses dart:io
class RomlistDownloadService {
  static final RomlistDownloadService _instance =
      RomlistDownloadService._internal();
  static RomlistDownloadService get instance => _instance;
  RomlistDownloadService._internal();

  Future<bool> isDownloaded() async => true;
  Future<String> getJsonlPath() async => '/web-romlists';
  Future<bool> downloadAndExtract({
    void Function(double progress, int received, int total)? onProgress,
  }) async => true;
}

// Legacy alias
typedef RomListDownloadService = RomlistDownloadService;
