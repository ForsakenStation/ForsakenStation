import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../utils/platform_utils.dart' as platform_utils;

/// Platform-specific download information for an emulator
class EmulatorDownloadInfo {
  final String name;
  final String displayName;
  final String description;
  final Map<String, PlatformDownload> downloads;
  final bool requiresExtraction;
  final String? extractedFileName;
  final String? finalFileName;
  final Map<String, List<String>>? postDownloadCommands;
  final bool isRetroArchCore;

  EmulatorDownloadInfo({
    required this.name,
    required this.displayName,
    required this.description,
    required this.downloads,
    this.requiresExtraction = false,
    this.extractedFileName,
    this.finalFileName,
    this.postDownloadCommands,
    this.isRetroArchCore = false,
  });

  factory EmulatorDownloadInfo.fromJson(Map<String, dynamic> json) {
    final downloads = <String, PlatformDownload>{};
    if (json['downloads'] != null) {
      final Map<String, dynamic> dMap = json['downloads'];
      dMap.forEach((k, v) {
        downloads[k] = PlatformDownload.fromJson(v as Map<String, dynamic>);
      });
    }

    final postCommands = <String, List<String>>{};
    if (json['postDownloadCommands'] != null) {
      final Map<String, dynamic> cMap = json['postDownloadCommands'];
      cMap.forEach((k, v) {
        postCommands[k] = List<String>.from(v as List);
      });
    }

    return EmulatorDownloadInfo(
      name: json['name'] as String,
      displayName: json['displayName'] as String,
      description: json['description'] as String,
      downloads: downloads,
      requiresExtraction: json['requiresExtraction'] as bool? ?? false,
      extractedFileName: json['extractedFileName'] as String?,
      finalFileName: json['finalFileName'] as String?,
      postDownloadCommands: postCommands.isEmpty ? null : postCommands,
      isRetroArchCore: json['isRetroArchCore'] as bool? ?? false,
    );
  }

  /// Get download info for current platform
  PlatformDownload? getDownloadForCurrentPlatform() {
    if (kIsWeb) {
      // Web platform doesn't support emulator downloads
      return null;
    }

    if (platform_utils.isLinux) {
      return downloads['linux'];
    } else if (platform_utils.isMacOS) {
      return downloads['macos'];
    } else if (platform_utils.isWindows) {
      return downloads['windows'];
    }
    return null;
  }

  /// Get post-download commands for current platform
  List<String>? getPostDownloadCommandsForCurrentPlatform() {
    if (postDownloadCommands == null) return null;

    if (kIsWeb) {
      // Web platform doesn't support post-download commands
      return null;
    }

    if (platform_utils.isLinux) {
      return postDownloadCommands!['linux'];
    } else if (platform_utils.isMacOS) {
      return postDownloadCommands!['macos'];
    } else if (platform_utils.isWindows) {
      return postDownloadCommands!['windows'];
    }
    return null;
  }

  /// Check if emulator is available for current platform
  bool isAvailableForCurrentPlatform() {
    return getDownloadForCurrentPlatform() != null;
  }
}

/// Platform-specific download details
class PlatformDownload {
  final String url;
  final String fileName;
  final String? sha256;
  final int? estimatedSizeMB;

  PlatformDownload({
    required this.url,
    required this.fileName,
    this.sha256,
    this.estimatedSizeMB,
  });

  factory PlatformDownload.fromJson(Map<String, dynamic> json) {
    return PlatformDownload(
      url: json['url'] as String,
      fileName: json['fileName'] as String,
      sha256: json['sha256'] as String?,
      estimatedSizeMB: json['estimatedSizeMB'] as int?,
    );
  }
}

/// List of all available emulators for download
class EmulatorCatalog {
  static List<EmulatorDownloadInfo>? _cachedEmulators;

  /// Load all emulators from the assets JSON file
  static Future<List<EmulatorDownloadInfo>> loadAll() async {
    if (_cachedEmulators != null) return _cachedEmulators!;

    try {
      final jsonStr = await rootBundle.loadString(
        'assets/data/emulator_downloads.json',
      );
      final List<dynamic> jsonList = jsonDecode(jsonStr);
      _cachedEmulators = jsonList
          .map((json) => EmulatorDownloadInfo.fromJson(json))
          .toList();
      return _cachedEmulators!;
    } catch (e) {
      return [];
    }
  }

  // Backwards compatibility
  static List<EmulatorDownloadInfo> get emulators => _cachedEmulators ?? [];

  /// Get emulators by category
  static Future<List<EmulatorDownloadInfo>> getByCategory(
    String category,
  ) async {
    final all = await loadAll();
    switch (category) {
      case 'sony':
        return all
            .where(
              (e) => [
                'duckstation',
                'pcsx2',
                'rpcs3',
                'shadps4',
                'vita3k',
              ].contains(e.name),
            )
            .toList();
      case 'nintendo':
        return all
            .where(
              (e) => ['dolphin', 'cemu', 'ryujinx', 'citron'].contains(e.name),
            )
            .toList();
      case 'microsoft':
        return all.where((e) => ['xemu', 'xenia'].contains(e.name)).toList();
      case 'multi':
        return all
            .where((e) => ['retroarch', 'retroarch_cores'].contains(e.name))
            .toList();
      case 'utilities':
        return all
            .where((e) => ['vlc', 'koreader', 'qbittorrent'].contains(e.name))
            .toList();
      case 'other':
        return all
            .where((e) => ['eka2l1', 'ruffle', 'openbor'].contains(e.name))
            .toList();
      default:
        return all;
    }
  }

  /// Get emulators available for current platform
  static Future<List<EmulatorDownloadInfo>>
  getAvailableForCurrentPlatform() async {
    final all = await loadAll();
    return all.where((e) => e.isAvailableForCurrentPlatform()).toList();
  }
}
