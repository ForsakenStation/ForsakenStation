/// Represents a downloadable BIOS file with metadata from retroarch_system repo
class DownloadableBiosFile {
  final String filename;
  final String? expectedMd5;
  final String? expectedSha1;
  final int? expectedSize;
  final String? description;
  final String? region;
  final String? customBranch; // Support for alternative branches
  final String? customPath; // Support for direct system/ path
  final String?
  customRepository; // Support for external repositories (e.g., GitHub releases)
  final bool requiresExtraction; // ZIP/archive files that need extraction
  final List<String>? extractedFiles; // List of files to extract from archive
  final String? extractionPath; // Relative path within archive to extract from

  const DownloadableBiosFile({
    required this.filename,
    this.expectedMd5,
    this.expectedSha1,
    this.expectedSize,
    this.description,
    this.region,
    this.customBranch,
    this.customPath,
    this.customRepository,
    this.requiresExtraction = false,
    this.extractedFiles,
    this.extractionPath,
  });

  /// Generates the download URL for this file
  String getDownloadUrl(String repoFolder) {
    // Handle external repositories (e.g., GitHub releases)
    if (customRepository != null) {
      return customRepository!;
    }

    // Handle standard retroarch_system repository
    final branch = customBranch ?? 'libretro';
    const baseUrl = 'https://github.com/Abdess/retroarch_system/raw';

    if (customPath != null) {
      // Direct path (e.g., "system/filename.bin")
      final encodedPath = Uri.encodeComponent(customPath!);
      final encodedFilename = Uri.encodeComponent(filename);
      return '$baseUrl/$branch/$encodedPath/$encodedFilename';
    } else {
      // Standard folder structure
      final encodedFolder = Uri.encodeComponent(repoFolder);
      final encodedFilename = Uri.encodeComponent(filename);
      return '$baseUrl/$branch/$encodedFolder/$encodedFilename';
    }
  }
}

/// Maps platform IDs to their corresponding folders and files in retroarch_system repo
class BiosDownloadMapping {
  final String platformId;
  final String repoFolder;
  final List<DownloadableBiosFile> files;
  final bool available;

  const BiosDownloadMapping({
    required this.platformId,
    required this.repoFolder,
    required this.files,
    this.available = true,
  });

  /// Returns all download URLs for this platform
  List<String> getDownloadUrls() {
    return files.map((file) => file.getDownloadUrl(repoFolder)).toList();
  }

  /// Checks if a specific file is available for download
  bool hasFile(String filename) {
    return files.any((file) => file.filename == filename);
  }

  /// Gets the downloadable file info by filename
  DownloadableBiosFile? getFile(String filename) {
    try {
      return files.firstWhere((file) => file.filename == filename);
    } catch (_) {
      return null;
    }
  }

