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
  /// Looks for patterns like (USA), (Europe), (Japan), (USA, Europe), etc.
  static RegionInfo? fromRomName(String romName) {
    // Pattern matches region codes in parentheses
    // Examples: (USA), (Europe), (Japan), (World), (USA, Europe)
    final regionPattern = RegExp(r'\(([^)]+)\)');
    final matches = regionPattern.allMatches(romName);

    final List<String> extractedRegions = [];

    for (final match in matches) {
      final regionText = match.group(1);
      if (regionText != null) {
        // Handle comma-separated regions like (USA, Europe)
        final parts = regionText.split(',').map((s) => s.trim());

        for (final part in parts) {
          // Only add if it looks like a region (not other tags)
          if (_isValidRegion(part)) {
            extractedRegions.add(part);
          }
        }
      }
    }

    return extractedRegions.isEmpty ? null : RegionInfo(extractedRegions);
  }

  /// Check if a string is a valid region code
  static bool _isValidRegion(String text) {
    final textLower = text.toLowerCase().trim();

    // Empty or too long is not a region
    if (textLower.isEmpty || textLower.length > 20) {
      return false;
    }

    final knownRegions = {
      // Main regions
      'usa', 'us', 'europe', 'eu', 'japan', 'jp', 'jap', 'world', 'asia',
      // Countries
      'australia', 'au', 'brazil', 'br', 'canada', 'ca', 'china', 'cn',
      'france', 'fr', 'germany', 'de', 'italy', 'it', 'korea', 'kr',
      'netherlands', 'nl', 'spain', 'es', 'sweden', 'se', 'uk', 'gb',
      'united kingdom', 'united states', 'russia', 'ru',
      // TV standards (these are truly region-related)
      'pal', 'ntsc', 'unl',
    };

    // Check exact match (case insensitive)
    if (knownRegions.contains(textLower)) {
      return true;
    }

    // Reject common non-region tags (be more strict)
    final nonRegions = {
      'hack',
      'original',
      'rev',
      'version',
      'v1',
      'v2',
      'v3',
      'disc',
      'disk',
      'side',
      'collection',
      'edition',
      'remaster',
      'enhanced',
      'deluxe',
      'final',
      'complete',
      'director',
      'alternate',
      'alt',
      'translation',
      'fixed',
      'trainer',
      'uncut',
      'censored',
      'uncensored',
      'retail',
      'digital',
      'physical',
      'limited',
      'special',
      'goty',
      'patched',
      // Version/build tags (NOT regions)
      'demo',
      'beta',
      'alpha',
      'proto',
      'prototype',
      'sample',
      'promo',
      'preview',
      'trial',
      // Magazine/media related
      'coverdisk',
      'covertape',
      'magazine',
      'action',
      'issue',
      'number',
      'vol',
      'volume',
    };

    // Check if the text contains any non-region keywords
    for (final nonRegion in nonRegions) {
      if (textLower.contains(nonRegion)) {
        return false;
      }
    }

    // Reject if it starts with common tag prefixes
    if (textLower.startsWith('v') && RegExp(r'^v\d').hasMatch(textLower)) {
      return false; // Version tags like v1.0, v2
    }
    if (textLower.startsWith('rev') || textLower.startsWith('revision')) {
      return false; // Revision tags
    }

    // Reject if it's a number or contains only numbers
    if (RegExp(r'^\d+$').hasMatch(textLower)) {
      return false;
    }

    // Reject multi-word phrases that are likely not regions (except known ones)
    // Also check for text with hyphens, colons, or other separators
    final words = textLower
        .split(RegExp(r'[\s\-:]+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.length > 2) {
      return false; // Most regions are 1-2 words
    }

    // Reject if it contains special characters that regions don't have
    if (textLower.contains('-') ||
        textLower.contains(':') ||
        textLower.contains('/') ||
        textLower.contains('\\')) {
      return false;
    }

    // If it's a very short word (1-2 chars) and not in known regions, reject
    // This prevents single letters or abbreviations from being regions
    if (textLower.length <= 2 && !knownRegions.contains(textLower)) {
      return false;
    }

    // If it's capitalized properly (first letter uppercase) or all caps,
    // and it's a reasonable length, consider it valid
    if ((text[0] == text[0].toUpperCase() &&
        text.length >= 3 &&
        text.length <= 15)) {
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

      // TV standards
      'pal': '📺',
      'ntsc': '📺',
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
        countryCode.startsWith('📺') ||
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
      'pal': 'PAL',
      'ntsc': 'NTSC',
      'unl': 'Unlicensed',
    };

    return regionNames[regionLower] ?? region;
  }

  bool get isEmpty => regions.isEmpty;
  bool get isNotEmpty => regions.isNotEmpty;

  @override
  String toString() => 'RegionInfo(${regions.join(', ')})';
}
