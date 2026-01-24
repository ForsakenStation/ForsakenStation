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

  /// Returns list of missing files that can be downloaded
  List<String> get downloadableMissingFiles {
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

  /// Gets count of downloadable missing files
  int get downloadableMissingCount => downloadableMissingFiles.length;

  /// Returns true if there are missing files that can be downloaded
  bool get hasDownloadableMissing => downloadableMissingCount > 0;
}
