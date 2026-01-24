class BiosFile {
  final String filename;
  final bool found;
  final String? region;
  final String? description;

  BiosFile({
    required this.filename,
    this.found = false,
    this.region,
    this.description,
  });

  BiosFile copyWith({bool? found}) {
    return BiosFile(
      filename: filename,
      found: found ?? this.found,
      region: region,
      description: description,
    );
  }
}

class BiosRequirement {
  final String platform;
  final String displayName;
  final bool required;
  final List<BiosFile> files;
  final List<String> locations;
  final String? notes;

  BiosRequirement({
    required this.platform,
    required this.displayName,
    required this.required,
    required this.files,
    required this.locations,
    this.notes,
  });

  BiosRequirement copyWith({List<BiosFile>? files}) {
    return BiosRequirement(
      platform: platform,
      displayName: displayName,
      required: required,
      files: files ?? this.files,
      locations: locations,
      notes: notes,
    );
  }

  bool get hasAllFiles => files.every((f) => f.found);
  bool get hasSomeFiles => files.any((f) => f.found);
  int get foundCount => files.where((f) => f.found).length;
  int get totalCount => files.length;

  static List<BiosRequirement> getDefaultRequirements() {
    return [
      // PlayStation 1 (Beetle PSX)
      BiosRequirement(
        platform: 'psx',
        displayName: 'PlayStation 1 (Beetle PSX)',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(
            filename: 'scph5500.bin',
            region: 'JAP',
            description: 'SCPH-5500 (Japan)',
          ),
          BiosFile(
            filename: 'scph5501.bin',
            region: 'USA',
            description: 'SCPH-5501 (USA)',
          ),
          BiosFile(
            filename: 'scph5502.bin',
            region: 'EUR',
            description: 'SCPH-5502 (Europe)',
          ),
        ],
        notes:
            'At least one region BIOS required. For Beetle PSX core. DuckStation also checks ~/.local/share/duckstation/bios/',
      ),

      // PlayStation 1 (PCSX ReARMed)
      BiosRequirement(
        platform: 'psx_pcsx',
        displayName: 'PlayStation 1 (PCSX ReARMed)',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(
            filename: 'PSXONPSP660.BIN',
            description: 'PSX on PSP BIOS (extracted from PSP)',
          ),
          BiosFile(
            filename: 'scph101.bin',
            region: 'USA',
            description: 'SCPH-101 BIOS v4.4 03/24/00 A',
          ),
          BiosFile(
            filename: 'scph7001.bin',
            region: 'USA',
            description: 'SCPH-7001 BIOS v4.1 12/16/97 A',
          ),
          BiosFile(
            filename: 'scph1001.bin',
            region: 'USA',
            description: 'SCPH-1001 BIOS v2.0 05/07/95 A',
          ),
          BiosFile(
            filename: 'scph5501.bin',
            region: 'USA',
            description: 'SCPH-5501 (USA)',
          ),
        ],
        notes:
            'At least one BIOS required for PCSX ReARMed core. Multiple versions supported.',
      ),

