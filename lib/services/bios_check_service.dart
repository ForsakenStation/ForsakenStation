import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import '../models/bios_requirement.dart';
import '../models/bios_download_mapping.dart';
import 'debug_service.dart';

class BiosCheckService {
  static BiosCheckService? _instance;

  BiosCheckService._();

  static BiosCheckService get instance {
    _instance ??= BiosCheckService._();
    return _instance!;
  }

  /// Expands ~ to home directory in path
  String _expandPath(String filePath) {
    if (filePath.startsWith('~/')) {
      final home = Platform.environment['HOME'] ?? '';
      return filePath.replaceFirst('~', home);
    }
    return filePath;
  }

  /// Checks if a specific BIOS file exists in any of the given locations
  Future<bool> checkBiosFile(List<String> locations, String filename) async {
    for (final location in locations) {
      final expandedPath = _expandPath(location);
      final fullPath = path.join(expandedPath, filename);
      final file = File(fullPath);
      if (await file.exists()) {
        return true;
      }
    }
    return false;
  }

  /// For archive files with extractedFiles, check the platform-specific
  /// extracted file instead of the archive itself.
  /// Returns the platform-specific filename to check, or null if not applicable.
  Future<String?> _getPlatformExtractedFile(
    String platformId,
    String filename,
  ) async {
    if (kIsWeb) return null;
    if (!filename.endsWith('.zip')) return null;

    final mapping = await BiosDownloadMapping.getMapping(platformId);
    if (mapping == null) return null;

    final downloadFile = mapping.getFile(filename);
    if (downloadFile == null || !downloadFile.requiresExtraction) return null;

    final extractedFiles = downloadFile.extractedFiles;
    if (extractedFiles == null || extractedFiles.isEmpty) return null;

    // Determine the platform-specific file extension
    List<String> platformFiles;
    if (Platform.isLinux || Platform.isAndroid) {
      platformFiles = extractedFiles.where((f) => f.endsWith('.so')).toList();
    } else if (Platform.isWindows) {
      platformFiles = extractedFiles.where((f) => f.endsWith('.dll')).toList();
    } else if (Platform.isMacOS) {
      platformFiles = extractedFiles
          .where((f) => f.endsWith('.dylib'))
          .toList();
    } else {
      return null;
    }

    if (platformFiles.isEmpty) return null;

    DebugService.instance.debug(
      'Checking "${platformFiles.first}" instead of archive "$filename"',
      tag: 'BiosCheck',
    );
    return platformFiles.first;
  }

  /// Scans all BIOS requirements and updates found status
  Future<List<BiosRequirement>> scanAllBios() async {
    final requirements = await BiosRequirement.getDefaultRequirements();
    final scannedRequirements = <BiosRequirement>[];

    for (final requirement in requirements) {
      final updatedFiles = <BiosFile>[];

      for (final biosFile in requirement.files) {
        // For archive files, check the platform-specific extracted file
        final extractedFile = await _getPlatformExtractedFile(
          requirement.platform,
          biosFile.filename,
        );

        final fileToCheck = extractedFile ?? biosFile.filename;
        final found = await checkBiosFile(requirement.locations, fileToCheck);
        updatedFiles.add(biosFile.copyWith(found: found));
      }

      scannedRequirements.add(requirement.copyWith(files: updatedFiles));
    }

    return scannedRequirements;
  }

  /// Returns only requirements with missing files
  List<BiosRequirement> filterMissing(List<BiosRequirement> requirements) {
    return requirements.where((req) => !req.hasAllFiles).toList();
  }

  /// Returns only required BIOS (not optional)
  List<BiosRequirement> filterRequired(List<BiosRequirement> requirements) {
    return requirements.where((req) => req.required).toList();
  }

  /// Returns statistics about BIOS files
  Map<String, int> getStatistics(List<BiosRequirement> requirements) {
    int totalPlatforms = requirements.length;
    int platformsComplete = requirements.where((r) => r.hasAllFiles).length;
    int platformsPartial = requirements
        .where((r) => r.hasSomeFiles && !r.hasAllFiles)
        .length;
    int platformsMissing = requirements.where((r) => !r.hasSomeFiles).length;
    int totalFiles = requirements.fold(0, (sum, r) => sum + r.totalCount);
    int foundFiles = requirements.fold(0, (sum, r) => sum + r.foundCount);

    return {
      'totalPlatforms': totalPlatforms,
      'platformsComplete': platformsComplete,
      'platformsPartial': platformsPartial,
      'platformsMissing': platformsMissing,
      'totalFiles': totalFiles,
      'foundFiles': foundFiles,
    };
  }
}
