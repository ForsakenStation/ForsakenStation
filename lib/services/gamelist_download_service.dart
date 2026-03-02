import 'package:flutter/foundation.dart';
import 'debug_service.dart';

// Conditional import for IO-specific functionality
import 'gamelist_download_service_io.dart'
    if (dart.library.js_interop) 'gamelist_download_service_web_impl.dart'
    as platform_service;

/// Service for downloading and managing gamelist.xml files
/// from the ForsakenStation/gamelists GitHub repository.
///
/// Gamelists contain game metadata (names, descriptions, ratings, etc.)
/// and are organized by platform: `{platform}/gamelist.xml`.
class GamelistDownloadService {
  static final GamelistDownloadService _instance =
      GamelistDownloadService._internal();
  static GamelistDownloadService get instance => _instance;
  GamelistDownloadService._internal();

  final _debug = DebugService.instance;

  /// Check if gamelists are already downloaded
  Future<bool> isDownloaded() async {
    if (kIsWeb) {
      return true;
    }
    return platform_service.isGamelistsDownloaded();
  }

  /// Download and extract gamelists from GitHub
  Future<bool> downloadAndExtract({
    void Function(double progress, int received, int total)? onProgress,
  }) async {
    if (kIsWeb) {
      _debug.info(
        'Web platform: gamelists not supported',
        tag: 'GamelistDownloadService',
      );
      return true;
    }
    return platform_service.downloadAndExtractGamelists(onProgress: onProgress);
  }

  /// Delete all downloaded gamelists
  Future<bool> deleteGamelists() async {
    if (kIsWeb) {
      return true;
    }
    return platform_service.deleteGamelists();
  }

  /// Get download info (file count, size)
  Future<Map<String, dynamic>> getDownloadInfo() async {
    if (kIsWeb) {
      return {'isDownloaded': false, 'fileCount': 0, 'totalSize': 0};
    }
    return platform_service.getGamelistDownloadInfo();
  }
}