  /// All supported platform mappings
  static const List<BiosDownloadMapping> allMappings = [
    // Arcade (MAME/FinalBurn Neo)
    BiosDownloadMapping(
      platformId: 'arcade',
      repoFolder: 'Arcade',
      files: [
        DownloadableBiosFile(
          filename: 'airlbios.zip',
          expectedSize: 715730,
          description: 'Airline Pilots BIOS',
        ),
        DownloadableBiosFile(
          filename: 'awbios.zip',
          expectedSize: 42296,
          description: 'Atomiswave BIOS',
        ),
        DownloadableBiosFile(
          filename: 'bubsys.zip',
          expectedSize: 7950,
          description: 'Bubble System BIOS',
        ),
        DownloadableBiosFile(
          filename: 'cchip.zip',
          expectedSize: 2700,
          description: 'C-Chip BIOS',
        ),
        DownloadableBiosFile(
          filename: 'decocass.zip',
          expectedSize: 16107,
          description: 'DECO Cassette System BIOS',
        ),
        DownloadableBiosFile(
          filename: 'f355bios.zip',
          expectedSize: 1394278,
          description: 'Ferrari F355 Challenge BIOS',
        ),
        DownloadableBiosFile(
          filename: 'f355dlx.zip',
          expectedSize: 2328436,
          description: 'Ferrari F355 Challenge Deluxe BIOS',
        ),
        DownloadableBiosFile(
          filename: 'hod2bios.zip',
          expectedSize: 1479106,
          description: 'House of the Dead 2 BIOS',
        ),
        DownloadableBiosFile(
          filename: 'isgsm.zip',
          expectedSize: 10207,
          description: 'ISG Selection Master Type 2006 BIOS',
        ),
        DownloadableBiosFile(
          filename: 'midssio.zip',
          expectedSize: 163,
          description: 'Midway SSIO Sound Board BIOS',
        ),
        DownloadableBiosFile(
          filename: 'naomi.zip',
          expectedSize: 9321533,
          description: 'Naomi System BIOS',
        ),
        DownloadableBiosFile(
          filename: 'neogeo.zip',
          expectedSize: 1859335,
          description: 'Neo Geo BIOS',
        ),
        DownloadableBiosFile(
          filename: 'nmk004.zip',
          expectedSize: 3556,
          description: 'NMK004 MCU BIOS',
        ),
        DownloadableBiosFile(
          filename: 'pgm.zip',
          expectedSize: 2094636,
          description: 'PGM System BIOS',
        ),
        DownloadableBiosFile(
          filename: 'skns.zip',
          expectedSize: 924762,
          description: 'Super Kaneko Nova System BIOS',
        ),
        DownloadableBiosFile(
          filename: 'ym2608.zip',
          expectedSize: 7609,
          description: 'YM2608 ADPCM ROM',
        ),
      ],
    ),

    // Atari 400/800
    BiosDownloadMapping(
      platformId: 'atari800',
      repoFolder: 'Atari - 400-800',
      files: [
        DownloadableBiosFile(
          filename: 'ATARIXL.ROM',
          expectedSize: 16384,
          description: 'Atari XL/XE OS ROM',
        ),
        DownloadableBiosFile(
          filename: 'ATARIBAS.ROM',
          expectedSize: 8192,
          description: 'Atari BASIC ROM',
        ),
        DownloadableBiosFile(
          filename: 'ATARIOSA.ROM',
          expectedSize: 10240,
          description: 'Atari 400/800 OS-A ROM',
        ),
        DownloadableBiosFile(
          filename: 'ATARIOSB.ROM',
          expectedSize: 10240,
          description: 'Atari 400/800 OS-B ROM',
        ),
      ],
    ),

    // Atari ST
    BiosDownloadMapping(
      platformId: 'atarist',
      repoFolder: 'Atari - ST',
      files: [
        DownloadableBiosFile(
          filename: 'tos.img',
          expectedSize: 196608,
          description: 'Atari ST TOS ROM Image',
        ),
      ],
    ),

    // Phillips Videopac+
    BiosDownloadMapping(
      platformId: 'videopac',
      repoFolder: 'Phillips - Videopac+',
      files: [
        DownloadableBiosFile(
          filename: 'g7400.bin',
          expectedSize: 1024,
          description: 'Philips G7400 BIOS (Videopac+ G7400)',
        ),
        DownloadableBiosFile(
          filename: 'c52.bin',
          expectedSize: 1024,
          description: 'Philips C52 BIOS',
        ),
        DownloadableBiosFile(
          filename: 'jopac.bin',
          expectedSize: 1024,
          description: 'Jopac BIOS (French variant)',
        ),
      ],
    ),

    // Sharp X1
    BiosDownloadMapping(
      platformId: 'x1',
      repoFolder: 'Sharp - X1',
      files: [
        DownloadableBiosFile(
          filename: 'iplrom.x1',
          expectedSize: 4096,
          description: 'Sharp X1 IPL ROM',
        ),
        DownloadableBiosFile(
          filename: 'iplrom.x1t',
          expectedSize: 2048,
          description: 'Sharp X1 Turbo IPL ROM',
        ),
      ],
    ),

    // Sharp X68000
    BiosDownloadMapping(
      platformId: 'x68000',
      repoFolder: 'Sharp - X68000',
      files: [
        DownloadableBiosFile(
          filename: 'iplrom.dat',
          expectedSize: 131072,
          description: 'X68000 IPL ROM',
        ),
        DownloadableBiosFile(
          filename: 'iplrom30.dat',
          expectedSize: 131072,
          description: 'X68000 IPL ROM v3.0',
        ),
        DownloadableBiosFile(
          filename: 'iplromco.dat',
          expectedSize: 131072,
          description: 'X68000 IPL ROM (Compact)',
        ),
        DownloadableBiosFile(
          filename: 'iplromxv.dat',
          expectedSize: 131072,
          description: 'X68000 IPL ROM (XVI)',
        ),
        DownloadableBiosFile(
          filename: 'cgrom.dat',
          expectedSize: 786432,
          description: 'X68000 Character Generator ROM',
        ),
      ],
    ),

    // Sinclair ZX Spectrum
    BiosDownloadMapping(
      platformId: 'zxspectrum',
      repoFolder: 'Sinclair - ZX Spectrum',
      files: [
        // Core ROMs
        DownloadableBiosFile(
          filename: '48.rom',
          expectedSize: 16384,
          description: 'ZX Spectrum 48K ROM',
        ),
        DownloadableBiosFile(
          filename: '128-0.rom',
          expectedSize: 16384,
          description: 'ZX Spectrum 128K ROM 0',
        ),
        DownloadableBiosFile(
          filename: '128-1.rom',
          expectedSize: 16384,
          description: 'ZX Spectrum 128K ROM 1',
        ),
        DownloadableBiosFile(
          filename: 'plus2-0.rom',
          expectedSize: 16384,
          description: 'ZX Spectrum +2 ROM 0',
        ),
        DownloadableBiosFile(
          filename: 'plus2-1.rom',
          expectedSize: 16384,
          description: 'ZX Spectrum +2 ROM 1',
        ),
        DownloadableBiosFile(
          filename: 'plus3-0.rom',
          expectedSize: 16384,
          description: 'ZX Spectrum +3 ROM 0',
        ),
        DownloadableBiosFile(
          filename: 'plus3-1.rom',
          expectedSize: 16384,
          description: 'ZX Spectrum +3 ROM 1',
        ),
        DownloadableBiosFile(
          filename: 'plus3-2.rom',
          expectedSize: 16384,
          description: 'ZX Spectrum +3 ROM 2',
        ),
        DownloadableBiosFile(
          filename: 'plus3-3.rom',
          expectedSize: 16384,
          description: 'ZX Spectrum +3 ROM 3',
        ),
        // Spanish variants
        DownloadableBiosFile(
          filename: '128-spanish-0.rom',
          expectedSize: 16384,
          description: 'ZX Spectrum 128K Spanish ROM 0',
        ),
        DownloadableBiosFile(
          filename: '128-spanish-1.rom',
          expectedSize: 16384,
          description: 'ZX Spectrum 128K Spanish ROM 1',
        ),
      ],
    ),

    // Nintendo Super Nintendo Entertainment System
    BiosDownloadMapping(
      platformId: 'snes',
      repoFolder: 'Nintendo - Super Nintendo Entertainment System',
      files: [
        // CX4 chip
        DownloadableBiosFile(
          filename: 'cx4.data.rom',
          expectedSize: 3072,
          description: 'CX4 chip data ROM (Mega Man X2/X3)',
        ),
        // DSP1 chip
        DownloadableBiosFile(
          filename: 'dsp1.data.rom',
          expectedSize: 2048,
          description: 'DSP1 chip data ROM (Pilotwings, Super Mario Kart)',
        ),
        DownloadableBiosFile(
          filename: 'dsp1.program.rom',
          expectedSize: 6144,
          description: 'DSP1 chip program ROM',
        ),
        // DSP1B chip
        DownloadableBiosFile(
          filename: 'dsp1b.data.rom',
          expectedSize: 2048,
          description: 'DSP1B chip data ROM (Ballz 3D)',
        ),
        DownloadableBiosFile(
          filename: 'dsp1b.program.rom',
          expectedSize: 6144,
          description: 'DSP1B chip program ROM',
        ),
        // DSP2 chip
        DownloadableBiosFile(
          filename: 'dsp2.data.rom',
          expectedSize: 2048,
          description: 'DSP2 chip data ROM (Dungeon Master)',
        ),
        DownloadableBiosFile(
          filename: 'dsp2.program.rom',
          expectedSize: 6144,
          description: 'DSP2 chip program ROM',
        ),
        // DSP3 chip
        DownloadableBiosFile(
          filename: 'dsp3.data.rom',
          expectedSize: 2048,
          description: 'DSP3 chip data ROM (SD Gundam GX)',
        ),
        DownloadableBiosFile(
          filename: 'dsp3.program.rom',
          expectedSize: 6144,
          description: 'DSP3 chip program ROM',
        ),
        // DSP4 chip
        DownloadableBiosFile(
          filename: 'dsp4.data.rom',
          expectedSize: 2048,
          description: 'DSP4 chip data ROM (Top Gear 3000)',
        ),
        DownloadableBiosFile(
          filename: 'dsp4.program.rom',
          expectedSize: 6144,
          description: 'DSP4 chip program ROM',
        ),
        // ST010 chip
        DownloadableBiosFile(
          filename: 'st010.data.rom',
          expectedSize: 4096,
          description: 'ST010 chip data ROM (F1 ROC II)',
        ),
        DownloadableBiosFile(
          filename: 'st010.program.rom',
          expectedSize: 49152,
          description: 'ST010 chip program ROM',
        ),
        // ST011 chip
        DownloadableBiosFile(
          filename: 'st011.data.rom',
          expectedSize: 4096,
          description: 'ST011 chip data ROM (Hayazashi Nidan Morita Shogi)',
        ),
        DownloadableBiosFile(
          filename: 'st011.program.rom',
          expectedSize: 49152,
          description: 'ST011 chip program ROM',
        ),
        // ST018 chip
        DownloadableBiosFile(
          filename: 'st018.data.rom',
          expectedSize: 32768,
          description: 'ST018 chip data ROM (Hayazashi Nidan Morita Shogi 2)',
        ),
        DownloadableBiosFile(
          filename: 'st018.program.rom',
          expectedSize: 131072,
          description: 'ST018 chip program ROM',
        ),
      ],
    ),

    // Sega Mega Drive / Genesis
    BiosDownloadMapping(
      platformId: 'genesis',
      repoFolder: 'Sega - Mega Drive - Genesis',
      files: [
        DownloadableBiosFile(
          filename: 'bios_MD.bin',
          expectedSize: 2048,
          description: 'Sega Genesis/Mega Drive BIOS',
        ),
        DownloadableBiosFile(
          filename: 'areplay.bin',
          expectedSize: 32768,
          description: 'Action Replay cartridge ROM',
        ),
        DownloadableBiosFile(
          filename: 'ggenie.bin',
          expectedSize: 32768,
          description: 'Game Genie cartridge ROM',
        ),
        DownloadableBiosFile(
          filename: 'sk.bin',
          expectedSize: 2097152,
          description: 'Sonic & Knuckles lock-on cartridge ROM',
        ),
        DownloadableBiosFile(
          filename: 'sk2chip.bin',
          expectedSize: 262144,
          description: 'Sonic & Knuckles 2 chip ROM',
        ),
      ],
    ),

    // Apple Macintosh II
    BiosDownloadMapping(
      platformId: 'macii',
      repoFolder: 'MacII',
      files: [
        DownloadableBiosFile(
          filename: 'MacII.ROM',
          expectedSize: 262144,
          description: 'Macintosh II System ROM',
        ),
      ],
    ),

    // ScummVM Engine Files
    BiosDownloadMapping(
      platformId: 'scummvm',
      repoFolder: 'ScummVM',
      files: [
        DownloadableBiosFile(
          filename: 'scummvm.zip',
          description: 'ScummVM game engine files and data',
        ),
      ],
    ),

    // Sony PlayStation (Beetle PSX)
    BiosDownloadMapping(
      platformId: 'psx',
      repoFolder: 'Sony - PlayStation',
      files: [
        DownloadableBiosFile(
          filename: 'scph5500.bin',
          expectedSize: 524288,
          expectedMd5: '8dd7d5296a650fac7319bce665a6a53c',
          description: 'SCPH-5500 BIOS',
          region: 'JAP',
        ),
        DownloadableBiosFile(
          filename: 'scph5501.bin',
          expectedSize: 524288,
          expectedMd5: '490f666e1afb15b7362b406ed1cea246',
          description: 'SCPH-5501 BIOS',
          region: 'USA',
        ),
        DownloadableBiosFile(
          filename: 'scph5502.bin',
          expectedSize: 524288,
          expectedMd5: '32736f17079d0b2b7024407c39bd3050',
          description: 'SCPH-5502 BIOS',
          region: 'EUR',
        ),
        // Additional files from RetroArch branch system folder
        DownloadableBiosFile(
          filename: 'PSXONPSP660.BIN',
          expectedSize: 524288,
          description: 'PSX on PSP BIOS (extracted from PSP)',
          customBranch: 'Other',
          customPath: 'Sony - PlayStation',
        ),
        DownloadableBiosFile(
          filename: 'ps1_rom.bin',
          expectedSize: 524288,
          description: 'PS1 ROM BIOS (alternative)',
          customBranch: 'RetroArch',
          customPath: 'system',
        ),
      ],
    ),

    // Sony PlayStation (PCSX ReARMed)
    BiosDownloadMapping(
      platformId: 'psx_pcsx',
      repoFolder: 'Sony - PlayStation',
      files: [
        DownloadableBiosFile(
          filename: 'PSXONPSP660.BIN',
          expectedSize: 524288,
          description: 'PSX on PSP BIOS (extracted from PSP)',
          customBranch: 'Other',
          customPath: 'Sony - PlayStation',
        ),
        DownloadableBiosFile(
          filename: 'PSXONPSP660.BIN',
          expectedSize: 524288,
          description: 'PSX on PSP BIOS (extracted from PSP)',
          customBranch: 'Other',
          customPath: 'Sony - PlayStation',
          // expectedMd5: 'c53ca5908936d412331790f4426c6c33',
        ),
        DownloadableBiosFile(
          filename: 'scph101.bin',
          expectedMd5: '6E3735FF4C7DC899EE98981385F6F3D0',
          description: 'SCPH-101 BIOS v4.4 03/24/00 A',
          region: 'USA',
        ),
        DownloadableBiosFile(
          filename: 'scph7001.bin',
          expectedMd5: '1e68c231d0896b7eadcad1d7d8e76129',
          description: 'SCPH-7001 BIOS v4.1 12/16/97 A',
          region: 'USA',
        ),
        DownloadableBiosFile(
          filename: 'scph1001.bin',
          expectedMd5: '924e392ed05558ffdb115408c263dccf',
          description: 'SCPH-1001 BIOS v2.0 05/07/95 A',
          region: 'USA',
        ),
        // Include the standard BIOS files as well for compatibility
        DownloadableBiosFile(
          filename: 'scph5501.bin',
          expectedSize: 524288,
          expectedMd5: '490f666e1afb15b7362b406ed1cea246',
          description: 'SCPH-5501 BIOS',
          region: 'USA',
        ),
      ],
    ),

    // Sega Saturn
    BiosDownloadMapping(
      platformId: 'saturn',
      repoFolder: 'Sega - Saturn',
      files: [
        DownloadableBiosFile(
          filename: 'sega_101.bin',
          description: 'Saturn BIOS USA',
          region: 'USA',
        ),
        DownloadableBiosFile(
          filename: 'mpr-17933.bin',
          description: 'Saturn BIOS Japan',
          region: 'JAP',
        ),
        DownloadableBiosFile(
          filename: 'mpr-18811-mx.ic1',
          description: 'King of Fighters 95 ROM Cartridge',
          region: 'EUR',
        ),
        DownloadableBiosFile(
          filename: 'mpr-19367-mx.ic1',
          expectedMd5: '1cd19988d1d72a3e7caa0b73234c96b4',
          description: 'Ultraman ROM Cartridge',
          region: 'JAP',
        ),
        // Additional from RetroArch branch
        DownloadableBiosFile(
          filename: 'saturn_bios.bin',
          expectedSize: 524288,
          description: 'Saturn BIOS (RetroArch)',
          customBranch: 'RetroArch',
          customPath: 'system',
        ),
      ],
    ),

    // Sega Dreamcast
    BiosDownloadMapping(
      platformId: 'dreamcast',
      repoFolder: 'Sega - Dreamcast',
      files: [
        DownloadableBiosFile(
          filename: 'dc_boot.bin',
          description: 'Dreamcast boot ROM',
        ),
        DownloadableBiosFile(
          filename: 'dc_flash.bin',
          description: 'Dreamcast flash ROM',
        ),
      ],
    ),

    // Sega Game Gear
    BiosDownloadMapping(
      platformId: 'gamegear',
      repoFolder: 'Sega - Game Gear',
      files: [
        DownloadableBiosFile(
          filename: 'bios.gg',
          expectedSize: 1024,
          description: 'Game Gear BIOS',
        ),
      ],
    ),

    // Sega Master System
    BiosDownloadMapping(
      platformId: 'mastersystem',
      repoFolder: 'Sega - Master System - Mark III',
      files: [
        DownloadableBiosFile(
          filename: 'bios_U.sms',
          expectedSize: 8192,
          description: 'Master System BIOS USA',
          region: 'USA',
        ),
        DownloadableBiosFile(
          filename: 'bios_E.sms',
          expectedSize: 8192,
          description: 'Master System BIOS Europe',
          region: 'EUR',
        ),
        DownloadableBiosFile(
          filename: 'bios_J.sms',
          expectedSize: 8192,
          description: 'Master System BIOS Japan (Mark III)',
          region: 'JAP',
        ),
        DownloadableBiosFile(
          filename: 'bios.sms',
          expectedSize: 8192,
          description: 'Master System BIOS (generic)',
        ),
      ],
    ),

    // Sega CD
    BiosDownloadMapping(
      platformId: 'segacd',
      repoFolder: 'Sega - Mega CD - Sega CD',
      files: [
        DownloadableBiosFile(
          filename: 'bios_CD_U.bin',
          description: 'Sega CD BIOS USA',
          region: 'USA',
        ),
        DownloadableBiosFile(
          filename: 'bios_CD_E.bin',
          description: 'Sega CD BIOS Europe',
          region: 'EUR',
        ),
        DownloadableBiosFile(
          filename: 'bios_CD_J.bin',
          description: 'Mega CD BIOS Japan',
          region: 'JAP',
        ),
      ],
    ),

    // PC Engine CD
    BiosDownloadMapping(
      platformId: 'pcenginecd',
      repoFolder: 'NEC - PC Engine - TurboGrafx 16 - SuperGrafx',
      files: [
        DownloadableBiosFile(
          filename: 'syscard3.pce',
          expectedSize: 262144,
          expectedMd5: '38179df8f4ac870017db21ebcbf53114',
          description: 'PC Engine CD System Card v3',
        ),
        DownloadableBiosFile(
          filename: 'syscard2.pce',
          expectedSize: 262144,
          expectedMd5: '3cdd6614a918616bfc41c862e889dd79',
          description: 'PC Engine CD System Card v2',
        ),
        DownloadableBiosFile(
          filename: 'syscard1.pce',
          expectedSize: 262144,
          expectedMd5: '2b7ccb3d86baa18f6402c176f3065082',
          description: 'PC Engine CD System Card v1',
        ),
      ],
    ),

    // Nintendo DS
    BiosDownloadMapping(
      platformId: 'nds',
      repoFolder: 'Nintendo - Nintendo DS',
      files: [
        DownloadableBiosFile(
          filename: 'bios7.bin',
          expectedSize: 16384,
          expectedMd5: 'df692a80a5b1bc90728bc3dfc76cd948',
          description: 'ARM7 BIOS',
        ),
        DownloadableBiosFile(
          filename: 'bios9.bin',
          expectedSize: 4096,
          expectedMd5: 'a392174eb3e572fed6447e956bde4b25',
          description: 'ARM9 BIOS',
        ),
        DownloadableBiosFile(
          filename: 'firmware.bin',
          expectedSize: 262144,
          expectedMd5: 'e45033d9b0fa6b0de071292bba7c9d13',
          description: 'DS Firmware',
        ),
      ],
    ),

    // Nintendo Entertainment System
    BiosDownloadMapping(
      platformId: 'nes',
      repoFolder: 'Nintendo - Nintendo Entertainment System',
      files: [
        DownloadableBiosFile(
          filename: 'NstDatabase.xml',
          expectedSize: 982615,
          description: 'Nestopia game database',
        ),
      ],
    ),

    // Famicom Disk System
    BiosDownloadMapping(
      platformId: 'fds',
      repoFolder: 'Nintendo - Famicom Disk System',
      files: [
        DownloadableBiosFile(
          filename: 'disksys.rom',
          expectedSize: 8192,
          expectedMd5: 'ca30b50f880eb660a320674ed365ef7a',
          description: 'FDS BIOS',
        ),
      ],
    ),

    // Atari 5200
    BiosDownloadMapping(
      platformId: 'atari5200',
      repoFolder: 'Atari - 5200',
      files: [
        DownloadableBiosFile(
          filename: '5200.rom',
          expectedSize: 2048,
          expectedMd5: '281f20ea4320404ec820fb7ec0693b38',
          description: 'Atari 5200 BIOS',
        ),
      ],
    ),

    // Game Boy Advance
    BiosDownloadMapping(
      platformId: 'gba',
      repoFolder: 'Nintendo - Game Boy Advance',
      files: [
        DownloadableBiosFile(
          filename: 'gba_bios.bin',
          expectedSize: 16384,
          expectedMd5: 'a860e8c0b6d573d191e4ec7db1b1e4f6',
          description: 'GBA BIOS',
        ),
      ],
    ),

    // Magnavox Odyssey²
    BiosDownloadMapping(
      platformId: 'odyssey2',
      repoFolder: 'Magnavox - Odyssey2',
      files: [
        DownloadableBiosFile(
          filename: 'o2rom.bin',
          expectedSize: 1024,
          description: 'Odyssey² BIOS ROM',
        ),
      ],
    ),

    // MSX
    BiosDownloadMapping(
      platformId: 'msx',
      repoFolder: 'Microsoft - MSX',
      files: [
        DownloadableBiosFile(
          filename: 'MSX.ROM',
          expectedSize: 32768,
          expectedMd5: 'aa95aea2563cd5ec0a0919b44cc17d47',
          description: 'MSX BIOS',
        ),
        DownloadableBiosFile(
          filename: 'MSX2.ROM',
          expectedSize: 32768,
          expectedMd5: 'ec3a01c91f24fbddcbcab0ad301bc9ef',
          description: 'MSX2 BIOS',
        ),
        DownloadableBiosFile(
          filename: 'MSX2EXT.ROM',
          expectedSize: 16384,
          expectedMd5: '2183c2aff17cf4297bdb496de78c2e8a',
          description: 'MSX2 Extended BIOS',
        ),
        DownloadableBiosFile(
          filename: 'MSX2P.ROM',
          expectedSize: 32768,
          expectedMd5: '6d8c0ca64e726c82a4b726e9b01cdf1e',
          description: 'MSX2+ BIOS',
        ),
      ],
    ),

    // Amiga
    BiosDownloadMapping(
      platformId: 'amiga',
      repoFolder: 'Commodore - Amiga',
      files: [
        DownloadableBiosFile(
          filename: 'kick34005.A500',
          expectedSize: 262144,
          expectedMd5: '82a21c1890cae844b3df741f2762d48d',
          description: 'Kickstart 1.3 (A500)',
        ),
        DownloadableBiosFile(
          filename: 'kick40063.A600',
          expectedSize: 524288,
          expectedMd5: 'e40a5dfb3d017ba8779faba30cbd1c8e',
          description: 'Kickstart 3.1 (A600)',
        ),
        DownloadableBiosFile(
          filename: 'kick40068.A1200',
          expectedSize: 524288,
          expectedMd5: '646773759326fbac3b2311fd8c8793ee',
          description: 'Kickstart 3.1 (A1200)',
        ),

        // Capsimg library for IPF/copy-protected disk support
        DownloadableBiosFile(
          filename: 'Capsimg_for_Retroarch.zip',
          expectedSize: 1428207,
          expectedSha1:
              'f401d22e2432ff37541489c7291f8a5e34dfd9a48475337fe578ff653887d685', // Using SHA256 from GitHub
          description: 'Capsimg library for IPF files (copy-protected disks)',
          customRepository:
              'https://github.com/rsn8887/capsimg/releases/download/1.2/Capsimg_for_Retroarch.zip',
          requiresExtraction: true,
          extractedFiles: [
            'capsimg.so',
            'capsimg.dll',
            'libcapsimg.dylib',
          ], // Platform-specific files
        ),
      ],
    ),

    // Nintendo Pokemon Mini
    BiosDownloadMapping(
      platformId: 'pokemini',
      repoFolder: 'Nintendo - Pokemon Mini',
      files: [
        DownloadableBiosFile(
          filename: 'bios.min',
          expectedSize: 4096,
          description: 'Pokemon Mini BIOS',
        ),
      ],
    ),

    // NEC PC-98
    BiosDownloadMapping(
      platformId: 'pc98',
      repoFolder: 'NEC - PC-98',
      files: [
        DownloadableBiosFile(
          filename: 'bios.rom',
          expectedSize: 98304,
          description: 'PC-98 BIOS ROM',
        ),
        DownloadableBiosFile(
          filename: 'itf.rom',
          expectedSize: 32768,
          description: 'PC-98 ITF ROM',
        ),
        DownloadableBiosFile(
          filename: 'sound.rom',
          expectedSize: 16384,
          description: 'PC-98 Sound ROM',
        ),
        DownloadableBiosFile(
          filename: 'font.rom',
          expectedSize: 288768,
          description: 'PC-98 Font ROM',
        ),
        DownloadableBiosFile(
          filename: 'font.bmp',
          expectedSize: 524350,
          description: 'PC-98 Font Bitmap',
        ),
        DownloadableBiosFile(
          filename: '2608_bd.wav',
          expectedSize: 19192,
          description: 'YM2608 Bass Drum Sample',
        ),
        DownloadableBiosFile(
          filename: '2608_hh.wav',
          expectedSize: 36722,
          description: 'YM2608 Hi-Hat Sample',
        ),
        DownloadableBiosFile(
          filename: '2608_rim.wav',
          expectedSize: 5288,
          description: 'YM2608 Rim Shot Sample',
        ),
        DownloadableBiosFile(
          filename: '2608_sd.wav',
          expectedSize: 15558,
          description: 'YM2608 Snare Drum Sample',
        ),
        DownloadableBiosFile(
          filename: '2608_tom.wav',
          expectedSize: 23092,
          description: 'YM2608 Tom Sample',
        ),
        DownloadableBiosFile(
          filename: '2608_top.wav',
          expectedSize: 57016,
          description: 'YM2608 Top Cymbal Sample',
        ),
      ],
    ),

    // Neo Geo
    BiosDownloadMapping(
      platformId: 'neogeo',
      repoFolder: 'SNK - NeoGeo CD',
      available: false, // Archive ZIP files need special handling
      files: [],
    ),

    // Fairchild Channel F
    BiosDownloadMapping(
      platformId: 'channelf',
      repoFolder: 'Fairchild Channel F',
      files: [
        DownloadableBiosFile(
          filename: 'sl31253.bin',
          expectedSize: 1024,
          description: 'Channel F System ROM (SL31253)',
        ),
        DownloadableBiosFile(
          filename: 'sl31254.bin',
          expectedSize: 1024,
          description: 'Channel F System ROM (SL31254)',
        ),
        DownloadableBiosFile(
          filename: 'sl90025.bin',
          expectedSize: 1024,
          description: 'Channel F System ROM (SL90025)',
        ),
      ],
    ),

    // Game Boy
    BiosDownloadMapping(
      platformId: 'gb',
      repoFolder: 'Nintendo - Gameboy',
      files: [
        DownloadableBiosFile(
          filename: 'dmg_boot.bin',
          expectedSize: 256,
          description: 'Game Boy Boot ROM (DMG)',
        ),
        DownloadableBiosFile(
          filename: 'gb_bios.bin',
          expectedSize: 256,
          description: 'Game Boy BIOS',
        ),
        // Additional from RetroArch branch
        DownloadableBiosFile(
          filename: 'gb_bios.bin',
          expectedSize: 256,
          description: 'Game Boy BIOS (RetroArch)',
          customBranch: 'RetroArch',
          customPath: 'system',
        ),
      ],
    ),

    // Game Boy Color
    BiosDownloadMapping(
      platformId: 'gbc',
      repoFolder: 'Nintendo - Gameboy Color',
      files: [
        DownloadableBiosFile(
          filename: 'gbc_bios.bin',
          expectedSize: 2304,
          expectedMd5: 'dbfce9db9deaa2567f6a84fde55f9680',
          description: 'GBC BIOS',
        ),
        // Additional from RetroArch branch
        DownloadableBiosFile(
          filename: 'gbc_bios.bin',
          expectedSize: 2304,
          description: 'GBC BIOS (RetroArch)',
          customBranch: 'RetroArch',
          customPath: 'system',
        ),
      ],
    ),

    // Nintendo 64DD
    BiosDownloadMapping(
      platformId: 'n64dd',
      repoFolder: 'Nintendo - Nintendo 64DD',
      files: [
        DownloadableBiosFile(
          filename: '64DD_IPL.bin',
          expectedSize: 4194304,
          expectedMd5: '8d3d9f294b6e174bc7b1d2fd1c727530',
          description: '64DD IPL ROM',
        ),
      ],
    ),

    // Atari 7800
    BiosDownloadMapping(
      platformId: 'atari7800',
      repoFolder: 'Atari - 7800',
      files: [
        DownloadableBiosFile(
          filename: '7800 BIOS (U).rom',
          expectedSize: 4096,
          expectedMd5: '0763f1ffb006ddbe32e52d497ee848ae',
          description: 'Atari 7800 BIOS USA',
        ),
      ],
    ),

    // Intellivision
    BiosDownloadMapping(
      platformId: 'intellivision',
      repoFolder: 'Mattel - Intellivision',
      files: [
        DownloadableBiosFile(
          filename: 'exec.bin',
          expectedSize: 8192,
          expectedMd5: '62e761035cb657903761800f4437b8af',
          description: 'Executive ROM',
        ),
        DownloadableBiosFile(
          filename: 'grom.bin',
          expectedSize: 2048,
          expectedMd5: '0cd5946c6473e42e8e4c2137785e427f',
          description: 'Graphics ROM',
        ),
      ],
    ),

    // ColecoVision
    BiosDownloadMapping(
      platformId: 'colecovision',
      repoFolder: 'Coleco - ColecoVision',
      files: [
        DownloadableBiosFile(
          filename: 'colecovision.rom',
          expectedSize: 8192,
          expectedMd5: '2c66f5911e5b42b8ebe113403548eee7',
          description: 'ColecoVision BIOS',
        ),
      ],
    ),

    // Atari Lynx
    BiosDownloadMapping(
      platformId: 'lynx',
      repoFolder: 'Atari - Lynx',
      files: [
        DownloadableBiosFile(
          filename: 'lynxboot.img',
          expectedSize: 512,
          expectedMd5: 'fcd403db69f54290b51035d82f835e7b',
          description: 'Lynx Boot ROM',
        ),
      ],
    ),

    // PC-FX
    BiosDownloadMapping(
      platformId: 'pcfx',
      repoFolder: 'NEC - PC-FX',
      files: [
        DownloadableBiosFile(
          filename: 'pcfx.rom',
          expectedSize: 1048576,
          expectedMd5: '08e36edbea28a017f79f8d4f7ff9b6d7',
          description: 'PC-FX BIOS v1.00',
        ),
      ],
    ),

    // PC Engine / TurboGrafx-16
    BiosDownloadMapping(
      platformId: 'pcengine',
      repoFolder: 'NEC - PC Engine - TurboGrafx 16 - SuperGrafx',
      files: [
        DownloadableBiosFile(
          filename: 'gecard.pce',
          expectedSize: 32768,
          description: 'Games Express Card',
        ),
        DownloadableBiosFile(
          filename: 'gexpress.pce',
          expectedSize: 32768,
          description: 'Games Express BIOS',
        ),
        DownloadableBiosFile(
          filename: 'syscard1.pce',
          expectedSize: 262144,
          description: 'System Card 1.0',
        ),
        DownloadableBiosFile(
          filename: 'syscard2.pce',
          expectedSize: 262144,
          description: 'System Card 2.0 JAP',
        ),
        DownloadableBiosFile(
          filename: 'syscard2u.pce',
          expectedSize: 262144,
          description: 'System Card 2.0 USA',
        ),
        DownloadableBiosFile(
          filename: 'syscard3.pce',
          expectedSize: 262144,
          description: 'System Card 3.0 JAP',
        ),
        DownloadableBiosFile(
          filename: 'syscard3u.pce',
          expectedSize: 262144,
          description: 'System Card 3.0 USA',
        ),
      ],
    ),

    // Nintendo GameCube
    BiosDownloadMapping(
      platformId: 'gamecube',
      repoFolder: 'Nintendo - GameCube',
      files: [
        DownloadableBiosFile(
          filename: 'gc-ntsc-12.bin',
          expectedSize: 2097152,
          description: 'GameCube BIOS NTSC v1.2 (USA)',
          region: 'USA',
        ),
        DownloadableBiosFile(
          filename: 'gc-ntsc-11.bin',
          expectedSize: 2097152,
          description: 'GameCube BIOS NTSC v1.1 (USA)',
          region: 'USA',
        ),
        DownloadableBiosFile(
          filename: 'gc-ntsc-10.bin',
          expectedSize: 2097152,
          description: 'GameCube BIOS NTSC v1.0 (USA)',
          region: 'USA',
        ),
        DownloadableBiosFile(
          filename: 'gc-pal-12.bin',
          expectedSize: 2097152,
          description: 'GameCube BIOS PAL v1.2 (EUR)',
          region: 'EUR',
        ),
        DownloadableBiosFile(
          filename: 'gc-pal-11.bin',
          expectedSize: 2097152,
          description: 'GameCube BIOS PAL v1.1 (EUR)',
          region: 'EUR',
        ),
        DownloadableBiosFile(
          filename: 'gc-pal-10.bin',
          expectedSize: 2097152,
          description: 'GameCube BIOS PAL v1.0 (EUR)',
          region: 'EUR',
        ),
      ],
    ),

    // 3DO
    BiosDownloadMapping(
      platformId: '3do',
      repoFolder: '3DO Company, The - 3DO',
      files: [
        DownloadableBiosFile(
          filename: 'panafz10.bin',
          expectedSize: 1048576,
          expectedMd5: '51f2f43ae2f3508a14d9f56597e2d3ce',
          description: 'Panasonic FZ-10 BIOS',
        ),
        DownloadableBiosFile(
          filename: 'panafz1.bin',
          expectedSize: 1048576,
          expectedMd5: 'f47264dd47fe30f73ab3c010015c155b',
          description: 'Panasonic FZ-1 BIOS',
        ),
        DownloadableBiosFile(
          filename: 'goldstar.bin',
          expectedSize: 1048576,
          expectedMd5: '8639fd5e549bd6238cfee79e3e749114',
          description: 'Goldstar BIOS',
        ),
        // Additional from RetroArch branch
        DownloadableBiosFile(
          filename: '3do_arcade_saot.bin',
          expectedSize: 524288,
          description: '3DO Arcade Shoot About Time BIOS',
          customBranch: 'RetroArch',
          customPath: 'system',
        ),
      ],
    ),

    // Sony PlayStation 2
    BiosDownloadMapping(
      platformId: 'ps2',
      repoFolder: '', // Empty because we use customPath
      files: [
        // Main BIOS files (4MB each)
        DownloadableBiosFile(
          filename: 'SCPH-10000.bin',
          expectedSize: 4194304,
          description: 'PS2 BIOS v1.00 JAP (original launch)',
          region: 'JAP',
          customBranch: 'Other',
          customPath: 'Sony - PlayStation 2',
        ),
        DownloadableBiosFile(
          filename: 'SCPH-30004R.bin',
          expectedSize: 4194304,
          description: 'PS2 BIOS v1.60 EUR',
          region: 'EUR',
          customBranch: 'Other',
          customPath: 'Sony - PlayStation 2',
        ),
        DownloadableBiosFile(
          filename: 'SCPH-39001.bin',
          expectedSize: 4194304,
          description: 'PS2 BIOS v1.60 USA',
          region: 'USA',
          customBranch: 'Other',
          customPath: 'Sony - PlayStation 2',
        ),
        DownloadableBiosFile(
          filename: 'SCPH-70004.BIN',
          expectedSize: 4194304,
          description: 'PS2 BIOS v2.20 EUR (slimline)',
          region: 'EUR',
          customBranch: 'Other',
          customPath: 'Sony - PlayStation 2',
        ),
        // NVM files (system configuration)
        DownloadableBiosFile(
          filename: 'SCPH-10000.NVM',
          expectedSize: 1024,
          description: 'PS2 NVRAM configuration (SCPH-10000)',
          customBranch: 'Other',
          customPath: 'Sony - PlayStation 2',
        ),
        DownloadableBiosFile(
          filename: 'SCPH-30004R.NVM',
          expectedSize: 1024,
          description: 'PS2 NVRAM configuration (SCPH-30004R)',
          customBranch: 'Other',
          customPath: 'Sony - PlayStation 2',
        ),
        DownloadableBiosFile(
          filename: 'SCPH-39001.NVM',
          expectedSize: 1024,
          description: 'PS2 NVRAM configuration (SCPH-39001)',
          customBranch: 'Other',
          customPath: 'Sony - PlayStation 2',
        ),
        DownloadableBiosFile(
          filename: 'SCPH-70004.NVM',
          expectedSize: 1024,
          description: 'PS2 NVRAM configuration (SCPH-70004)',
          customBranch: 'Other',
          customPath: 'Sony - PlayStation 2',
        ),
        // ROM files
        DownloadableBiosFile(
          filename: 'ROM2.BIN',
          expectedSize: 8192,
          description: 'PS2 DVD Player ROM',
          customBranch: 'Other',
          customPath: 'Sony - PlayStation 2',
        ),
        DownloadableBiosFile(
          filename: 'rom1.bin',
          expectedSize: 199680,
          description: 'PS2 ROM1 (boot ROM)',
          customBranch: 'Other',
          customPath: 'Sony - PlayStation 2',
        ),
        DownloadableBiosFile(
          filename: 'SCPH-70004.ROM1',
          expectedSize: 524288,
          description: 'PS2 ROM1 (SCPH-70004)',
          customBranch: 'Other',
          customPath: 'Sony - PlayStation 2',
        ),
        DownloadableBiosFile(
          filename: 'SCPH-70004.ROM2',
          expectedSize: 524288,
          description: 'PS2 ROM2 (SCPH-70004)',
          customBranch: 'Other',
          customPath: 'Sony - PlayStation 2',
        ),
        DownloadableBiosFile(
          filename: 'SCPH-70004.EROM',
          expectedSize: 3145728,
          description: 'PS2 Extended ROM (SCPH-70004)',
          customBranch: 'Other',
          customPath: 'Sony - PlayStation 2',
        ),
      ],
    ),

    // Nintendo Super Game Boy
    BiosDownloadMapping(
      platformId: 'sgb',
      repoFolder: '', // Direct system folder access
      files: [
        DownloadableBiosFile(
          filename: 'SGB1.sfc',
          expectedSize: 262144,
          description: 'Super Game Boy ROM v1',
          customBranch: 'RetroArch',
          customPath: 'system',
        ),
        DownloadableBiosFile(
          filename: 'SGB2.sfc',
          expectedSize: 524288,
          description: 'Super Game Boy 2 ROM',
          customBranch: 'RetroArch',
          customPath: 'system',
        ),
        DownloadableBiosFile(
          filename: 'sgb_bios.bin',
          expectedSize: 256,
          description: 'Super Game Boy BIOS',
          customBranch: 'RetroArch',
          customPath: 'system',
        ),
        DownloadableBiosFile(
          filename: 'sgb2_boot.bin',
          expectedSize: 256,
          description: 'Super Game Boy 2 Boot ROM',
          customBranch: 'RetroArch',
          customPath: 'system',
        ),
      ],
    ),

    // Sony PlayStation Portable (PSP)
    BiosDownloadMapping(
      platformId: 'psp',
      repoFolder: 'Sony - PlayStation Portable',
      files: [
        DownloadableBiosFile(
          filename: 'ppge_atlas.zim',
          expectedSize: 666530,
          description: 'PPSSPP font atlas for improved text rendering',
        ),
      ],
    ),
  ];

  /// Gets mapping for a specific platform ID
  static BiosDownloadMapping? getMapping(String platformId) {
    try {
      return allMappings.firstWhere(
        (mapping) => mapping.platformId == platformId,
      );
    } catch (_) {
      return null;
    }
  }

  /// Gets all available mappings (excludes unavailable ones)
  static List<BiosDownloadMapping> getAvailableMappings() {
    return allMappings.where((mapping) => mapping.available).toList();
  }

  /// Gets all platform IDs that have downloadable BIOS
  static List<String> getSupportedPlatforms() {
    return allMappings
        .where((mapping) => mapping.available)
        .map((mapping) => mapping.platformId)
        .toList();
  }
}
