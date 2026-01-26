/// Represents a downloadable BIOS file with metadata from retroarch_system repo
class DownloadableBiosFile {
  final String filename;
  final String? expectedMd5;
  final String? expectedSha1;
  final String? expectedCrc32; // CRC32 checksum for additional verification
  final int? expectedSize;
  final double sizeTolerance; // Allow size variance percentage (0.0 to 1.0)
  final String? description;
  final String? region;
  final String? customBranch; // Support for alternative branches
  final String? customPath; // Support for direct system/ path
  final String?
  customRepository; // Support for external repositories (e.g., GitHub releases)
  final bool requiresExtraction; // ZIP/archive files that need extraction
  final List<String>? extractedFiles; // List of files to extract from archive
  final String? extractionPath; // Relative path within archive to extract from
  final bool
  isOptional; // Mark as optional/extra file (not required for basic functionality)
  final String?
  category; // Optional category for grouping (e.g., "regional", "enhancement", "alternative")

  const DownloadableBiosFile({
    required this.filename,
    this.expectedMd5,
    this.expectedSha1,
    this.expectedCrc32,
    this.expectedSize,
    this.sizeTolerance = 0.0, // Default: exact size match required
    this.description,
    this.region,
    this.customBranch,
    this.customPath,
    this.customRepository,
    this.requiresExtraction = false,
    this.extractedFiles,
    this.extractionPath,
    this.isOptional = false,
    this.category,
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

        // Archive.org massive Arcade collection (496.2MB)
        DownloadableBiosFile(
          filename: 'Arcade (FinalBurn Neo).zip',
          expectedSize: 520503501, // 496.2MB - MASSIVE arcade BIOS collection
          description:
              'Complete Arcade BIOS Collection - FinalBurn Neo (Archive.org)',
          customRepository:
              'https://archive.org/download/RetroarchSystemFiles/Retroarch-System/Arcade%20(FinalBurn%20Neo).zip',
          requiresExtraction: true,
          extractedFiles: [
            // Note: This collection contains 100+ arcade BIOS files
            // Including all the individual files listed above plus many more
            'neogeo.zip',
            'airlbios.zip',
            'awbios.zip',
            'bubsys.zip',
            'cchip.zip',
            'decocass.zip',
            'f355bios.zip',
            'f355dlx.zip',
            'hod2bios.zip',
            'isgsm.zip',
            'midssio.zip',
            'nmk004.zip',
            'pgm.zip',
            'skns.zip',
            'ym2608.zip',
            // Plus many more arcade system BIOS files...
          ],
          category: 'archive_collection',
          isOptional:
              true, // Alternative to individual files - WARNING: Large download!
          sizeTolerance:
              0.1, // Allow 10% variance due to compression differences
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

        // Archive.org comprehensive Atari ST/STE/TT/Falcon collection (9.3MB)
        DownloadableBiosFile(
          filename: 'Atari - ST-STE-TT-Falcon (Hatari).zip',
          expectedSize: 9748480, // 9.3MB
          description:
              'Complete Atari ST/STE/TT/Falcon BIOS Collection - Hatari (Archive.org)',
          customRepository:
              'https://archive.org/download/RetroarchSystemFiles/Retroarch-System/Atari%20-%20ST-STE-TT-Falcon%20(Hatari).zip',
          requiresExtraction: true,
          extractedFiles: [
            'tos.img',
            'tos100.img', // TOS 1.00
            'tos102.img', // TOS 1.02
            'tos104.img', // TOS 1.04
            'tos162.img', // TOS 1.62
            'tos206.img', // TOS 2.06
            'tos306.img', // TOS 3.06
            'tos404.img', // TOS 4.04 (TT)
            'falcon_tos.img', // Falcon TOS
          ],
          category: 'archive_collection',
          isOptional: true, // Alternative to individual files
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

        // Additional BIOS from RetroPieBios repository
        DownloadableBiosFile(
          filename: 'scph1001.bin',
          expectedSize: 524288,
          description: 'SCPH-1001 BIOS (USA, v2.2)',
          region: 'USA',
          customRepository:
              'https://raw.githubusercontent.com/PIBSAS/RetroPieBios/master/BIOS/scph1001.bin',
        ),
        DownloadableBiosFile(
          filename: 'scph7001.bin',
          expectedSize: 524288,
          description: 'SCPH-7001 BIOS (USA, v4.1)',
          region: 'USA',
          customRepository:
              'https://raw.githubusercontent.com/PIBSAS/RetroPieBios/master/BIOS/scph7001.bin',
        ),
        DownloadableBiosFile(
          filename: 'scph101.bin',
          expectedSize: 524288,
          description: 'SCPH-101 BIOS (USA, PSone)',
          region: 'USA',
          customRepository:
              'https://raw.githubusercontent.com/PIBSAS/RetroPieBios/master/BIOS/scph101.bin',
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
          expectedSize: 524288,
          expectedSha1: '85ec9ca47d8f6807718151cbcca8b964cd8d6280',
          description: 'Saturn BIOS USA',
          region: 'USA',
        ),
        DownloadableBiosFile(
          filename: 'mpr-17933.bin',
          expectedSize: 524288,
          expectedSha1: '3240872c70984b6cbfda1586cab68dbc694d1408',
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
        // Alternative from RetroPieBios (optional backup source)
        DownloadableBiosFile(
          filename: 'saturn_bios.bin',
          expectedSize: 524288,
          description: 'Saturn BIOS (Alternative)',
          isOptional: true,
          category: 'alternative',
          customRepository:
              'https://raw.githubusercontent.com/PIBSAS/RetroPieBios/master/roms/saturn/saturn_bios.bin',
        ),

        // Archive.org comprehensive Saturn collections
        DownloadableBiosFile(
          filename: 'Sega - Saturn (Beetle Saturn).zip',
          expectedSize: 4927421, // 4.7MB
          description:
              'Complete Saturn BIOS Collection - Beetle Saturn (Archive.org)',
          customRepository:
              'https://archive.org/download/RetroarchSystemFiles/Retroarch-System/Sega%20-%20Saturn%20(Beetle%20Saturn).zip',
          requiresExtraction: true,
          extractedFiles: [
            'sega_101.bin',
            'mpr-17933.bin',
            'mpr-18811-mx.ic1',
            'mpr-19367-mx.ic1',
          ],
          category: 'archive_collection',
          isOptional: true, // Alternative to individual files
        ),
        DownloadableBiosFile(
          filename: 'Sega - Saturn (YabaSanshiro - Yabause).zip',
          expectedSize: 456628, // 445KB
          description:
              'Saturn BIOS Collection - Yabause/YabaSanshiro (Archive.org)',
          customRepository:
              'https://archive.org/download/RetroarchSystemFiles/Retroarch-System/Sega%20-%20Saturn%20(YabaSanshiro%20-%20Yabause).zip',
          requiresExtraction: true,
          extractedFiles: ['saturn_bios.bin'],
          category: 'archive_collection',
          isOptional: true, // Alternative source
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

        // Alternative source from RetroPieBios
        DownloadableBiosFile(
          filename: 'bios.gg',
          expectedSize: 1024,
          description: 'Game Gear BIOS (RetroPieBios)',
          customRepository:
              'https://raw.githubusercontent.com/PIBSAS/RetroPieBios/master/BIOS/bios.gg',
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

        // Archive.org comprehensive PC Engine CD collection (445KB)
        DownloadableBiosFile(
          filename:
              'NEC - PC Engine - SuperGrafx - CD (Beetle PCE - PCE Fast - SGX).zip',
          expectedSize: 455782, // 445KB
          description:
              'Complete PC Engine CD System Card Collection (Archive.org)',
          customRepository:
              'https://archive.org/download/RetroarchSystemFiles/Retroarch-System/NEC%20-%20PC%20Engine%20-%20SuperGrafx%20-%20CD%20(Beetle%20PCE%20-%20PCE%20Fast%20-%20SGX).zip',
          requiresExtraction: true,
          extractedFiles: [
            'syscard1.pce',
            'syscard2.pce',
            'syscard3.pce',
            'gecard.pce',
            'gexpress.pce',
          ],
          category: 'archive_collection',
          isOptional: true, // Alternative to individual files
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
        // Alternative from RetroPieBios
        DownloadableBiosFile(
          filename: '5200.rom',
          expectedSize: 2048,
          description: 'Atari 5200 BIOS (Alternative)',
          isOptional: true,
          category: 'alternative',
          customRepository:
              'https://raw.githubusercontent.com/PIBSAS/RetroPieBios/master/roms/atari5200/5200.rom',
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
          expectedSha1: 'fd2547724b505f487e6dcb29ec2ecff3af35a841',
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

    // Sony MSX Computers
    BiosDownloadMapping(
      platformId: 'msx_sony',
      repoFolder: 'Sony - MSX',
      files: [
        // Sony HB Series MSX1
        DownloadableBiosFile(
          filename: 'hb10.rom',
          expectedSize: 32768,
          description: 'Sony HB-10 BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hb20p.rom',
          expectedSize: 32768,
          description: 'Sony HB-20P BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hb55.rom',
          expectedSize: 32768,
          description: 'Sony HB-55 BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hb75.rom',
          expectedSize: 32768,
          description: 'Sony HB-75 BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hb101.rom',
          expectedSize: 32768,
          description: 'Sony HB-101 BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hb201.rom',
          expectedSize: 32768,
          description: 'Sony HB-201 BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hb501p.rom',
          expectedSize: 32768,
          description: 'Sony HB-501P BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hb701fd.rom',
          expectedSize: 32768,
          description: 'Sony HB-701FD BIOS (MSX1 with Disk)',
          region: 'JAP',
          category: 'machine_specific',
        ),

        // Sony HB Series MSX2
        DownloadableBiosFile(
          filename: 'hbf1.rom',
          expectedSize: 32768,
          description: 'Sony HB-F1 BIOS (MSX2)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hbf1ii.rom',
          expectedSize: 32768,
          description: 'Sony HB-F1II BIOS (MSX2)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hbf1xd.rom',
          expectedSize: 49152,
          description: 'Sony HB-F1XD BIOS + Disk ROM (MSX2)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hbf500.rom',
          expectedSize: 32768,
          description: 'Sony HB-F500 BIOS (MSX2)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hbf700.rom',
          expectedSize: 49152,
          description: 'Sony HB-F700 BIOS + Disk ROM (MSX2)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hbf900.rom',
          expectedSize: 32768,
          description: 'Sony HB-F900 BIOS (MSX2)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hbf9p.rom',
          expectedSize: 32768,
          description: 'Sony HB-F9P BIOS (MSX2)',
          region: 'JAP',
          category: 'machine_specific',
        ),

        // Sony MSX2+ Models
        DownloadableBiosFile(
          filename: 'hbf1xdj.rom',
          expectedSize: 49152,
          description: 'Sony HB-F1XDJ BIOS + Disk ROM (MSX2+)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hbf1xv.rom',
          expectedSize: 32768,
          description: 'Sony HB-F1XV BIOS (MSX2+)',
          region: 'JAP',
          category: 'machine_specific',
        ),
      ],
    ),

    // Panasonic/National MSX Computers
    BiosDownloadMapping(
      platformId: 'msx_panasonic',
      repoFolder: 'Panasonic - MSX',
      files: [
        // Panasonic CF Series (MSX1)
        DownloadableBiosFile(
          filename: 'cf2000.rom',
          expectedSize: 32768,
          description: 'Panasonic CF-2000 BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'cf2700.rom',
          expectedSize: 32768,
          description: 'Panasonic CF-2700 BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'cf3000.rom',
          expectedSize: 32768,
          description: 'Panasonic CF-3000 BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'cf3300.rom',
          expectedSize: 32768,
          description: 'Panasonic CF-3300 BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),

        // National FS Series (MSX1)
        DownloadableBiosFile(
          filename: 'fs1300.rom',
          expectedSize: 32768,
          description: 'National FS-1300 BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'fs4000.rom',
          expectedSize: 32768,
          description: 'National FS-4000 BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),

        // Panasonic FS Series (MSX2)
        DownloadableBiosFile(
          filename: 'fs4500.rom',
          expectedSize: 49152,
          description: 'Panasonic FS-4500 BIOS + MSX-DOS (MSX2)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'fs4600.rom',
          expectedSize: 49152,
          description: 'Panasonic FS-4600 BIOS + MSX-DOS (MSX2)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'fs4700.rom',
          expectedSize: 49152,
          description: 'Panasonic FS-4700 BIOS + MSX-DOS (MSX2)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'fs5500f1.rom',
          expectedSize: 49152,
          description: 'Panasonic FS-5500F1 BIOS + MSX-DOS (MSX2)',
          region: 'JAP',
          category: 'machine_specific',
        ),

        // Panasonic A1 Series (MSX2/MSX2+)
        DownloadableBiosFile(
          filename: 'fsa1.rom',
          expectedSize: 32768,
          description: 'Panasonic FS-A1 BIOS (MSX2)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'fsa1mk2.rom',
          expectedSize: 32768,
          description: 'Panasonic FS-A1MK2 BIOS (MSX2)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'fsa1f.rom',
          expectedSize: 49152,
          description: 'Panasonic FS-A1F BIOS + Disk ROM (MSX2)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'fsa1fm.rom',
          expectedSize: 49152,
          description: 'Panasonic FS-A1FM BIOS + Disk ROM (MSX2)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'fsa1fx.rom',
          expectedSize: 32768,
          description: 'Panasonic FS-A1FX BIOS (MSX2+)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'fsa1wx.rom',
          expectedSize: 32768,
          description: 'Panasonic FS-A1WX BIOS (MSX2+)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'fsa1wsx.rom',
          expectedSize: 49152,
          description: 'Panasonic FS-A1WSX BIOS + Kanji ROM (MSX2+)',
          region: 'JAP',
          category: 'machine_specific',
        ),

        // MSX TurboR
        DownloadableBiosFile(
          filename: 'fsa1st.rom',
          expectedSize: 65536,
          description: 'Panasonic FS-A1ST BIOS (MSX TurboR)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'fsa1gt.rom',
          expectedSize: 65536,
          description: 'Panasonic FS-A1GT BIOS (MSX TurboR)',
          region: 'JAP',
          category: 'machine_specific',
        ),
      ],
    ),

    // Philips MSX Computers
    BiosDownloadMapping(
      platformId: 'msx_philips',
      repoFolder: 'Philips - MSX',
      files: [
        // Philips VG Series (MSX1)
        DownloadableBiosFile(
          filename: 'vg8000.rom',
          expectedSize: 32768,
          description: 'Philips VG-8000 BIOS (MSX1)',
          region: 'EUR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'vg8010.rom',
          expectedSize: 32768,
          description: 'Philips VG-8010 BIOS (MSX1)',
          region: 'EUR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'vg8020.rom',
          expectedSize: 32768,
          description: 'Philips VG-8020 BIOS (MSX1)',
          region: 'EUR',
          category: 'machine_specific',
        ),

        // Philips VG Series (MSX2)
        DownloadableBiosFile(
          filename: 'vg8220.rom',
          expectedSize: 32768,
          description: 'Philips VG-8220 BIOS (MSX2)',
          region: 'EUR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'vg8230.rom',
          expectedSize: 32768,
          description: 'Philips VG-8230 BIOS (MSX2)',
          region: 'EUR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'vg8235.rom',
          expectedSize: 32768,
          description: 'Philips VG-8235 BIOS (MSX2)',
          region: 'EUR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'vg8240.rom',
          expectedSize: 49152,
          description: 'Philips VG-8240 BIOS + Disk ROM (MSX2)',
          region: 'EUR',
          category: 'machine_specific',
        ),

        // Philips NMS Series (MSX2)
        DownloadableBiosFile(
          filename: 'nms8220.rom',
          expectedSize: 32768,
          description: 'Philips NMS-8220 BIOS (MSX2)',
          region: 'EUR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'nms8245.rom',
          expectedSize: 49152,
          description: 'Philips NMS-8245 BIOS + Disk ROM (MSX2)',
          region: 'EUR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'nms8250.rom',
          expectedSize: 49152,
          description: 'Philips NMS-8250 BIOS + Disk ROM (MSX2)',
          region: 'EUR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'nms8255.rom',
          expectedSize: 49152,
          description: 'Philips NMS-8255 BIOS + Disk ROM (MSX2)',
          region: 'EUR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'nms8280.rom',
          expectedSize: 65536,
          description: 'Philips NMS-8280 BIOS + Enhanced features (MSX2)',
          region: 'EUR',
          category: 'machine_specific',
        ),
      ],
    ),

    // Toshiba MSX Computers (Pasopia IQ Series)
    BiosDownloadMapping(
      platformId: 'msx_toshiba',
      repoFolder: 'Toshiba - MSX',
      files: [
        // Toshiba HX Series (MSX1)
        DownloadableBiosFile(
          filename: 'hx10.rom',
          expectedSize: 32768,
          description: 'Toshiba HX-10 BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hx10s.rom',
          expectedSize: 32768,
          description: 'Toshiba HX-10S BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hx10dp.rom',
          expectedSize: 49152,
          description: 'Toshiba HX-10DP BIOS + Disk ROM (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hx20.rom',
          expectedSize: 32768,
          description: 'Toshiba HX-20 BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hx21.rom',
          expectedSize: 32768,
          description: 'Toshiba HX-21 BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hx22.rom',
          expectedSize: 32768,
          description: 'Toshiba HX-22 BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hx32.rom',
          expectedSize: 32768,
          description: 'Toshiba HX-32 BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hx51.rom',
          expectedSize: 32768,
          description: 'Toshiba HX-51 BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),

        // Toshiba HX Series (MSX2)
        DownloadableBiosFile(
          filename: 'hx23.rom',
          expectedSize: 32768,
          description: 'Toshiba HX-23 BIOS (MSX2)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hx33.rom',
          expectedSize: 32768,
          description: 'Toshiba HX-33 BIOS (MSX2)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hx34.rom',
          expectedSize: 49152,
          description: 'Toshiba HX-34 BIOS + Disk ROM (MSX2)',
          region: 'JAP',
          category: 'machine_specific',
        ),
      ],
    ),

    // Yamaha MSX Computers
    BiosDownloadMapping(
      platformId: 'msx_yamaha',
      repoFolder: 'Yamaha - MSX',
      files: [
        // Yamaha CX5M Music Computer Series
        DownloadableBiosFile(
          filename: 'cx5m.rom',
          expectedSize: 32768,
          description: 'Yamaha CX5M BIOS (MSX1 Music Computer)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'cx5.rom',
          expectedSize: 32768,
          description: 'Yamaha CX-5 BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'yjs503.rom',
          expectedSize: 32768,
          description: 'Yamaha YJS-503 BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'yjs503ii.rom',
          expectedSize: 32768,
          description: 'Yamaha YJS-503II BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'yjs503iir.rom',
          expectedSize: 32768,
          description: 'Yamaha YJS-503IIR BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'cxs2.rom',
          expectedSize: 32768,
          description: 'Yamaha CXS-II/128 BIOS (MSX1)',
          region: 'JAP',
          category: 'machine_specific',
        ),

        // Yamaha AX Series (MSX1)
        DownloadableBiosFile(
          filename: 'ax150.rom',
          expectedSize: 32768,
          description: 'Yamaha AX-150 BIOS (MSX1)',
          region: 'EUR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'ax170.rom',
          expectedSize: 32768,
          description: 'Yamaha AX-170 BIOS (MSX1)',
          region: 'EUR',
          category: 'machine_specific',
        ),

        // Yamaha YIS and AX Series (MSX2)
        DownloadableBiosFile(
          filename: 'ax350.rom',
          expectedSize: 32768,
          description: 'Yamaha AX-350 BIOS (MSX2)',
          region: 'EUR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'ax500.rom',
          expectedSize: 32768,
          description: 'Yamaha AX-500 BIOS (MSX2)',
          region: 'EUR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'yis503iiir.rom',
          expectedSize: 32768,
          description: 'Yamaha YIS-503IIIR BIOS (MSX2)',
          region: 'JAP',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'yis805r2.rom',
          expectedSize: 49152,
          description: 'Yamaha YIS-805/128R2 BIOS + Extensions (MSX2)',
          region: 'JAP',
          category: 'machine_specific',
        ),
      ],
    ),

    // European MSX Computers
    BiosDownloadMapping(
      platformId: 'msx_european',
      repoFolder: 'European - MSX',
      files: [
        // Canon MSX Computers
        DownloadableBiosFile(
          filename: 'canonv8.rom',
          expectedSize: 32768,
          description: 'Canon V-8 BIOS (MSX1)',
          region: 'EUR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'canonv10.rom',
          expectedSize: 32768,
          description: 'Canon V-10 BIOS (MSX1)',
          region: 'EUR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'canonv20.rom',
          expectedSize: 32768,
          description: 'Canon V-20 BIOS (MSX1)',
          region: 'EUR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'canonv25.rom',
          expectedSize: 32768,
          description: 'Canon V-25 BIOS (MSX2)',
          region: 'EUR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'canonv30.rom',
          expectedSize: 32768,
          description: 'Canon V-30 BIOS (MSX2)',
          region: 'EUR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'canonv35.rom',
          expectedSize: 49152,
          description: 'Canon V-35 BIOS + Disk ROM (MSX2)',
          region: 'EUR',
          category: 'machine_specific',
        ),

        // Spectravideo MSX Computers
        DownloadableBiosFile(
          filename: 'svi728.rom',
          expectedSize: 32768,
          description: 'Spectravideo SVI-728 BIOS (MSX1)',
          region: 'EUR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'svi738.rom',
          expectedSize: 49152,
          description: 'Spectravideo SVI-738 BIOS + Disk ROM (MSX1)',
          region: 'EUR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'svi838.rom',
          expectedSize: 32768,
          description: 'Spectravideo SVI-838 BIOS (MSX2)',
          region: 'EUR',
          category: 'machine_specific',
        ),

        // Dragon Data MSX
        DownloadableBiosFile(
          filename: 'dragonmsx.rom',
          expectedSize: 32768,
          description: 'Dragon MSX BIOS (MSX1)',
          region: 'EUR',
          category: 'machine_specific',
        ),
      ],
    ),

    // Korean MSX Computers (Daewoo/Samsung)
    BiosDownloadMapping(
      platformId: 'msx_korean',
      repoFolder: 'Korean - MSX',
      files: [
        // Daewoo MSX Systems
        DownloadableBiosFile(
          filename: 'cpc300.rom',
          expectedSize: 32768,
          description: 'Daewoo CPC-300 BIOS (MSX1)',
          region: 'KOR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'dpc100.rom',
          expectedSize: 32768,
          description: 'Daewoo IQ-1000 DPC-100 BIOS (MSX1)',
          region: 'KOR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'dpc180.rom',
          expectedSize: 32768,
          description: 'Daewoo IQ-1000 DPC-180 BIOS (MSX1)',
          region: 'KOR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'dpc200.rom',
          expectedSize: 32768,
          description: 'Daewoo IQ-1000 DPC-200 BIOS (MSX1)',
          region: 'KOR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'iq2000.rom',
          expectedSize: 32768,
          description: 'Daewoo IQ-2000 CPC-300 BIOS (MSX2)',
          region: 'KOR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'cpc400.rom',
          expectedSize: 32768,
          description: 'Daewoo X-II CPC-400 BIOS (MSX2)',
          region: 'KOR',
          category: 'machine_specific',
        ),

        // Zemmix Series (Korean MSX clones)
        DownloadableBiosFile(
          filename: 'zemmix.rom',
          expectedSize: 32768,
          description: 'Zemmix BIOS (MSX1 Compatible)',
          region: 'KOR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'zemmixv.rom',
          expectedSize: 32768,
          description: 'Zemmix V BIOS (MSX1 Compatible)',
          region: 'KOR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'zemmixsv.rom',
          expectedSize: 32768,
          description: 'Zemmix Super V BIOS (MSX2 Compatible)',
          region: 'KOR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'zemmixturbo.rom',
          expectedSize: 32768,
          description: 'Zemmix Turbo BIOS (MSX2+ Compatible)',
          region: 'KOR',
          category: 'machine_specific',
        ),

        // Samsung/GoldStar MSX
        DownloadableBiosFile(
          filename: 'spc800.rom',
          expectedSize: 32768,
          description: 'Samsung SPC-800 BIOS (MSX1)',
          region: 'KOR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'fc80.rom',
          expectedSize: 32768,
          description: 'GoldStar FC-80 BIOS (MSX1)',
          region: 'KOR',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'gfc1080.rom',
          expectedSize: 32768,
          description: 'GoldStar GFC-1080 BIOS (MSX1)',
          region: 'KOR',
          category: 'machine_specific',
        ),
      ],
    ),

    // Arabic MSX Computers (Al Alamia Sakhr)
    BiosDownloadMapping(
      platformId: 'msx_arabic',
      repoFolder: 'Arabic - MSX',
      files: [
        DownloadableBiosFile(
          filename: 'sakhrax100.rom',
          expectedSize: 32768,
          description: 'Al Alamia Sakhr AX-100 BIOS (MSX1)',
          region: 'ARA',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'sakhrax170.rom',
          expectedSize: 32768,
          description: 'Al Alamia Sakhr AX-170 BIOS (MSX1)',
          region: 'ARA',
          category: 'machine_specific',
        ),
      ],
    ),

    // Brazilian MSX Computers
    BiosDownloadMapping(
      platformId: 'msx_brazilian',
      repoFolder: 'Brazilian - MSX',
      files: [
        // Gradiente Expert Series
        DownloadableBiosFile(
          filename: 'expert.rom',
          expectedSize: 32768,
          description: 'Gradiente Expert BIOS (MSX1)',
          region: 'BRA',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'expertdd.rom',
          expectedSize: 49152,
          description: 'Gradiente Expert DD Plus BIOS + Disk ROM (MSX1)',
          region: 'BRA',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'expertplus.rom',
          expectedSize: 32768,
          description: 'Gradiente Expert Plus BIOS (MSX1)',
          region: 'BRA',
          category: 'machine_specific',
        ),

        // Sharp/Epcom Hotbit Series
        DownloadableBiosFile(
          filename: 'hotbit11.rom',
          expectedSize: 32768,
          description: 'Sharp Hotbit 1.1 BIOS (MSX1)',
          region: 'BRA',
          category: 'machine_specific',
        ),
        DownloadableBiosFile(
          filename: 'hotbit12.rom',
          expectedSize: 32768,
          description: 'Sharp Hotbit 1.2 BIOS (MSX1)',
          region: 'BRA',
          category: 'machine_specific',
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

        // Archive.org comprehensive Commodore Amiga collection (3.1MB)
        DownloadableBiosFile(
          filename: 'Commodore - Amiga (PUAE).zip',
          expectedSize: 3250176, // 3.1MB
          description:
              'Complete Commodore Amiga BIOS Collection - PUAE (Archive.org)',
          customRepository:
              'https://archive.org/download/RetroarchSystemFiles/Retroarch-System/Commodore%20-%20Amiga%20(PUAE).zip',
          requiresExtraction: true,
          extractedFiles: [
            'kick34005.A500', // Kickstart 1.3 (A500)
            'kick40063.A600', // Kickstart 3.1 (A600)
            'kick40068.A1200', // Kickstart 3.1 (A1200)
            'kick31.A500', // Kickstart 1.2/1.3 variants
            'kick20.A500', // Kickstart 2.0
            'kick30.A500', // Kickstart 3.0
            'kick13.A500', // Additional Kickstart variants
            // Plus additional Kickstart ROMs for various Amiga models
          ],
          category: 'archive_collection',
          isOptional: true, // Alternative to individual files
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
      ],
    ),

    // Neo Geo
    BiosDownloadMapping(
      platformId: 'neogeo',
      repoFolder: 'SNK - NeoGeo CD',
      available: true, // Now available from RetroPieBios
      files: [
        // Neo Geo CD BIOS files from RetroPieBios
        DownloadableBiosFile(
          filename: 'ng-lo.rom',
          expectedSize: 65536,
          description: 'Neo Geo CD Low ROM',
          customRepository:
              'https://raw.githubusercontent.com/PIBSAS/RetroPieBios/master/BIOS/neocd/ng-lo.rom',
        ),
        DownloadableBiosFile(
          filename: 'neocd.bin',
          expectedSize: 524288,
          description: 'Neo Geo CD BIOS',
          customRepository:
              'https://raw.githubusercontent.com/PIBSAS/RetroPieBios/master/BIOS/neocd/neocd.bin',
        ),
        DownloadableBiosFile(
          filename: 'front-sp1.bin',
          expectedSize: 524288, // 512KB - actual RetroPieBios file size
          description: 'Neo Geo CD Front SP1',
          customRepository:
              'https://raw.githubusercontent.com/PIBSAS/RetroPieBios/master/BIOS/neocd/front-sp1.bin',
        ),
        DownloadableBiosFile(
          filename: 'top-sp1.bin',
          expectedSize: 524288, // 512KB - actual RetroPieBios file size
          description: 'Neo Geo CD Top SP1',
          customRepository:
              'https://raw.githubusercontent.com/PIBSAS/RetroPieBios/master/BIOS/neocd/top-sp1.bin',
        ),
        // Neo Geo arcade BIOS (ZIP format)
        DownloadableBiosFile(
          filename: 'neogeo.zip',
          expectedSize: 1917592,
          description: 'Neo Geo Arcade BIOS (complete set)',
          customRepository:
              'https://raw.githubusercontent.com/PIBSAS/RetroPieBios/master/roms/neogeo/neogeo.zip',
        ),

        // Archive.org comprehensive Neo Geo CD collection (2.1MB)
        DownloadableBiosFile(
          filename: 'SNK - Neo Geo CD (NeoCD).zip',
          expectedSize: 2202009, // 2.1MB
          description: 'Complete Neo Geo CD BIOS Collection (Archive.org)',
          customRepository:
              'https://archive.org/download/RetroarchSystemFiles/Retroarch-System/SNK%20-%20Neo%20Geo%20CD%20(NeoCD).zip',
          requiresExtraction: true,
          extractedFiles: [
            'neocd.bin',
            'ng-lo.rom',
            'front-sp1.bin',
            'top-sp1.bin',
          ],
          category: 'archive_collection',
          isOptional: true, // Alternative to individual files
        ),
      ],
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

        // Alternative source from RetroPieBios
        DownloadableBiosFile(
          filename: 'gb_bios.bin',
          expectedSize: 256,
          description: 'Game Boy BIOS (RetroPieBios)',
          customRepository:
              'https://raw.githubusercontent.com/PIBSAS/RetroPieBios/master/BIOS/gb_bios.bin',
          isOptional: true,
          category: 'alternative',
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

        // Alternative source from RetroPieBios
        DownloadableBiosFile(
          filename: 'gbc_bios.bin',
          expectedSize: 2304,
          description: 'GBC BIOS (RetroPieBios)',
          customRepository:
              'https://raw.githubusercontent.com/PIBSAS/RetroPieBios/master/BIOS/gbc_bios.bin',
          isOptional: true,
          category: 'alternative',
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

        // Alternative source from RetroPieBios
        DownloadableBiosFile(
          filename: 'lynxboot.img',
          expectedSize: 512,
          description: 'Lynx Boot ROM (RetroPieBios)',
          customRepository:
              'https://raw.githubusercontent.com/PIBSAS/RetroPieBios/master/BIOS/lynxboot.img',
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
        // Alternative from RetroPieBios (backup source)
        DownloadableBiosFile(
          filename: 'pcfx.rom',
          expectedSize: 1048576,
          description: 'PC-FX BIOS v1.00 (Alternative)',
          isOptional: true,
          category: 'alternative',
          customRepository:
              'https://raw.githubusercontent.com/PIBSAS/RetroPieBios/master/roms/pcfx/pcfx.rom',
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

        // Archive.org comprehensive GameCube/Wii collection (7.4MB)
        DownloadableBiosFile(
          filename: 'Nintendo - GameCube - Wii (Dolphin).zip',
          expectedSize: 7759667, // 7.4MB
          description:
              'Complete GameCube/Wii BIOS Collection - Dolphin (Archive.org)',
          customRepository:
              'https://archive.org/download/RetroarchSystemFiles/Retroarch-System/Nintendo%20-%20GameCube%20-%20Wii%20(Dolphin).zip',
          requiresExtraction: true,
          extractedFiles: [
            'gc-ntsc-12.bin',
            'gc-ntsc-11.bin',
            'gc-ntsc-10.bin',
            'gc-pal-12.bin',
            'gc-pal-11.bin',
            'gc-pal-10.bin',
          ],
          category: 'archive_collection',
          isOptional: true, // Alternative to individual files
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

        // Additional BIOS variants from RetroPieBios
        DownloadableBiosFile(
          filename: 'panafz1j.bin',
          expectedSize: 1048576,
          description: 'Panasonic FZ-1J BIOS (Japanese)',
          region: 'JAP',
          customRepository:
              'https://raw.githubusercontent.com/PIBSAS/RetroPieBios/master/BIOS/panafz1j.bin',
        ),
        DownloadableBiosFile(
          filename: 'panafz10e-anvil.bin',
          expectedSize: 1048576,
          description: 'Panasonic FZ-10E Anvil BIOS (European)',
          region: 'EUR',
          customRepository:
              'https://raw.githubusercontent.com/PIBSAS/RetroPieBios/master/BIOS/panafz10e-anvil.bin',
        ),
        DownloadableBiosFile(
          filename: 'sanyotry.bin',
          expectedSize: 1048576,
          description: 'Sanyo TRY BIOS',
          customRepository:
              'https://raw.githubusercontent.com/PIBSAS/RetroPieBios/master/BIOS/sanyotry.bin',
        ),

        // Archive.org comprehensive 3DO collection (6.9MB)
        DownloadableBiosFile(
          filename: '3DO Company, The - 3DO (Opera).zip',
          expectedSize: 7225344, // 6.9MB
          description: 'Complete 3DO Opera BIOS Collection (Archive.org)',
          customRepository:
              'https://archive.org/download/RetroarchSystemFiles/Retroarch-System/3DO%20Company,%20The%20-%203DO%20(Opera).zip',
          requiresExtraction: true,
          extractedFiles: [
            'panafz10.bin',
            'panafz1.bin',
            'goldstar.bin',
            'sanyotry.bin',
            'panafz1j.bin',
            'panafz10e-anvil.bin',
          ],
          category: 'archive_collection',
          isOptional: true, // Alternative to individual files
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

        // Archive.org comprehensive PlayStation 2 collection (11.9MB)
        DownloadableBiosFile(
          filename: 'Sony - PlayStation 2 (LRPS2).zip',
          expectedSize: 12482764, // 11.9MB
          description: 'Complete PlayStation 2 BIOS Collection (Archive.org)',
          customRepository:
              'https://archive.org/download/RetroarchSystemFiles/Retroarch-System/Sony%20-%20PlayStation%202%20(LRPS2).zip',
          requiresExtraction: true,
          extractedFiles: [
            'SCPH-10000.bin',
            'SCPH-30004R.bin',
            'SCPH-39001.bin',
            'SCPH-70004.BIN',
            'SCPH-10000.NVM',
            'SCPH-30004R.NVM',
            'SCPH-39001.NVM',
            'SCPH-70004.NVM',
            'ROM2.BIN',
            'rom1.bin',
            'SCPH-70004.ROM1',
            'SCPH-70004.ROM2',
            'SCPH-70004.EROM',
          ],
          category: 'archive_collection',
          isOptional: true, // Alternative to individual files
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

        // Alternative source from RetroPieBios
        DownloadableBiosFile(
          filename: 'sgb_bios.bin',
          expectedSize: 256,
          description: 'Super Game Boy BIOS (RetroPieBios)',
          customRepository:
              'https://raw.githubusercontent.com/PIBSAS/RetroPieBios/master/BIOS/sgb_bios.bin',
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

    // Philips CD-i
    BiosDownloadMapping(
      platformId: 'cdi',
      repoFolder: 'Philips - CD-i',
      available: true, // Now available from archive.org
      files: [
        // Main CD-i BIOS files (required - any one will work)
        DownloadableBiosFile(
          filename: 'cdi200.rom',
          expectedSize: 524288, // 512KB
          description: 'CD-i 200 BIOS',
          customRepository:
              'https://archive.org/download/philips-cd-i-misc-bios/cdi200.rom',
        ),
        DownloadableBiosFile(
          filename: 'cdi220.rom',
          expectedSize: 524288, // 512KB
          description: 'CD-i 220 BIOS',
          customRepository:
              'https://archive.org/download/philips-cd-i-misc-bios/cdi220.rom',
        ),
        DownloadableBiosFile(
          filename: 'cdi220b.rom',
          expectedSize: 524288, // 512KB
          description: 'CD-i 220 BIOS (alternative)',
          customRepository:
              'https://archive.org/download/philips-cd-i-misc-bios/cdi220b.rom',
        ),
        // Optional files for enhanced compatibility
        DownloadableBiosFile(
          filename: 'cdi200a.rom',
          expectedSize: 524288, // 512KB
          description: 'CD-i 200A BIOS (alternative)',
          isOptional: true,
          category: 'regional',
          customRepository:
              'https://archive.org/download/philips-cd-i-misc-bios/cdi200/cdi200a.rom',
        ),
        DownloadableBiosFile(
          filename: 'vmpega.rom',
          expectedSize: 262144, // 256KB
          description: 'CD-i Video MPEG decoder ROM',
          isOptional: true,
          category: 'enhancement',
          customRepository:
              'https://archive.org/download/philips-cd-i-misc-bios/cdi200/vmpega.rom',
        ),
        DownloadableBiosFile(
          filename: 'xmpegx.rom',
          expectedSize: 124, // 124 bytes
          description: 'CD-i Digital Video Cartridge ROM (dummy)',
          isOptional: true,
          category: 'enhancement',
          customRepository:
              'https://archive.org/download/philips-cd-i-misc-bios/xmpegx.rom',
        ),
      ],
    ),

    // Nintendo 3DS
    BiosDownloadMapping(
      platformId: '3ds',
      repoFolder: 'Nintendo - 3DS',
      available: true, // Now available from archive.org
      files: [
        // Main system files (extracted from ZIP archive)
        DownloadableBiosFile(
          filename: 'Nintendo - 3DS (Citra).zip',
          expectedSize: 6815744, // 6.5MB (approximate)
          description: 'Nintendo 3DS Complete System Files (Citra)',
          requiresExtraction: true,
          extractedFiles: [
            'aes_keys.txt',
            'boot9.bin',
            'boot11.bin',
            'seeddb.bin',
            'dspfirm.cdc',
            'shared_font.bin',
          ],
          extractionPath: 'user_directory/sysdata/',
          customRepository:
              'https://archive.org/download/Nintendo-3DS-BIOS-DSP-Aes-Keys-SeedDB-Font/Nintendo%20-%203DS%20%28Citra%29.zip',
        ),

        // Alternative Archive.org source (RetroarchSystemFiles collection)
        DownloadableBiosFile(
          filename: 'Nintendo - 3DS (Citra) - RetroarchSystemFiles.zip',
          expectedSize: 6815744, // 6.5MB
          description:
              'Nintendo 3DS System Files - RetroarchSystemFiles (Archive.org)',
          requiresExtraction: true,
          extractedFiles: [
            'aes_keys.txt',
            'boot9.bin',
            'boot11.bin',
            'seeddb.bin',
            'dspfirm.cdc',
            'shared_font.bin',
          ],
          customRepository:
              'https://archive.org/download/RetroarchSystemFiles/Retroarch-System/Nintendo%20-%203DS%20(Citra).zip',
          category: 'alternative',
          isOptional: true, // Alternative source
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
