import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/collection.dart';
import '../models/rom.dart';
import 'debug_service.dart';

/// Service to manage ROM collections (Recently Played, Downloaded, etc.)
class CollectionService {
  static final CollectionService _instance = CollectionService._internal();
  static CollectionService get instance => _instance;

  CollectionService._internal();

  final _debug = DebugService.instance;

  // Storage keys
  static const String _recentlyPlayedKey = 'recently_played';
  static const String _downloadedRomsKey = 'downloaded_roms';
  static const int _maxRecentlyPlayed = 50; // Keep last 50 played ROMs

  /// Get all available collections
  Future<List<Collection>> getCollections() async {
    final collections = <Collection>[];

    // Recently Played collection
    final recentlyPlayed = await getRecentlyPlayedRoms();
    if (recentlyPlayed.isNotEmpty) {
      collections.add(
        Collection(
          id: 'recently_played',
          name: 'recently_played',
          displayName: 'Recently Played',
          type: CollectionType.recentlyPlayed,
          roms: recentlyPlayed,
        ),
      );
    }

    // Downloaded collection
    final downloaded = await getDownloadedRoms();
    if (downloaded.isNotEmpty) {
      collections.add(
        Collection(
          id: 'downloaded',
          name: 'downloaded',
          displayName: 'Downloaded',
          type: CollectionType.downloaded,
          roms: downloaded,
        ),
      );
    }

    return collections;
  }

  /// Track a ROM as recently played
  Future<void> addToRecentlyPlayed(Rom rom) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existing = await getRecentlyPlayedRoms();

      // Remove if already exists (to move it to front)
      existing.removeWhere(
        (r) => r.name == rom.name && r.platform == rom.platform,
      );

      // Add to front
      existing.insert(0, rom);

      // Keep only max items
      if (existing.length > _maxRecentlyPlayed) {
        existing.removeRange(_maxRecentlyPlayed, existing.length);
      }

      // Save
      final romsJson = existing.map((r) => _romToJson(r)).toList();
      await prefs.setString(_recentlyPlayedKey, json.encode(romsJson));

      _debug.info(
        'Added ${rom.name} to recently played (total: ${existing.length})',
        tag: 'CollectionService',
      );
    } catch (e) {
      _debug.error(
        'Failed to add ROM to recently played',
        tag: 'CollectionService',
        error: e,
      );
    }
  }

  /// Get recently played ROMs
  Future<List<Rom>> getRecentlyPlayedRoms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_recentlyPlayedKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> romsJson = json.decode(jsonString);
      return romsJson.map((j) => _romFromJson(j)).toList();
    } catch (e) {
      _debug.error(
        'Failed to load recently played ROMs',
        tag: 'CollectionService',
        error: e,
      );
      return [];
    }
  }

  /// Track a ROM as downloaded
  Future<void> addToDownloaded(Rom rom) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existing = await getDownloadedRoms();

      // Add if not already exists
      final alreadyExists = existing.any(
        (r) => r.name == rom.name && r.platform == rom.platform,
      );

      if (!alreadyExists) {
        existing.add(rom);

        // Save
        final romsJson = existing.map((r) => _romToJson(r)).toList();
        await prefs.setString(_downloadedRomsKey, json.encode(romsJson));

        _debug.info(
          'Added ${rom.name} to downloaded (total: ${existing.length})',
          tag: 'CollectionService',
        );
      }
    } catch (e) {
      _debug.error(
        'Failed to add ROM to downloaded',
        tag: 'CollectionService',
        error: e,
      );
    }
  }

  /// Remove a ROM from downloaded collection
  Future<void> removeFromDownloaded(Rom rom) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existing = await getDownloadedRoms();

      existing.removeWhere(
        (r) => r.name == rom.name && r.platform == rom.platform,
      );

      // Save
      final romsJson = existing.map((r) => _romToJson(r)).toList();
      await prefs.setString(_downloadedRomsKey, json.encode(romsJson));

      _debug.info(
        'Removed ${rom.name} from downloaded (remaining: ${existing.length})',
        tag: 'CollectionService',
      );
    } catch (e) {
      _debug.error(
        'Failed to remove ROM from downloaded',
        tag: 'CollectionService',
        error: e,
      );
    }
  }

  /// Get downloaded ROMs
  Future<List<Rom>> getDownloadedRoms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_downloadedRomsKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> romsJson = json.decode(jsonString);
      return romsJson.map((j) => _romFromJson(j)).toList();
    } catch (e) {
      _debug.error(
        'Failed to load downloaded ROMs',
        tag: 'CollectionService',
        error: e,
      );
      return [];
    }
  }

  /// Check if a ROM is in downloaded collection
  Future<bool> isDownloaded(String romName, String platform) async {
    final downloaded = await getDownloadedRoms();
    return downloaded.any((r) => r.name == romName && r.platform == platform);
  }

  /// Clear recently played history
  Future<void> clearRecentlyPlayed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_recentlyPlayedKey);
      _debug.info('Cleared recently played history', tag: 'CollectionService');
    } catch (e) {
      _debug.error(
        'Failed to clear recently played',
        tag: 'CollectionService',
        error: e,
      );
    }
  }

  /// Convert ROM to JSON
  Map<String, dynamic> _romToJson(Rom rom) {
    return {
      'name': rom.name,
      'fileName': rom.fileName,
      'platform': rom.platform,
      'urlFilePath': rom.urlFilePath,
      'downloadUrl': rom.downloadUrl,
      'localPath': rom.localPath,
      'subdirectory': rom.subdirectory,
    };
  }

  /// Convert JSON to ROM
  Rom _romFromJson(Map<String, dynamic> json) {
    return Rom(
      name: json['name'] as String,
      fileName: json['fileName'] as String,
      platform: json['platform'] as String,
      urlFilePath: json['urlFilePath'] as String,
      downloadUrl: json['downloadUrl'] as String?,
      localPath: json['localPath'] as String?,
      subdirectory: json['subdirectory'] as String?,
    );
  }
}
