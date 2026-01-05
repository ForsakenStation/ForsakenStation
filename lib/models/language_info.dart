/// Model for language information extracted from ROM names
class LanguageInfo {
  final List<String> languageCodes;

  const LanguageInfo({required this.languageCodes});

  /// Extract language codes from ROM name
  /// Looks for patterns like (en), (es,en,fr), etc.
  static LanguageInfo? fromRomName(String romName) {
    // Pattern to match languages in parentheses: (en), (es,en,fr), etc.
    final regex = RegExp(r'\(([a-z]{2}(?:,[a-z]{2})*)\)', caseSensitive: false);
    final match = regex.firstMatch(romName);

    if (match == null) return null;

    final languagesString = match.group(1);
    if (languagesString == null) return null;

    // Split by comma and trim
    final codes = languagesString
        .split(',')
        .map((e) => e.trim().toLowerCase())
        .toList();

    // Filter valid language codes (2 letters)
    final validCodes = codes.where((code) => code.length == 2).toList();

    if (validCodes.isEmpty) return null;

    return LanguageInfo(languageCodes: validCodes);
  }

  /// Get language name from code
  static String getLanguageName(String code) {
    const languageNames = {
      'en': 'English',
      'es': 'Spanish',
      'fr': 'French',
      'de': 'German',
      'it': 'Italian',
      'pt': 'Portuguese',
      'ja': 'Japanese',
      'zh': 'Chinese',
      'ko': 'Korean',
      'ru': 'Russian',
      'nl': 'Dutch',
      'sv': 'Swedish',
      'no': 'Norwegian',
      'da': 'Danish',
      'fi': 'Finnish',
      'pl': 'Polish',
      'cs': 'Czech',
      'hu': 'Hungarian',
      'ro': 'Romanian',
      'tr': 'Turkish',
      'ar': 'Arabic',
      'he': 'Hebrew',
      'el': 'Greek',
      'th': 'Thai',
      'vi': 'Vietnamese',
      'id': 'Indonesian',
      'ms': 'Malay',
      'uk': 'Ukrainian',
      'bg': 'Bulgarian',
      'hr': 'Croatian',
      'sr': 'Serbian',
      'sk': 'Slovak',
      'sl': 'Slovenian',
      'ca': 'Catalan',
      'eu': 'Basque',
      'gl': 'Galician',
    };

    return languageNames[code.toLowerCase()] ?? code.toUpperCase();
  }

  /// Get emoji flag from language code
  static String? getFlag(String code) {
    // Map language codes to country codes for flags
    const languageToCountry = {
      'en': 'gb', // English -> UK flag
      'es': 'es', // Spanish
      'fr': 'fr', // French
      'de': 'de', // German
      'it': 'it', // Italian
      'pt': 'pt', // Portuguese
      'ja': 'jp', // Japanese
      'zh': 'cn', // Chinese
      'ko': 'kr', // Korean
      'ru': 'ru', // Russian
      'nl': 'nl', // Dutch
      'sv': 'se', // Swedish
      'no': 'no', // Norwegian
      'da': 'dk', // Danish
      'fi': 'fi', // Finnish
      'pl': 'pl', // Polish
      'cs': 'cz', // Czech
      'hu': 'hu', // Hungarian
      'ro': 'ro', // Romanian
      'tr': 'tr', // Turkish
      'ar': 'sa', // Arabic -> Saudi Arabia
      'he': 'il', // Hebrew -> Israel
      'el': 'gr', // Greek
      'th': 'th', // Thai
      'vi': 'vn', // Vietnamese
      'id': 'id', // Indonesian
      'ms': 'my', // Malay -> Malaysia
      'uk': 'ua', // Ukrainian
      'bg': 'bg', // Bulgarian
      'hr': 'hr', // Croatian
      'sr': 'rs', // Serbian
      'sk': 'sk', // Slovak
      'sl': 'si', // Slovenian
      'ca': 'es', // Catalan -> Spain (could also use Catalonia flag)
      'eu': 'es', // Basque -> Spain
      'gl': 'es', // Galician -> Spain
    };

    final countryCode = languageToCountry[code.toLowerCase()];
    if (countryCode == null) return null;

    // Convert country code to emoji flag
    // Flags are represented by regional indicator symbols
    // A = U+1F1E6, B = U+1F1E7, etc.
    final firstChar = countryCode[0].toUpperCase().codeUnitAt(0);
    final secondChar = countryCode[1].toUpperCase().codeUnitAt(0);

    final firstRegional = 0x1F1E6 + (firstChar - 0x41);
    final secondRegional = 0x1F1E6 + (secondChar - 0x41);

    return String.fromCharCode(firstRegional) +
        String.fromCharCode(secondRegional);
  }

  bool get hasLanguages => languageCodes.isNotEmpty;

  int get count => languageCodes.length;

  @override
  String toString() {
    return 'LanguageInfo(codes: ${languageCodes.join(', ')})';
  }
}
