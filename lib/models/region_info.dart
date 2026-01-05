/// Represents region information extracted from ROM names
///
/// ROMs often include region codes in parentheses like:
/// - "Game Name (USA)"
/// - "Game Name (Europe)"
/// - "Game Name (Japan)"
/// - "Game Name (World)"
///
/// This class extracts and provides display information for these regions.
class RegionInfo {
  final List<String> regions;

  const RegionInfo(this.regions);

  /// Extract regions from ROM name
  /// Looks for patterns like (USA), (Europe), (Japan), etc.
  static RegionInfo? fromRomName(String romName) {
    // Pattern matches region codes in parentheses
    // Examples: (USA), (Europe), (Japan), (World), (Spain), (Germany)
    final regionPattern = RegExp(r'\(([A-Za-z]+(?:\s+[A-Za-z]+)*)\)');
    final matches = regionPattern.allMatches(romName);

    final List<String> extractedRegions = [];

    for (final match in matches) {
      final regionText = match.group(1);
      if (regionText != null) {
        final normalized = regionText.trim();
        // Only add if it looks like a region (not other tags)
        if (_isValidRegion(normalized)) {
          extractedRegions.add(normalized);
        }
      }
    }

    return extractedRegions.isEmpty ? null : RegionInfo(extractedRegions);
  }

  /// Check if a string is a valid region code
  static bool _isValidRegion(String text) {
    final knownRegions = {
      // Main regions
      'USA', 'Europe', 'Japan', 'World', 'Asia',
      // Countries
      'Australia', 'Brazil', 'Canada', 'China', 'France', 'Germany',
      'Italy', 'Korea', 'Netherlands', 'Spain', 'Sweden', 'UK',
      'United Kingdom', 'United States', 'Russia',
      // Special
      'Proto', 'Beta', 'Sample', 'Demo', 'Promo', 'Unl',
    };

    // Check exact match (case insensitive)
    if (knownRegions.any((r) => r.toLowerCase() == text.toLowerCase())) {
      return true;
    }

    // Reject common non-region tags
    final nonRegions = {
      'hack',
      'original',
      'rev',
      'version',
      'v1',
      'v2',
      'disc',
      'disk',
      'side',
      'collection',
      'edition',
    };

    if (nonRegions.any((nr) => text.toLowerCase().contains(nr))) {
      return false;
    }

    // If it's a short word (likely abbreviation) or capitalized properly, consider it valid
    if (text.length <= 4 ||
        text == text.toUpperCase() ||
        text[0] == text[0].toUpperCase()) {
      return true;
    }

    return false;
  }

  /// Get emoji flag for a region
  static String getFlag(String region) {
    final regionLower = region.toLowerCase();

    // Map regions to country codes for flags
    const regionToCountryCode = {
      // Main regions use common representative countries
      'usa': 'US',
      'united states': 'US',
      'europe': 'EU',
      'japan': 'JP',
      'world': '🌐',
      'asia': '🌏',

      // Countries
      'australia': 'AU',
      'brazil': 'BR',
      'canada': 'CA',
      'china': 'CN',
      'france': 'FR',
      'germany': 'DE',
      'italy': 'IT',
      'korea': 'KR',
      'netherlands': 'NL',
      'spain': 'ES',
      'sweden': 'SE',
      'uk': 'GB',
      'united kingdom': 'GB',
      'russia': 'RU',

      // Special regions
      'proto': '🔧',
      'beta': '🔧',
      'sample': '📦',
      'demo': '🎮',
      'promo': '🎁',
      'unl': '🔓',
    };

    final countryCode = regionToCountryCode[regionLower];

    if (countryCode == null) {
      // Return generic region icon for unknown regions
      return '🗺️';
    }

    // If it's already an emoji, return it
    if (countryCode.startsWith('🌐') ||
        countryCode.startsWith('🌏') ||
        countryCode.startsWith('🔧') ||
        countryCode.startsWith('📦') ||
        countryCode.startsWith('🎮') ||
        countryCode.startsWith('🎁') ||
        countryCode.startsWith('🔓')) {
      return countryCode;
    }

    // Convert country code to emoji flag
    // Emoji flags use Regional Indicator Symbols (U+1F1E6 - U+1F1FF)
    // Each letter maps to: A=0x1F1E6, B=0x1F1E7, ..., Z=0x1F1FF
    if (countryCode.length == 2) {
      final first = countryCode.codeUnitAt(0);
      final second = countryCode.codeUnitAt(1);
      return String.fromCharCode(0x1F1E6 + (first - 65)) +
          String.fromCharCode(0x1F1E6 + (second - 65));
    }

    return '🗺️';
  }

  /// Get full region name for display
  static String getRegionName(String region) {
    final regionLower = region.toLowerCase();

    const regionNames = {
      'usa': 'United States',
      'europe': 'Europe',
      'japan': 'Japan',
      'world': 'World',
      'asia': 'Asia',
      'australia': 'Australia',
      'brazil': 'Brazil',
      'canada': 'Canada',
      'china': 'China',
      'france': 'France',
      'germany': 'Germany',
      'italy': 'Italy',
      'korea': 'Korea',
      'netherlands': 'Netherlands',
      'spain': 'Spain',
      'sweden': 'Sweden',
      'uk': 'United Kingdom',
      'united kingdom': 'United Kingdom',
      'russia': 'Russia',
      'proto': 'Prototype',
      'beta': 'Beta Version',
      'sample': 'Sample',
      'demo': 'Demo',
      'promo': 'Promotional',
      'unl': 'Unlicensed',
    };

    return regionNames[regionLower] ?? region;
  }

  bool get isEmpty => regions.isEmpty;
  bool get isNotEmpty => regions.isNotEmpty;

  @override
  String toString() => 'RegionInfo(${regions.join(', ')})';
}