      // Arcade (MAME/FinalBurn Neo)
      BiosRequirement(
        platform: 'arcade',
        displayName: 'Arcade (MAME/FinalBurn Neo)',
        required: false,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(filename: 'neogeo.zip', description: 'Neo Geo BIOS'),
          BiosFile(filename: 'pgm.zip', description: 'PGM System BIOS'),
          BiosFile(filename: 'naomi.zip', description: 'Naomi System BIOS'),
          BiosFile(filename: 'awbios.zip', description: 'Atomiswave BIOS'),
          BiosFile(
            filename: 'f355bios.zip',
            description: 'Ferrari F355 Challenge BIOS',
          ),
          BiosFile(
            filename: 'hod2bios.zip',
            description: 'House of the Dead 2 BIOS',
          ),
          BiosFile(
            filename: 'airlbios.zip',
            description: 'Airline Pilots BIOS',
          ),
          BiosFile(
            filename: 'skns.zip',
            description: 'Super Kaneko Nova System BIOS',
          ),
        ],
        notes:
            'BIOS files for various arcade systems. Required for specific arcade games in MAME and FinalBurn Neo cores. ✅ Available for automatic download.',
      ),

      // PlayStation 2
      BiosRequirement(
        platform: 'ps2',
        displayName: 'PlayStation 2',
        required: true,
        locations: ['~/.config/retroarch/system/', '~/.config/PCSX2/bios/'],
        files: [
          BiosFile(
            filename: 'SCPH-70012.bin',
            region: 'USA',
            description: 'PS2 BIOS USA v2.30',
          ),
          BiosFile(
            filename: 'SCPH-90001.bin',
            region: 'USA',
            description: 'PS2 BIOS USA (slim)',
          ),
          BiosFile(
            filename: 'ps2-0230a-20080220.bin',
            description: 'Alternative BIOS',
          ),
        ],
        notes:
            'Various BIOS versions work. Place in RetroArch system dir or PCSX2 bios dir. Several PS2 BIOS files are now available through the automatic download system, including SCPH-39001.bin (USA) and SCPH-70004.BIN (EUR).',
      ),

      // Sega Saturn
      BiosRequirement(
        platform: 'saturn',
        displayName: 'Sega Saturn',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(
            filename: 'sega_101.bin',
            region: 'USA',
            description: 'Saturn BIOS USA',
          ),
          BiosFile(
            filename: 'mpr-17933.bin',
            region: 'JAP',
            description: 'Saturn BIOS Japan',
          ),
          BiosFile(
            filename: 'mpr-18811-mx.ic1',
            region: 'EUR',
            description: 'King of Fighters 95 ROM Cartridge',
          ),
          BiosFile(
            filename: 'mpr-19367-mx.ic1',
            region: 'JAP',
            description: 'Ultraman ROM Cartridge',
          ),
        ],
        notes:
            'At least one region BIOS required. ROM cartridges needed for specific games.',
      ),

      // Sega Dreamcast
      BiosRequirement(
        platform: 'dreamcast',
        displayName: 'Sega Dreamcast',
        required: true,
        locations: ['~/.config/retroarch/system/dc/'],
        files: [
          BiosFile(filename: 'dc_boot.bin', description: 'Dreamcast boot ROM'),
          BiosFile(
            filename: 'dc_flash.bin',
            description: 'Dreamcast flash ROM',
          ),
        ],
        notes: 'Both files required. Place in dc/ subdirectory.',
      ),

      // Sega Master System
      BiosRequirement(
        platform: 'mastersystem',
        displayName: 'Sega Master System',
        required: false,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(
            filename: 'bios_U.sms',
            region: 'USA',
            description: 'Master System BIOS USA',
          ),
          BiosFile(
            filename: 'bios_E.sms',
            region: 'EUR',
            description: 'Master System BIOS Europe',
          ),
          BiosFile(
            filename: 'bios_J.sms',
            region: 'JAP',
            description: 'Master System BIOS Japan (Mark III)',
          ),
          BiosFile(
            filename: 'bios.sms',
            description: 'Master System BIOS (generic)',
          ),
        ],
        notes:
            'Optional but required for some games and enables proper region behavior.',
      ),

      // Sega CD
      BiosRequirement(
        platform: 'segacd',
        displayName: 'Sega CD',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(
            filename: 'bios_CD_U.bin',
            region: 'USA',
            description: 'Sega CD BIOS USA',
          ),
          BiosFile(
            filename: 'bios_CD_E.bin',
            region: 'EUR',
            description: 'Sega CD BIOS Europe',
          ),
          BiosFile(
            filename: 'bios_CD_J.bin',
            region: 'JAP',
            description: 'Mega CD BIOS Japan',
          ),
        ],
        notes: 'At least one region BIOS required.',
      ),

      // Sega Genesis / Mega Drive
      BiosRequirement(
        platform: 'genesis',
        displayName: 'Sega Genesis / Mega Drive',
        required: false,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(
            filename: 'bios_MD.bin',
            description: 'Genesis/Mega Drive BIOS',
          ),
          BiosFile(
            filename: 'areplay.bin',
            description: 'Action Replay cartridge ROM',
          ),
          BiosFile(
            filename: 'ggenie.bin',
            description: 'Game Genie cartridge ROM',
          ),
          BiosFile(
            filename: 'sk.bin',
            description: 'Sonic & Knuckles lock-on cartridge ROM',
          ),
          BiosFile(
            filename: 'sk2chip.bin',
            description: 'Sonic & Knuckles 2 chip ROM',
          ),
        ],
        notes:
            'Optional but improves compatibility. BIOS enhances accuracy, S&K ROMs enable lock-on functionality, cheat device ROMs enable respective features.',
      ),

      // PC Engine CD
      BiosRequirement(
        platform: 'pcenginecd',
        displayName: 'PC Engine CD',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(
            filename: 'syscard3.pce',
            description: 'PC Engine CD System Card v3',
          ),
          BiosFile(
            filename: 'syscard2.pce',
            description: 'PC Engine CD System Card v2',
          ),
          BiosFile(
            filename: 'syscard1.pce',
            description: 'PC Engine CD System Card v1',
          ),
        ],
        notes: 'syscard3.pce recommended for best compatibility.',
      ),

      // Nintendo DS
      BiosRequirement(
        platform: 'nds',
        displayName: 'Nintendo DS',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(filename: 'bios7.bin', description: 'ARM7 BIOS'),
          BiosFile(filename: 'bios9.bin', description: 'ARM9 BIOS'),
          BiosFile(filename: 'firmware.bin', description: 'DS Firmware'),
        ],
        notes: 'All three files required for proper emulation.',
      ),

      // Famicom Disk System
      BiosRequirement(
        platform: 'fds',
        displayName: 'Famicom Disk System',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [BiosFile(filename: 'disksys.rom', description: 'FDS BIOS')],
        notes: 'Required for Famicom Disk System games.',
      ),

      // Sega Game Gear
      BiosRequirement(
        platform: 'gamegear',
        displayName: 'Sega Game Gear',
        required: false,
        locations: ['~/.config/retroarch/system/'],
        files: [BiosFile(filename: 'bios.gg', description: 'Game Gear BIOS')],
        notes: 'Optional but improves compatibility with some games.',
      ),

      // Nintendo Pokemon Mini
      BiosRequirement(
        platform: 'pokemini',
        displayName: 'Nintendo Pokemon Mini',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(filename: 'bios.min', description: 'Pokemon Mini BIOS'),
        ],
        notes: 'Required for Pokemon Mini emulation.',
      ),

      // Fairchild Channel F
      BiosRequirement(
        platform: 'channelf',
        displayName: 'Fairchild Channel F',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(
            filename: 'sl31253.bin',
            description: 'Channel F System ROM (SL31253)',
          ),
          BiosFile(
            filename: 'sl31254.bin',
            description: 'Channel F System ROM (SL31254)',
          ),
          BiosFile(
            filename: 'sl90025.bin',
            description: 'Channel F System ROM (SL90025)',
          ),
        ],
        notes:
            'At least one system ROM required. Different ROMs for different Channel F variants.',
      ),

      // Atari 400/800
      BiosRequirement(
        platform: 'atari800',
        displayName: 'Atari 400/800/XL/XE',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(filename: 'ATARIXL.ROM', description: 'Atari XL/XE OS ROM'),
          BiosFile(filename: 'ATARIBAS.ROM', description: 'Atari BASIC ROM'),
          BiosFile(
            filename: 'ATARIOSA.ROM',
            description: 'Atari 400/800 OS-A ROM',
          ),
          BiosFile(
            filename: 'ATARIOSB.ROM',
            description: 'Atari 400/800 OS-B ROM',
          ),
        ],
        notes:
            'OS ROM required. BASIC ROM optional but recommended for BASIC programs.',
      ),

      // Phillips Videopac+
      BiosRequirement(
        platform: 'videopac',
        displayName: 'Philips Videopac+ / Odyssey²',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(
            filename: 'g7400.bin',
            description: 'Philips G7400 BIOS (Videopac+ G7400)',
          ),
          BiosFile(filename: 'c52.bin', description: 'Philips C52 BIOS'),
          BiosFile(
            filename: 'jopac.bin',
            description: 'Jopac BIOS (French variant)',
          ),
        ],
        notes: 'Compatible with Odyssey² - use appropriate BIOS for region.',
      ),

      // Sharp X1
      BiosRequirement(
        platform: 'x1',
        displayName: 'Sharp X1',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(filename: 'iplrom.x1', description: 'Sharp X1 IPL ROM'),
          BiosFile(
            filename: 'iplrom.x1t',
            description: 'Sharp X1 Turbo IPL ROM',
          ),
        ],
        notes:
            'IPL ROM required for X1 emulation. Use appropriate ROM for model variant.',
      ),

      // Atari ST
      BiosRequirement(
        platform: 'atarist',
        displayName: 'Atari ST',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(filename: 'tos.img', description: 'Atari ST TOS ROM Image'),
        ],
        notes: 'Required for Atari ST emulation.',
      ),

      // Sharp X68000
      BiosRequirement(
        platform: 'x68000',
        displayName: 'Sharp X68000',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(filename: 'iplrom.dat', description: 'X68000 IPL ROM'),
          BiosFile(
            filename: 'cgrom.dat',
            description: 'X68000 Character Generator ROM',
          ),
          BiosFile(
            filename: 'iplrom30.dat',
            description: 'X68000 IPL ROM v3.0',
          ),
          BiosFile(
            filename: 'iplromco.dat',
            description: 'X68000 IPL ROM (Compact)',
          ),
          BiosFile(
            filename: 'iplromxv.dat',
            description: 'X68000 IPL ROM (XVI)',
          ),
        ],
        notes:
            'IPL ROM and CG ROM required. Different IPL ROM versions for different X68000 models.',
      ),

      // Atari 5200
      BiosRequirement(
        platform: 'atari5200',
        displayName: 'Atari 5200',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(filename: '5200.rom', description: 'Atari 5200 BIOS'),
          BiosFile(filename: 'ATARIXL.ROM', description: 'Alternative BIOS'),
        ],
        notes: 'At least one BIOS file required.',
      ),

      // Game Boy Advance (optional but recommended)
      BiosRequirement(
        platform: 'gba',
        displayName: 'Game Boy Advance',
        required: false,
        locations: ['~/.config/retroarch/system/'],
        files: [BiosFile(filename: 'gba_bios.bin', description: 'GBA BIOS')],
        notes: 'Optional but improves compatibility and accuracy.',
      ),

      // MSX
      BiosRequirement(
        platform: 'msx',
        displayName: 'MSX',
        required: true,
        locations: ['~/.config/retroarch/system/Machines/'],
        files: [
          BiosFile(filename: 'MSX.ROM', description: 'MSX BIOS'),
          BiosFile(filename: 'MSX2.ROM', description: 'MSX2 BIOS'),
          BiosFile(filename: 'MSX2EXT.ROM', description: 'MSX2 Extended BIOS'),
          BiosFile(filename: 'MSX2P.ROM', description: 'MSX2+ BIOS'),
        ],
        notes:
            'Place in Machines/ subdirectory. Different MSX versions require different BIOS files.',
      ),

      // Amiga
      BiosRequirement(
        platform: 'amiga',
        displayName: 'Amiga',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(
            filename: 'kick34005.A500',
            description: 'Kickstart 1.3 (A500)',
          ),
          BiosFile(
            filename: 'kick40063.A600',
            description: 'Kickstart 3.1 (A600)',
          ),
          BiosFile(
            filename: 'kick40068.A1200',
            description: 'Kickstart 3.1 (A1200)',
          ),
          BiosFile(
            filename: 'Capsimg_for_Retroarch.zip',
            description:
                'Capsimg library for IPF files (auto-extracts platform files)',
          ),
        ],
        notes:
            'Different Kickstart ROMs for different Amiga models. At least one required. Capsimg library enables support for copy-protected IPF disk images and auto-extracts the correct files for your platform.',
      ),

      // Apple Macintosh II
      BiosRequirement(
        platform: 'macii',
        displayName: 'Apple Macintosh II',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(
            filename: 'MacII.ROM',
            description: 'Macintosh II System ROM',
          ),
        ],
        notes: 'Required for Macintosh II emulation.',
      ),

      // CD-i
      BiosRequirement(
        platform: 'cdi',
        displayName: 'Philips CD-i',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(filename: 'cdi200.rom', description: 'CD-i 200 BIOS'),
          BiosFile(filename: 'cdi220.rom', description: 'CD-i 220 BIOS'),
          BiosFile(filename: 'cdi220b.rom', description: 'CD-i 220 BIOS (alt)'),
        ],
        notes:
            'At least one CD-i BIOS required. Note: These files are not available through the automatic download system.',
      ),

      // NEC PC-98
      BiosRequirement(
        platform: 'pc98',
        displayName: 'NEC PC-98',
        required: true,
        locations: [
          '~/.config/retroarch/system/',
          '~/.config/retroarch/system/np2kai/',
        ],
        files: [
          BiosFile(filename: 'bios.rom', description: 'PC-98 BIOS ROM'),
          BiosFile(filename: 'itf.rom', description: 'PC-98 ITF ROM'),
          BiosFile(filename: 'sound.rom', description: 'PC-98 Sound ROM'),
          BiosFile(filename: 'font.rom', description: 'PC-98 Font ROM'),
          BiosFile(filename: 'font.bmp', description: 'PC-98 Font Bitmap'),
        ],
        notes:
            'BIOS ROM required. Other files enhance compatibility and enable proper font rendering and sound.',
      ),

      // Magnavox Odyssey²
      BiosRequirement(
        platform: 'odyssey2',
        displayName: 'Magnavox Odyssey²',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(filename: 'o2rom.bin', description: 'Odyssey² BIOS ROM'),
        ],
        notes:
            'Required for Magnavox Odyssey² and Philips Videopac+ emulation.',
      ),

      // Neo Geo (RetroArch cores: FBNeo, MAME)
      BiosRequirement(
        platform: 'neogeo',
        displayName: 'Neo Geo',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(filename: 'neogeo.zip', description: 'Neo Geo BIOS'),
          BiosFile(filename: 'ng-lo.rom', description: 'Neo Geo BIOS (alt)'),
        ],
        notes:
            'Required for FBNeo and MAME cores. Place neogeo.zip in system directory.',
      ),

      // Game Boy (optional)
      BiosRequirement(
        platform: 'gb',
        displayName: 'Game Boy',
        required: false,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(
            filename: 'dmg_boot.bin',
            description: 'Game Boy Boot ROM (DMG)',
          ),
          BiosFile(filename: 'gb_bios.bin', description: 'Game Boy BIOS'),
        ],
        notes: 'Optional but improves accuracy and enables boot animation.',
      ),

      // Game Boy Color (optional)
      BiosRequirement(
        platform: 'gbc',
        displayName: 'Game Boy Color',
        required: false,
        locations: ['~/.config/retroarch/system/'],
        files: [BiosFile(filename: 'gbc_bios.bin', description: 'GBC BIOS')],
        notes: 'Optional but improves accuracy in some cores.',
      ),

      // Nintendo Entertainment System (Nestopia)
      BiosRequirement(
        platform: 'nes',
        displayName: 'Nintendo Entertainment System',
        required: false,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(
            filename: 'NstDatabase.xml',
            description: 'Nestopia game database',
          ),
        ],
        notes:
            'Game database for enhanced compatibility in Nestopia core. ✅ Available for automatic download.',
      ),

      // Nintendo 64DD
      BiosRequirement(
        platform: 'n64dd',
        displayName: 'Nintendo 64DD',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(filename: '64DD_IPL.bin', description: '64DD IPL ROM'),
        ],
        notes:
            'Required for 64DD disk games in Mupen64Plus core. ✅ Available for automatic download.',
      ),

      // PlayStation Portable (PPSSPP core)
      BiosRequirement(
        platform: 'psp',
        displayName: 'PlayStation Portable',
        required: false,
        locations: [
          '~/.config/retroarch/system/PPSSPP/',
          '~/.config/ppsspp/PSP/SYSTEM/',
        ],
        files: [
          BiosFile(
            filename: 'ppge_atlas.zim',
            description: 'PPSSPP font atlas',
          ),
        ],
        notes:
            'Most games work without BIOS, but some require PSP firmware files. The ppge_atlas.zim font atlas is now available through the automatic download system.',
      ),

      // ScummVM
      BiosRequirement(
        platform: 'scummvm',
        displayName: 'ScummVM',
        required: false,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(
            filename: 'scummvm.zip',
            description: 'ScummVM game engine files and data',
          ),
        ],
        notes:
            'Optional. Contains additional game engine files and data for enhanced compatibility.',
      ),

      // Nintendo 3DS (Citra core)
      BiosRequirement(
        platform: '3ds',
        displayName: 'Nintendo 3DS',
        required: true,
        locations: [
          '~/.config/retroarch/system/citra/',
          '~/.local/share/citra-emu/sysdata/',
        ],
        files: [
          BiosFile(
            filename: 'aes_keys.txt',
            description: 'AES encryption keys',
          ),
          BiosFile(filename: 'seeddb.bin', description: 'Seed database'),
        ],
        notes:
            'Required for encrypted games. Place in citra/ subdirectory or Citra config.',
      ),

      // Atari 7800
      BiosRequirement(
        platform: 'atari7800',
        displayName: 'Atari 7800',
        required: false,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(
            filename: '7800 BIOS (U).rom',
            description: 'Atari 7800 BIOS',
          ),
        ],
        notes: 'Optional but improves compatibility with some games.',
      ),

      // Intellivision
      BiosRequirement(
        platform: 'intellivision',
        displayName: 'Intellivision',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(filename: 'exec.bin', description: 'Executive ROM'),
          BiosFile(filename: 'grom.bin', description: 'Graphics ROM'),
        ],
        notes: 'Both files required for FreeIntv core.',
      ),

      // ColecoVision
      BiosRequirement(
        platform: 'colecovision',
        displayName: 'ColecoVision',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(
            filename: 'colecovision.rom',
            description: 'ColecoVision BIOS',
          ),
        ],
        notes:
            'Required for BlueMSX and other cores. ✅ Available for automatic download.',
      ),

      // Vectrex
      BiosRequirement(
        platform: 'vectrex',
        displayName: 'Vectrex',
        required: false,
        locations: ['~/.config/retroarch/system/'],
        files: [BiosFile(filename: 'vectrex.rom', description: 'Vectrex BIOS')],
        notes: 'Optional for vecx core, improves accuracy.',
      ),

      // Lynx
      BiosRequirement(
        platform: 'lynx',
        displayName: 'Atari Lynx',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(filename: 'lynxboot.img', description: 'Lynx Boot ROM'),
        ],
        notes: 'Required for Handy and Beetle Lynx cores.',
      ),

      // WonderSwan / WonderSwan Color
      BiosRequirement(
        platform: 'wonderswan',
        displayName: 'WonderSwan',
        required: false,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(filename: 'boot.rom', description: 'WonderSwan boot ROM'),
        ],
        notes: 'Optional for Beetle Cygne core.',
      ),

      // PC-FX
      BiosRequirement(
        platform: 'pcfx',
        displayName: 'PC-FX',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(filename: 'pcfx.rom', description: 'PC-FX BIOS v1.00'),
        ],
        notes: 'Required for Beetle PC-FX core.',
      ),

      // PC Engine / TurboGrafx-16
      BiosRequirement(
        platform: 'pcengine',
        displayName: 'PC Engine / TurboGrafx-16',
        required: false,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(filename: 'syscard1.pce', description: 'System Card 1.0'),
          BiosFile(
            filename: 'syscard2.pce',
            description: 'System Card 2.0 JAP',
          ),
          BiosFile(
            filename: 'syscard2u.pce',
            description: 'System Card 2.0 USA',
          ),
          BiosFile(
            filename: 'syscard3.pce',
            description: 'System Card 3.0 JAP',
          ),
          BiosFile(
            filename: 'syscard3u.pce',
            description: 'System Card 3.0 USA',
          ),
          BiosFile(filename: 'gecard.pce', description: 'Games Express Card'),
          BiosFile(filename: 'gexpress.pce', description: 'Games Express BIOS'),
        ],
        notes:
            'System cards for PC Engine CD games. Required for proper CD-ROM support. ✅ Available for automatic download.',
      ),

      // SuperGrafx
      BiosRequirement(
        platform: 'supergrafx',
        displayName: 'SuperGrafx',
        required: false,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(
            filename: 'syscard3.pce',
            description: 'SuperGrafx System Card',
          ),
        ],
        notes: 'Optional, shares BIOS with PC Engine CD.',
      ),

      // Atari Jaguar
      BiosRequirement(
        platform: 'atarijaguar',
        displayName: 'Atari Jaguar',
        required: false,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(
            filename: 'virtualjaguar_bios.rom',
            description: 'Jaguar BIOS',
          ),
        ],
        notes: 'Optional for Virtual Jaguar core.',
      ),

      // 3DO (additional details)
      BiosRequirement(
        platform: '3do',
        displayName: '3DO Interactive',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(
            filename: 'panafz10.bin',
            description: 'Panasonic FZ-10 BIOS',
          ),
          BiosFile(filename: 'panafz1.bin', description: 'Panasonic FZ-1 BIOS'),
          BiosFile(filename: 'goldstar.bin', description: 'Goldstar BIOS'),
        ],
        notes: 'At least one 3DO BIOS required for Opera core.',
      ),

      // Nintendo GameCube / Wii
      BiosRequirement(
        platform: 'gamecube',
        displayName: 'Nintendo GameCube / Wii',
        required: false,
        locations: [
          '~/.config/retroarch/system/',
          '~/dolphin-emu/User/GC/USA/',
          '~/dolphin-emu/User/GC/EUR/',
          '~/dolphin-emu/User/GC/JAP/',
        ],
        files: [
          BiosFile(
            filename: 'IPL.bin',
            region: 'USA',
            description: 'GameCube BIOS (USA)',
          ),
          BiosFile(
            filename: 'IPL.bin',
            region: 'EUR',
            description: 'GameCube BIOS (EUR)',
          ),
          BiosFile(
            filename: 'IPL.bin',
            region: 'JAP',
            description: 'GameCube BIOS (JAP)',
          ),
        ],
        notes:
            'Optional for most games, but enables BIOS animation and required for specific titles like Star Fox Assault. Downloaded files must be renamed to IPL.bin and placed in respective region subdirectory (USA/, EUR/, JAP/).',
      ),

      // Nintendo Super Nintendo Entertainment System
      BiosRequirement(
        platform: 'snes',
        displayName: 'Nintendo Super Nintendo Entertainment System',
        required: false,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(
            filename: 'cx4.data.rom',
            description: 'CX4 chip data ROM (required for Mega Man X2/X3)',
          ),
          BiosFile(
            filename: 'dsp1.data.rom',
            description:
                'DSP1 chip data ROM (required for Pilotwings, Super Mario Kart)',
          ),
          BiosFile(
            filename: 'dsp1.program.rom',
            description: 'DSP1 chip program ROM',
          ),
          BiosFile(
            filename: 'dsp1b.data.rom',
            description: 'DSP1B chip data ROM (required for Ballz 3D)',
          ),
          BiosFile(
            filename: 'dsp1b.program.rom',
            description: 'DSP1B chip program ROM',
          ),
          BiosFile(
            filename: 'dsp2.data.rom',
            description: 'DSP2 chip data ROM (required for Dungeon Master)',
          ),
          BiosFile(
            filename: 'dsp2.program.rom',
            description: 'DSP2 chip program ROM',
          ),
          BiosFile(
            filename: 'dsp3.data.rom',
            description: 'DSP3 chip data ROM (required for SD Gundam GX)',
          ),
          BiosFile(
            filename: 'dsp3.program.rom',
            description: 'DSP3 chip program ROM',
          ),
          BiosFile(
            filename: 'dsp4.data.rom',
            description: 'DSP4 chip data ROM (required for Top Gear 3000)',
          ),
          BiosFile(
            filename: 'dsp4.program.rom',
            description: 'DSP4 chip program ROM',
          ),
          BiosFile(
            filename: 'st010.data.rom',
            description: 'ST010 chip data ROM (required for F1 ROC II)',
          ),
          BiosFile(
            filename: 'st010.program.rom',
            description: 'ST010 chip program ROM',
          ),
          BiosFile(
            filename: 'st011.data.rom',
            description:
                'ST011 chip data ROM (required for Hayazashi Nidan Morita Shogi)',
          ),
          BiosFile(
            filename: 'st011.program.rom',
            description: 'ST011 chip program ROM',
          ),
          BiosFile(
            filename: 'st018.data.rom',
            description:
                'ST018 chip data ROM (required for Hayazashi Nidan Morita Shogi 2)',
          ),
          BiosFile(
            filename: 'st018.program.rom',
            description: 'ST018 chip program ROM',
          ),
        ],
        notes:
            'Optional but required for specific games that use special chips. DSP chips for enhanced audio/processing, CX4 for Capcom games, ST chips for special applications.',
      ),

      // Sinclair ZX Spectrum
      BiosRequirement(
        platform: 'zxspectrum',
        displayName: 'Sinclair ZX Spectrum',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(filename: '48.rom', description: 'ZX Spectrum 48K ROM'),
          BiosFile(
            filename: '128-0.rom',
            description: 'ZX Spectrum 128K ROM 0',
          ),
          BiosFile(
            filename: '128-1.rom',
            description: 'ZX Spectrum 128K ROM 1',
          ),
          BiosFile(
            filename: 'plus2-0.rom',
            description: 'ZX Spectrum +2 ROM 0',
          ),
          BiosFile(
            filename: 'plus2-1.rom',
            description: 'ZX Spectrum +2 ROM 1',
          ),
          BiosFile(
            filename: 'plus3-0.rom',
            description: 'ZX Spectrum +3 ROM 0',
          ),
          BiosFile(
            filename: 'plus3-1.rom',
            description: 'ZX Spectrum +3 ROM 1',
          ),
          BiosFile(
            filename: 'plus3-2.rom',
            description: 'ZX Spectrum +3 ROM 2',
          ),
          BiosFile(
            filename: 'plus3-3.rom',
            description: 'ZX Spectrum +3 ROM 3',
          ),
          BiosFile(
            filename: '128-spanish-0.rom',
            description: 'ZX Spectrum 128K Spanish ROM 0',
          ),
          BiosFile(
            filename: '128-spanish-1.rom',
            description: 'ZX Spectrum 128K Spanish ROM 1',
          ),
        ],
        notes:
            'Different ROM sets for different ZX Spectrum models. 48K ROM for original, 128K ROMs for 128K model, Plus ROMs for +2/+3 models.',
      ),

      // Nintendo Super Game Boy
      BiosRequirement(
        platform: 'sgb',
        displayName: 'Nintendo Super Game Boy',
        required: false,
        locations: ['~/.config/retroarch/system/'],
        files: [
          BiosFile(
            filename: 'SGB1.sfc',
            description: 'Super Game Boy ROM v1 (required for SGB emulation)',
          ),
          BiosFile(
            filename: 'SGB2.sfc',
            description: 'Super Game Boy 2 ROM (improved version)',
          ),
          BiosFile(
            filename: 'sgb_bios.bin',
            description: 'Super Game Boy BIOS',
          ),
          BiosFile(
            filename: 'sgb2_boot.bin',
            description: 'Super Game Boy 2 Boot ROM',
          ),
        ],
        notes:
            'Required for Super Game Boy functionality in SNES emulators. SGB1.sfc is essential, SGB2.sfc provides enhanced features.',
      ),
    ];
  }
}
