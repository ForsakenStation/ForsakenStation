/// Resolves platform identifier aliases to ordered lookup candidates.
///
/// Different ROM sets, romlists, and theme packs use slightly different
/// identifiers for the same hardware (e.g. `gc` vs `gamecube`, `md` vs
/// `megadrive`, `ps1` vs `psx`, `cpc` vs `amstradcpc`). Returning ordered
/// candidates lets both media lookups and platform info lookups find the
/// best match without duplicating asset files.
class PlatformAliases {
  PlatformAliases._();

  static const Map<String, List<String>> _aliases = {
    // Nintendo
    'gc': ['gamecube'],
    'gamecube': ['gc'],
    '3ds': ['n3ds'],
    'n3ds': ['3ds'],
    'ds': ['nds'],
    'nds': ['ds'],
    'dsi': ['nds', 'ds'],
    'wiiware': ['wii'],
    'n64dd': ['n64'],
    '64dd': ['n64dd', 'n64'],
    'game&watch': ['gameandwatch'],
    'gw': ['gameandwatch'],
    'vb': ['virtualboy'],
    'virtualboy': ['vb'],
    'famicom': ['nes'],
    'sfc': ['snes'],
    'superfamicom': ['snes'],
    // Sega
    'md': ['megadrive', 'genesis'],
    'megadrive-msu': ['megadrive', 'genesis'],
    'sms': ['mastersystem'],
    'dc': ['dreamcast'],
    'gg': ['gamegear'],
    'segastv': ['stv', 'saturn'],
    'stv': ['segastv', 'saturn'],
    // Sony
    'ps1': ['psx'],
    'playstation': ['psx'],
    'vita': ['psvita'],
    'psvita': ['vita'],
    // Microsoft
    'xboxone': ['xbox360', 'xbox'],
    'xboxseriesx': ['xboxone', 'xbox360', 'xbox'],
    // Atari
    '5200': ['atari5200'],
    'atari5200': ['5200'],
    'jaguar': ['atarijaguar'],
    'atarijaguar': ['jaguar'],
    'jaguarcd': ['atarijaguarcd', 'atarijaguar'],
    'atarijaguarcd': ['jaguarcd', 'atarijaguar'],
    'lynx': ['atarilynx'],
    'atarilynx': ['lynx'],
    'xegs': ['atarixe', 'atari800'],
    'atarixe': ['xegs', 'atari800'],
    // NEC / SNK / Bandai
    'pce': ['pcengine', 'tg16'],
    'turbografx16': ['tg16', 'pcengine'],
    'turbografx': ['tg16', 'pcengine'],
    'tg16': ['pcengine'],
    'ws': ['wonderswan'],
    'wonderswan': ['ws'],
    'wsc': ['wonderswancolor', 'wonderswan'],
    'wonderswancolor': ['wsc'],
    'neogeo64': ['neogeo'],
    'neogeocs': ['neogeocd', 'neogeo'],
    // Home computers & early consoles
    'acorn': ['archimedes', 'bbcmicro', 'electron'],
    'amiga': ['amiga500', 'amiga1200'],
    'amiga600': ['amiga500', 'amiga1200'],
    'cdtv': ['amigacdtv'],
    'amigacdtv': ['cdtv'],
    'cplus4': ['plus4'],
    'plus4': ['cplus4'],
    'pet': ['c64', 'vic20'],
    'c128': ['c64'],
    'spectrum': ['zxspectrum'],
    'zxspectrum': ['spectrum'],
    'cpc': ['amstradcpc'],
    'amstradcpc': ['cpc'],
    'appleii': ['apple2'],
    'apple2': ['appleii'],
    'coleco': ['colecovision'],
    'colecovision': ['coleco'],
    'odyssey2': ['o2'],
    'o2': ['odyssey2'],
    'o2em': ['odyssey2', 'o2'],
    'thomson': ['to8'],
    'to8': ['thomson'],
    'nes3d': ['nes'],
    'chihiro': ['xbox', 'arcade'],
    'fmtows': ['fmtowns'],
    'fmtowns': ['fmtows'],
    'astrocde': ['astrocade'],
    'astrocade': ['astrocde'],
    'msx1': ['msx'],
    'msx2': ['msx'],
    'msx2+': ['msx2', 'msx'],
    'msx2plus': ['msx2+', 'msx2', 'msx'],
    'msxturbor': ['msx2', 'msx'],
    'camputerslynx': ['camplynx'],
    'camplynx': ['camputerslynx'],
    'casioloopy': ['casloopy'],
    'loopy': ['casloopy'],
    'creativision': ['crvision'],
    'crvision': ['creativision'],
    'gamepocket': ['gamepock'],
    'gamepock': ['gamepocket'],
    'oric': ['oricatmos'],
    'oricatmos': ['oric'],
    // Arcade / PC / Misc
    'fba': ['fbneo', 'arcade'],
    'fbneo': ['fba', 'arcade'],
    'cave': ['fbneo', 'fba', 'arcade'],
    'daphne': ['laserdisc'],
    'laserdisc': ['daphne'],
    'singe': ['daphne', 'laserdisc'],
    'hypseus': ['daphne', 'laserdisc'],
    'namco2x6': ['namco246', 'namco', 'ps2'],
    'namco246': ['namco2x6', 'namco', 'ps2'],
    'naomig': ['naomi', 'arcade'],
    'naomigd': ['naomi', 'arcade'],
    'pinballfx': ['vpinball', 'fpinball'],
    'pinballfx2': ['vpinball', 'fpinball'],
    'pinballfx3': ['vpinball', 'fpinball'],
    'pinballm': ['vpinball', 'fpinball'],
    'zaccariapinball': ['vpinball', 'fpinball'],
    'linux': ['pc'],
    'prboom': ['doom', 'pc'],
  };

  /// Returns ordered lookup candidates starting with [platformId] itself.
  static List<String> getCandidates(String platformId) {
    final lower = platformId.toLowerCase();
    final candidates = <String>[platformId];
    if (lower != platformId) {
      candidates.add(lower);
    }

    if (lower.startsWith('msx_')) {
      candidates.add('msx');
    }

    final mapped = _aliases[lower];
    if (mapped != null) {
      for (final alias in mapped) {
        if (!candidates.contains(alias)) {
          candidates.add(alias);
        }
      }
    }

    return candidates;
  }
}
