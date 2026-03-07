import 'dart:convert';
import 'package:flutter/services.dart';
import '../services/debug_service.dart';

/// Represents a downloadable BIOS file with metadata from retroarch_system repo
class DownloadableBiosFile {
  final String filename;
  final String? expectedMd5;
  final String? expectedSha1;
  final String? expectedCrc32; // CRC32 checksum for additional verification
  final int? expectedSize;
  final double sizeTolerance; // Allow size variance percentage (0.0 to 1.0)
  final String? description;
  final String? region;
  final String? customBranch; // Support for alternative branches
  final String? customPath; // Support for direct system/ path
  final String?
  customRepository; // Support for external repositories (e.g., GitHub releases)
  final bool requiresExtraction; // ZIP/archive files that need extraction
  final List<String>? extractedFiles; // List of files to extract from archive
  final String? extractionPath; // Relative path within archive to extract from
  final bool
  isOptional; // Mark as optional/extra file (not required for basic functionality)
  final String?
  category; // Optional category for grouping (e.g., "regional", "enhancement", "alternative")

  const DownloadableBiosFile({
    required this.filename,
    this.expectedMd5,
    this.expectedSha1,
    this.expectedCrc32,
    this.expectedSize,
    this.sizeTolerance = 0.0, // Default: exact size match required
    this.description,
    this.region,
    this.customBranch,
    this.customPath,
    this.customRepository,
    this.requiresExtraction = false,
    this.extractedFiles,
    this.extractionPath,
    this.isOptional = false,
    this.category,
  });

  factory DownloadableBiosFile.fromJson(Map<String, dynamic> json) {
    return DownloadableBiosFile(
      filename: json['filename'] as String,
      expectedMd5: json['expectedMd5'] as String?,
      expectedSha1: json['expectedSha1'] as String?,
      expectedCrc32: json['expectedCrc32'] as String?,
      expectedSize: json['expectedSize'] as int?,
      sizeTolerance: (json['sizeTolerance'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String?,
      region: json['region'] as String?,
      customBranch: json['customBranch'] as String?,
      customPath: json['customPath'] as String?,
      customRepository: json['customRepository'] as String?,
      requiresExtraction: json['requiresExtraction'] as bool? ?? false,
      extractedFiles: json['extractedFiles'] != null
          ? List<String>.from(json['extractedFiles'] as List)
          : null,
      extractionPath: json['extractionPath'] as String?,
      isOptional: json['isOptional'] as bool? ?? false,
      category: json['category'] as String?,
    );
  }

  /// Generates the download URL for this file
  String getDownloadUrl(String repoFolder) {
    // Handle external repositories (e.g., GitHub releases)
    if (customRepository != null) {
      return customRepository!;
    }

    // Handle standard retroarch_system repository
    final branch = customBranch ?? 'libretro';
    const baseUrl = 'https://github.com/Abdess/retroarch_system/raw';

    if (customPath != null) {
      // Direct path (e.g., "system/Machines/MSX - Arabic")
      // Encode each segment individually to preserve '/' separators
      final encodedPath = customPath!
          .split('/')
          .map(Uri.encodeComponent)
          .join('/');
      final encodedFilename = Uri.encodeComponent(filename);
      return '$baseUrl/$branch/$encodedPath/$encodedFilename';
    } else {
      // Standard folder structure
      final encodedFolder = Uri.encodeComponent(repoFolder);
      final encodedFilename = Uri.encodeComponent(filename);
      return '$baseUrl/$branch/$encodedFolder/$encodedFilename';
    }
  }
}

/// Maps platform IDs to their corresponding folders and files in retroarch_system repo
class BiosDownloadMapping {
  final String platformId;
  final String repoFolder;
  final List<DownloadableBiosFile> files;
  final bool available;

  const BiosDownloadMapping({
    required this.platformId,
    required this.repoFolder,
    required this.files,
    this.available = true,
  });

  factory BiosDownloadMapping.fromJson(Map<String, dynamic> json) {
    final rawFiles = json['files'] as List;
    final parsedFiles = <DownloadableBiosFile>[];
    for (final f in rawFiles) {
      final map = f as Map<String, dynamic>;
      // Skip entries with null or missing filename
      if (map['filename'] == null) continue;
      parsedFiles.add(DownloadableBiosFile.fromJson(map));
    }
    return BiosDownloadMapping(
      platformId: json['platformId'] as String,
      repoFolder: json['repoFolder'] as String? ?? '',
      available: json['available'] as bool? ?? true,
      files: parsedFiles,
    );
  }

  /// Returns all download URLs for this platform
  List<String> getDownloadUrls() {
    return files.map((file) => file.getDownloadUrl(repoFolder)).toList();
  }

  /// Checks if a specific file is available for download
  bool hasFile(String filename) {
    return files.any((file) => file.filename == filename);
  }

  /// Gets the downloadable file info by filename
  DownloadableBiosFile? getFile(String filename) {
    try {
      return files.firstWhere((file) => file.filename == filename);
    } catch (_) {
      return null;
    }
  }

  static List<BiosDownloadMapping>? _cachedMappings;

  /// Load all mappings from the assets JSON file
  static Future<List<BiosDownloadMapping>> loadAll() async {
    if (_cachedMappings != null) return _cachedMappings!;

    try {
      final jsonStr = await rootBundle.loadString(
        'assets/data/bios_download_mappings.json',
      );
      final List<dynamic> jsonList = jsonDecode(jsonStr);
      _cachedMappings = jsonList
          .map((json) => BiosDownloadMapping.fromJson(json))
          .toList();
      return _cachedMappings!;
    } catch (e) {
      DebugService.instance.error(
        'Failed to load BIOS download mappings: $e',
        tag: 'BiosMapping',
      );
      return [];
    }
  }

  /// Gets mapping for a specific platform ID (Synchronous version, requires loadAll() to be called first)
  static BiosDownloadMapping? getMappingSync(String platformId) {
    if (_cachedMappings == null) return null;
    try {
      return _cachedMappings!.firstWhere(
        (mapping) => mapping.platformId == platformId,
      );
    } catch (_) {
      return null;
    }
  }

  /// Gets mapping for a specific platform ID
  static Future<BiosDownloadMapping?> getMapping(String platformId) async {
    await loadAll();
    return getMappingSync(platformId);
  }

  /// Gets all available mappings (excludes unavailable ones)
  static Future<List<BiosDownloadMapping>> getAvailableMappings() async {
    final all = await loadAll();
    return all.where((mapping) => mapping.available).toList();
  }

  /// Gets all platform IDs that have downloadable BIOS
  static Future<List<String>> getSupportedPlatforms() async {
    final all = await loadAll();
    return all
        .where((mapping) => mapping.available)
        .map((mapping) => mapping.platformId)
        .toList();
  }

  // Legacy static field for backwards compatibility
  // Warning: this will be empty if not awaited first!
  static List<BiosDownloadMapping> get allMappings => _cachedMappings ?? [];
}
