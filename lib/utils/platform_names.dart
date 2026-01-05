// Platform name mappings from folder names to display names
// This maps the common folder/system codes used in emulation to their proper display names

class PlatformNames {
  // Private constructor to prevent instantiation
  PlatformNames._();

  /// Map of platform codes to their full display names
  static const Map<String, String> displayNames = {
    // Nintendo Consoles
    'nes': 'Nintendo Entertainment System',
    'snes': 'Super Nintendo Entertainment System',
    'n64': 'Nintendo 64',
    'gc': 'Nintendo GameCube',
    'gamecube': 'Nintendo GameCube',
    'wii': 'Nintendo Wii',
    'wiiu': 'Nintendo Wii U',
    'switch': 'Nintendo Switch',

    // Nintendo Handhelds
    'gb': 'Game Boy',
    'gbc': 'Game Boy Color',
    'gba': 'Game Boy Advance',
    'nds': 'Nintendo DS',
    'ds': 'Nintendo DS',
    '3ds': 'Nintendo 3DS',

    // Sega Consoles
    'genesis': 'Sega Genesis',
    'megadrive': 'Sega Mega Drive',
    'md': 'Sega Mega Drive',
    'mastersystem': 'Sega Master System',
    'sms': 'Sega Master System',
    'saturn': 'Sega Saturn',
    'dreamcast': 'Sega Dreamcast',
    'dc': 'Sega Dreamcast',
    'sg1000': 'Sega SG-1000',

    // Sega Handhelds
    'gamegear': 'Sega Game Gear',
    'gg': 'Sega Game Gear',

    // Sony
    'ps1': 'PlayStation',
    'psx': 'PlayStation',
    'playstation': 'PlayStation',
    'ps2': 'PlayStation 2',
    'ps3': 'PlayStation 3',
    'ps4': 'PlayStation 4',
    'psp': 'PlayStation Portable',
    'psvita': 'PlayStation Vita',
    'vita': 'PlayStation Vita',

    // Microsoft
    'xbox': 'Xbox',
    'xbox360': 'Xbox 360',
    'xboxone': 'Xbox One',

    // Atari
    'atari2600': 'Atari 2600',
    'atari5200': 'Atari 5200',
    'atari7800': 'Atari 7800',
    'atarijaguar': 'Atari Jaguar',
    'jaguar': 'Atari Jaguar',
    'atarilynx': 'Atari Lynx',
    'lynx': 'Atari Lynx',
    'atarist': 'Atari ST',

    // Neo Geo
    'neogeo': 'Neo Geo',
    'ngp': 'Neo Geo Pocket',
    'ngpc': 'Neo Geo Pocket Color',

    // Classic Computers
    'amiga': 'Commodore Amiga',
    'c64': 'Commodore 64',
    'c128': 'Commodore 128',
    'vic20': 'Commodore VIC-20',
    'zxspectrum': 'ZX Spectrum',
    'spectrum': 'ZX Spectrum',
    'msx': 'MSX',
    'msx2': 'MSX2',
    'amstradcpc': 'Amstrad CPC',
    'cpc': 'Amstrad CPC',
    'apple2': 'Apple II',
    'appleii': 'Apple II',
    'macintosh': 'Macintosh',

    // Arcade
    'arcade': 'Arcade',
    'mame': 'MAME Arcade',
    'fba': 'FinalBurn Alpha',
    'fbneo': 'FinalBurn Neo',
    'naomi': 'Sega Naomi',
    'atomiswave': 'Sammy Atomiswave',

    // Other Consoles
    '3do': '3DO Interactive Multiplayer',
    'colecovision': 'ColecoVision',
    'coleco': 'ColecoVision',
    'intellivision': 'Intellivision',
    'vectrex': 'Vectrex',
    'wonderswan': 'WonderSwan',
    'ws': 'WonderSwan',
    'wonderswancolor': 'WonderSwan Color',
    'wsc': 'WonderSwan Color',
    'pcengine': 'PC Engine',
    'pce': 'PC Engine',
    'tg16': 'TurboGrafx-16',
    'turbografx16': 'TurboGrafx-16',
    'turbografx': 'TurboGrafx-16',
    'pcfx': 'PC-FX',
    'channelf': 'Fairchild Channel F',
    'odyssey2': 'Magnavox Odyssey 2',
    'virtualboy': 'Virtual Boy',
    'vb': 'Virtual Boy',

    // Mobile/Modern
    'android': 'Android',
    'ios': 'iOS',

    // PC
    'pc': 'PC',
    'dos': 'MS-DOS',
    'windows': 'Windows',
    'linux': 'Linux',
    'scummvm': 'ScummVM',

    // Multi-system
    'retro': 'Retro Games',
    'ports': 'Game Ports',
    'homebrew': 'Homebrew',
  };

  /// Get the display name for a platform code
  /// Returns the full name if found, otherwise returns a capitalized version of the code
  static String getDisplayName(String code) {
    final lowerCode = code.toLowerCase();

    // Check if we have a mapping
    if (displayNames.containsKey(lowerCode)) {
      return displayNames[lowerCode]!;
    }

    // Fallback: capitalize first letter of each word
    return code
        .split(RegExp(r'[_\-\s]'))
        .map(
          (word) => word.isEmpty
              ? ''
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  /// Get short name (abbreviation) for display in compact spaces
  static String getShortName(String code) {
    final lowerCode = code.toLowerCase();

    // Common abbreviations
    const shortNames = {
      'nes': 'NES',
      'snes': 'SNES',
      'n64': 'N64',
      'gc': 'GC',
      'gamecube': 'GC',
      'gba': 'GBA',
      'nds': 'NDS',
      'genesis': 'Genesis',
      'megadrive': 'MD',
      'ps1': 'PS1',
      'psx': 'PS1',
      'ps2': 'PS2',
      'ps3': 'PS3',
      'psp': 'PSP',
      'xbox': 'Xbox',
      'dreamcast': 'DC',
      'arcade': 'Arcade',
      'mame': 'MAME',
    };

    if (shortNames.containsKey(lowerCode)) {
      return shortNames[lowerCode]!;
    }

    // Fallback: uppercase the code
    return code.toUpperCase();
  }

  /// Get all available platform codes
  static List<String> getAllCodes() {
    return displayNames.keys.toList()..sort();
  }

  /// Check if a platform code exists in the mapping
  static bool exists(String code) {
    return displayNames.containsKey(code.toLowerCase());
  }
}
