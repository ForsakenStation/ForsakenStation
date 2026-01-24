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
      // PlayStation 1
      BiosRequirement(
        platform: 'psx',
        displayName: 'PlayStation 1',
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
            'At least one region BIOS required. DuckStation also checks ~/.local/share/duckstation/bios/',
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
            'Various BIOS versions work. Place in RetroArch system dir or PCSX2 bios dir.',
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
            description: 'Saturn BIOS Europe',
          ),
        ],
        notes: 'At least one region BIOS required for proper compatibility.',
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
            filename: 'kick33180.A500',
            description: 'Kickstart 1.2 (A500)',
          ),
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
        ],
        notes:
            'Different Kickstart ROMs for different Amiga models. At least one required.',
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
        notes: 'At least one CD-i BIOS required.',
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

      // Game Boy Color (optional)
      BiosRequirement(
        platform: 'gbc',
        displayName: 'Game Boy Color',
        required: false,
        locations: ['~/.config/retroarch/system/'],
        files: [BiosFile(filename: 'gbc_bios.bin', description: 'GBC BIOS')],
        notes: 'Optional but improves accuracy in some cores.',
      ),

      // Nintendo 64DD
      BiosRequirement(
        platform: 'n64dd',
        displayName: 'Nintendo 64DD',
        required: true,
        locations: ['~/.config/retroarch/system/'],
        files: [BiosFile(filename: 'IPL.n64', description: '64DD IPL ROM')],
        notes: 'Required for 64DD disk games in Mupen64Plus core.',
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
            'Most games work without BIOS, but some require PSP firmware files.',
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
          BiosFile(filename: 'coleco.rom', description: 'ColecoVision BIOS'),
        ],
        notes: 'Required for BlueMSX and other cores.',
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
    ];
  }
}
