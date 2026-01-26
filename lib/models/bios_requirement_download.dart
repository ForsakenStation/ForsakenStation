import 'package:forsaken/models/bios_requirement.dart';
import 'package:forsaken/models/bios_download_mapping.dart';

/// Extension to add download functionality to BiosRequirement without circular dependencies
extension BiosRequirementDownload on BiosRequirement {
  /// Returns true if this platform has downloadable BIOS files available
  bool get canDownload {
    final mapping = BiosDownloadMapping.getMapping(platform);
    return mapping != null && mapping.available;
  }

  /// Gets the download mapping for this platform
  BiosDownloadMapping? get downloadMapping {
    return BiosDownloadMapping.getMapping(platform);
  }

  /// Returns list of missing files that can be downloaded (non-optional only)
  List<String> get downloadableMissingFiles {
    if (!canDownload) return [];

    final missingFiles = files
        .where((f) => !f.found)
        .map((f) => f.filename)
        .toList();
    final mapping = downloadMapping;

    if (mapping == null) return [];

    // Filter to only include files that are available and non-optional
    return missingFiles.where((filename) {
      final file = mapping.getFile(filename);
      return file != null && !file.isOptional;
    }).toList();
  }

  /// Returns list of missing optional files that can be downloaded
  List<String> get downloadableMissingOptionalFiles {
    if (!canDownload) return [];

    final missingFiles = files
        .where((f) => !f.found)
        .map((f) => f.filename)
        .toList();
    final mapping = downloadMapping;

    if (mapping == null) return [];

    // Filter to only include optional files
    return missingFiles.where((filename) {
      final file = mapping.getFile(filename);
      return file != null && file.isOptional;
    }).toList();
  }

  /// Returns all missing files (both required and optional)
  List<String> get downloadableMissingAllFiles {
    if (!canDownload) return [];

    final missingFiles = files
        .where((f) => !f.found)
        .map((f) => f.filename)
        .toList();
    final mapping = downloadMapping;

    if (mapping == null) return [];

    // Filter to only include files that are available in the download mapping
    return missingFiles.where((filename) => mapping.hasFile(filename)).toList();
  }

  /// Returns the primary destination path for downloads (first location)
  String get primaryLocation => locations.isNotEmpty ? locations.first : '';

  /// Gets count of downloadable missing files (required only)
  int get downloadableMissingCount => downloadableMissingFiles.length;

  /// Gets count of downloadable missing optional files
  int get downloadableMissingOptionalCount =>
      downloadableMissingOptionalFiles.length;

  /// Gets total count of downloadable missing files (required + optional)
  int get downloadableMissingAllCount => downloadableMissingAllFiles.length;

  /// Returns true if there are missing required files that can be downloaded
  bool get hasDownloadableMissing => downloadableMissingCount > 0;

  /// Returns true if there are missing optional files that can be downloaded
  bool get hasDownloadableMissingOptional =>
      downloadableMissingOptionalCount > 0;

  /// Returns true if there are any missing files (required or optional) that can be downloaded
  bool get hasDownloadableMissingAny => downloadableMissingAllCount > 0;
}
