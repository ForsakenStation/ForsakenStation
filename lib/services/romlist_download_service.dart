import 'package:flutter/foundation.dart';
import 'debug_service.dart';

// Conditional import for IO-specific functionality
import 'romlist_download_service_io.dart'
    if (dart.library.js_interop) 'romlist_download_service_web_impl.dart'
    as platform_service;

/// Service for downloading and managing AndroidRoms JSONL database
class RomlistDownloadService {
  static final RomlistDownloadService _instance =
      RomlistDownloadService._internal();
  static RomlistDownloadService get instance => _instance;
  RomlistDownloadService._internal();

  final _debug = DebugService.instance;

  /// Get the path to the extracted JSONL files
  Future<String> getJsonlPath() async {
    if (kIsWeb) {
      // On web, we fetch directly from GitHub - return a marker path
      return 'web-github-romlists';
    }
    return platform_service.getJsonlPath();
  }

  /// Check if romlists are already downloaded
  Future<bool> isDownloaded() async {
    if (kIsWeb) {
      // On web, romlists are always "available" via HTTP
      return true;
    }
    return platform_service.isDownloaded();
  }

  /// Download and extract romlists from GitHub
  Future<bool> downloadAndExtract({
    void Function(double progress, int received, int total)? onProgress,
  }) async {
    if (kIsWeb) {
      // On web, no download needed - we fetch on demand
      _debug.info(
        'Web platform: romlists fetched on demand',
        tag: 'RomlistDownloadService',
      );
      return true;
    }
    return platform_service.downloadAndExtract(onProgress: onProgress);
  }

  /// Delete all downloaded romlists
  Future<bool> deleteRomlists() async {
    if (kIsWeb) {
      return true;
    }
    return platform_service.deleteRomlists();
  }

  /// Get download size information
  Future<Map<String, dynamic>> getDownloadInfo() async {
    if (kIsWeb) {
      return {
        'isDownloaded': true,
        'fileCount': 0,
        'totalSize': 0,
        'source': 'GitHub (fetched on demand)',
      };
    }
    return platform_service.getDownloadInfo();
  }

  // Legacy methods for backward compatibility
  Future<bool> isGameListsDownloaded() async => isDownloaded();
  Future<void> downloadGameLists({
    Function(double)? onProgress,
    Function(String)? onStatus,
  }) async {
    onStatus?.call('Downloading...');
    await downloadAndExtract(
      onProgress: (progress, received, total) {
        onProgress?.call(progress);
      },
    );
    onStatus?.call('Completed');
  }
}

typedef RomListDownloadService = RomlistDownloadService;
