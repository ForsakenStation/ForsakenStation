import 'debug_service.dart';

/// Service for handling BIOS file size corrections and suggestions
class BiosSizeCorrectionService {
  // Known size corrections for specific repositories and files
  // This helps handle cases where repositories have different versions of the same file
  static const Map<String, Map<String, int>> _knownSizeCorrections = {
    // RetroPieBios repository corrections
    'github.com/PIBSAS/RetroPieBios': {
      'front-sp1.bin': 524288, // 512KB (actual RetroPieBios size)
      'top-sp1.bin': 524288, // 512KB (actual RetroPieBios size)
      'neocd.bin': 524288, // 512KB (actual RetroPieBios size)
      // Add more known corrections as discovered
    },

    // RetroArch System repository (original sizes)
    'github.com/Abdess/retroarch_system': {
      'front-sp1.bin': 131072, // 128KB (RetroArch version)
      'top-sp1.bin': 131072, // 128KB (RetroArch version)
    },
  };

  /// Suggests size correction for a file from a specific URL
  static int? suggestSizeCorrection(
    String url,
    String filename,
    int actualSize,
  ) {
    try {
      // Extract repository identifier from URL
      final uri = Uri.parse(url);
      final repoKey = '${uri.host}${uri.path.split('/').take(3).join('/')}';

      // Check if we have known corrections for this repository
      final corrections = _knownSizeCorrections[repoKey];
      if (corrections != null && corrections.containsKey(filename)) {
        final expectedSize = corrections[filename]!;

        // If the actual size matches our known correction, suggest it
        if (actualSize == expectedSize) {
          DebugService.instance.debug(
            'Size correction suggested for $filename from $repoKey: $actualSize bytes',
            tag: 'BiosSizeCorrection',
          );
          return actualSize;
        }
      }

      // Check if this is a reasonable size for the file type
      if (_isReasonableFileSize(filename, actualSize)) {
        DebugService.instance.debug(
          'Size appears reasonable for $filename: $actualSize bytes',
          tag: 'BiosSizeCorrection',
        );
        return actualSize;
      }

      return null;
    } catch (e) {
      DebugService.instance.error(
        'Error suggesting size correction: $e',
        tag: 'BiosSizeCorrection',
      );
      return null;
    }
  }

  /// Checks if a file size is reasonable for the given filename/type
  static bool _isReasonableFileSize(String filename, int size) {
    final extension = filename.toLowerCase().split('.').last;

    // Define reasonable size ranges for different file types
    switch (extension) {
      case 'bin':
      case 'rom':
        // BIOS files typically range from 1KB to 16MB
        return size >= 1024 && size <= 16 * 1024 * 1024;

      case 'zip':
        // Archive files can be larger
        return size >= 1024 && size <= 100 * 1024 * 1024;

      case 'wav':
        // Audio samples
        return size >= 1024 && size <= 10 * 1024 * 1024;

      default:
        // Conservative range for unknown types
        return size >= 512 && size <= 50 * 1024 * 1024;
    }
  }

  /// Generates a suggested tolerance based on file size and type
  static double suggestSizeTolerance(String filename, int expectedSize) {
    // Smaller files can have stricter tolerance
    if (expectedSize <= 4096) {
      return 0.0; // No tolerance for very small files (exact match)
    } else if (expectedSize <= 65536) {
      return 0.05; // 5% tolerance for small files
    } else if (expectedSize <= 1024 * 1024) {
      return 0.10; // 10% tolerance for medium files
    } else {
      return 0.15; // 15% tolerance for large files
    }
  }

  /// Checks if two sizes are compatible within reasonable bounds
  static bool areCompatibleSizes(int size1, int size2) {
    if (size1 == size2) return true;

    // Allow some variance for different compilation/compression
    final larger = size1 > size2 ? size1 : size2;
    final smaller = size1 < size2 ? size1 : size2;
    final ratio = smaller / larger;

    // Consider sizes compatible if within 20% of each other
    // and both are reasonable file sizes
    return ratio >= 0.8 &&
        _isReasonableFileSize('unknown.bin', size1) &&
        _isReasonableFileSize('unknown.bin', size2);
  }

  /// Logs size analysis information for debugging
  static void logSizeAnalysis(
    String filename,
    String url,
    int expectedSize,
    int actualSize,
  ) {
    final suggestion = suggestSizeCorrection(url, filename, actualSize);
    final tolerance = suggestSizeTolerance(filename, expectedSize);
    final compatible = areCompatibleSizes(expectedSize, actualSize);

    final debug = DebugService.instance;
    debug.debug('BIOS Size Analysis for $filename:', tag: 'BiosSizeCorrection');
    debug.debug('  Expected: $expectedSize bytes', tag: 'BiosSizeCorrection');
    debug.debug('  Actual: $actualSize bytes', tag: 'BiosSizeCorrection');
    debug.debug(
      '  Suggested correction: ${suggestion ?? 'None'}',
      tag: 'BiosSizeCorrection',
    );
    debug.debug(
      '  Suggested tolerance: ${(tolerance * 100).toStringAsFixed(1)}%',
      tag: 'BiosSizeCorrection',
    );
    debug.debug('  Sizes compatible: $compatible', tag: 'BiosSizeCorrection');
    debug.debug('  URL: $url', tag: 'BiosSizeCorrection');
  }
}
