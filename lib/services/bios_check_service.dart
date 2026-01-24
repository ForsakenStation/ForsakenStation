import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:forsaken/models/bios_requirement.dart';

class BiosCheckService {
  /// Expands ~ to home directory in path
  static String _expandPath(String filePath) {
    if (filePath.startsWith('~/')) {
      final home = Platform.environment['HOME'] ?? '';
      return filePath.replaceFirst('~', home);
    }
    return filePath;
  }

  /// Checks if a specific BIOS file exists in any of the given locations
  static bool checkBiosFile(List<String> locations, String filename) {
    for (final location in locations) {
      final expandedPath = _expandPath(location);
      final fullPath = path.join(expandedPath, filename);
      final file = File(fullPath);
      if (file.existsSync()) {
        return true;
      }
    }
    return false;
  }

  /// Scans all BIOS requirements and updates found status
  static Future<List<BiosRequirement>> scanAllBios() async {
    final requirements = BiosRequirement.getDefaultRequirements();
    final scannedRequirements = <BiosRequirement>[];

    for (final requirement in requirements) {
      final updatedFiles = <BiosFile>[];

      for (final biosFile in requirement.files) {
        final found = checkBiosFile(requirement.locations, biosFile.filename);
        updatedFiles.add(biosFile.copyWith(found: found));
      }

      scannedRequirements.add(requirement.copyWith(files: updatedFiles));
    }

    return scannedRequirements;
  }

  /// Returns only requirements with missing files
  static List<BiosRequirement> filterMissing(
    List<BiosRequirement> requirements,
  ) {
    return requirements.where((req) => !req.hasAllFiles).toList();
  }

  /// Returns only required BIOS (not optional)
  static List<BiosRequirement> filterRequired(
    List<BiosRequirement> requirements,
  ) {
    return requirements.where((req) => req.required).toList();
  }

  /// Returns statistics about BIOS files
  static Map<String, int> getStatistics(List<BiosRequirement> requirements) {
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
