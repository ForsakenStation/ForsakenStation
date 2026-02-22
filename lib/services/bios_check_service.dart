import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:forsaken/models/bios_requirement.dart';

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

  /// Scans all BIOS requirements and updates found status
  Future<List<BiosRequirement>> scanAllBios() async {
    final requirements = await BiosRequirement.getDefaultRequirements();
    final scannedRequirements = <BiosRequirement>[];

    for (final requirement in requirements) {
      final updatedFiles = <BiosFile>[];

      for (final biosFile in requirement.files) {
        final found = await checkBiosFile(
          requirement.locations,
          biosFile.filename,
        );
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
