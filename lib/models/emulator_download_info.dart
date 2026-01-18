import 'dart:io';

/// Platform-specific download information for an emulator
class EmulatorDownloadInfo {
  final String name;
  final String displayName;
  final String description;
  final Map<String, PlatformDownload> downloads;
  final bool requiresExtraction;
  final String? extractedFileName;
  final String? finalFileName;
  final Map<String, List<String>>? postDownloadCommands;
  final bool isRetroArchCore;

  EmulatorDownloadInfo({
    required this.name,
    required this.displayName,
    required this.description,
    required this.downloads,
    this.requiresExtraction = false,
    this.extractedFileName,
    this.finalFileName,
    this.postDownloadCommands,
    this.isRetroArchCore = false,
  });

  /// Get download info for current platform
  PlatformDownload? getDownloadForCurrentPlatform() {
    if (Platform.isLinux) {
      return downloads['linux'];
    } else if (Platform.isMacOS) {
      return downloads['macos'];
    } else if (Platform.isWindows) {
      return downloads['windows'];
    }
    return null;
  }

  /// Get post-download commands for current platform
  List<String>? getPostDownloadCommandsForCurrentPlatform() {
    if (postDownloadCommands == null) return null;

    if (Platform.isLinux) {
      return postDownloadCommands!['linux'];
    } else if (Platform.isMacOS) {
      return postDownloadCommands!['macos'];
    } else if (Platform.isWindows) {
      return postDownloadCommands!['windows'];
    }
    return null;
  }

  /// Check if emulator is available for current platform
  bool isAvailableForCurrentPlatform() {
    return getDownloadForCurrentPlatform() != null;
  }
}

/// Platform-specific download details
class PlatformDownload {
  final String url;
  final String fileName;
  final String? sha256;
  final int? estimatedSizeMB;

  PlatformDownload({
    required this.url,
    required this.fileName,
    this.sha256,
    this.estimatedSizeMB,
  });
}

/// List of all available emulators for download
class EmulatorCatalog {
  static final List<EmulatorDownloadInfo> emulators = [
    // RetroArch
    EmulatorDownloadInfo(
      name: 'retroarch',
      displayName: 'RetroArch',
      description: 'Multi-platform emulator frontend (cores included)',
      downloads: {
        'linux': PlatformDownload(
          url:
              'https://buildbot.libretro.com/nightly/linux/x86_64/RetroArch.7z',
          fileName: 'RetroArch.7z',
          estimatedSizeMB: 50,
        ),
        'windows': PlatformDownload(
          url:
              'https://buildbot.libretro.com/nightly/windows/x86_64/RetroArch.7z',
          fileName: 'RetroArch.7z',
          estimatedSizeMB: 50,
        ),
        'macos': PlatformDownload(
          url:
              'https://buildbot.libretro.com/nightly/apple/osx/x86_64/RetroArch.dmg',
          fileName: 'RetroArch.dmg',
          estimatedSizeMB: 50,
        ),
      },
      requiresExtraction: true,
      finalFileName: 'retroarch.AppImage',
      postDownloadCommands: {
        'linux': [
          'mv RetroArch-Linux-x86_64/RetroArch-Linux-x86_64.AppImage ./retroarch.AppImage',
          'cp -r RetroArch-Linux-x86_64/RetroArch-Linux-x86_64.AppImage.home/.config/retroarch/* ~/.config/retroarch/',
          'rm -rf RetroArch-Linux-x86_64',
          'chmod +x retroarch.AppImage',
        ],
        'windows': [
          'move RetroArch-Windows-x86_64\\retroarch.exe .\\retroarch.exe',
          'xcopy /E /I RetroArch-Windows-x86_64\\* .',
          'rmdir /S /Q RetroArch-Windows-x86_64',
        ],
        'macos': [
          'hdiutil attach RetroArch.dmg',
          'cp -R /Volumes/RetroArch/RetroArch.app .',
          'hdiutil detach /Volumes/RetroArch',
        ],
      },
    ),

    // RetroArch Cores
    EmulatorDownloadInfo(
      name: 'retroarch_cores',
      displayName: 'RetroArch Cores',
      description: 'All RetroArch emulator cores',
      downloads: {
        'linux': PlatformDownload(
          url:
              'https://buildbot.libretro.com/stable/1.22.2/linux/x86_64/RetroArch_cores.7z',
          fileName: 'RetroArch_cores.7z',
          estimatedSizeMB: 200,
        ),
        'windows': PlatformDownload(
          url:
              'https://buildbot.libretro.com/stable/1.22.2/windows/x86_64/RetroArch_cores.7z',
          fileName: 'RetroArch_cores.7z',
          estimatedSizeMB: 200,
        ),
        'macos': PlatformDownload(
          url:
              'https://buildbot.libretro.com/stable/1.22.2/apple/osx/x86_64/RetroArch_cores.zip',
          fileName: 'RetroArch_cores.zip',
          estimatedSizeMB: 200,
        ),
      },
      requiresExtraction: true,
      isRetroArchCore: true,
      postDownloadCommands: {
        'linux': [
          'mkdir -p ~/.config/retroarch/cores',
          'cp -r cores/* ~/.config/retroarch/cores/',
          'rm -rf cores',
        ],
        'windows': [
          'if not exist "%APPDATA%\\RetroArch\\cores" mkdir "%APPDATA%\\RetroArch\\cores"',
          'xcopy /E /I cores\\* "%APPDATA%\\RetroArch\\cores\\"',
          'rmdir /S /Q cores',
        ],
        'macos': [
          'mkdir -p ~/Library/Application\\ Support/RetroArch/cores',
          'cp -r cores/* ~/Library/Application\\ Support/RetroArch/cores/',
          'rm -rf cores',
        ],
      },
    ),

    // DuckStation (PS1)
    EmulatorDownloadInfo(
      name: 'duckstation',
      displayName: 'DuckStation',
      description: 'PlayStation 1 emulator',
      downloads: {
        'linux': PlatformDownload(
          url:
              'https://github.com/stenzek/duckstation/releases/download/latest/DuckStation-x64.AppImage',
          fileName: 'duckstation.AppImage',
          estimatedSizeMB: 25,
        ),
        'windows': PlatformDownload(
          url:
              'https://github.com/stenzek/duckstation/releases/download/latest/duckstation-windows-x64-release.zip',
          fileName: 'duckstation-windows.zip',
          estimatedSizeMB: 30,
        ),
        'macos': PlatformDownload(
          url:
              'https://github.com/stenzek/duckstation/releases/download/latest/duckstation-mac-release.zip',
          fileName: 'duckstation-mac.zip',
          estimatedSizeMB: 35,
        ),
      },
      postDownloadCommands: {
        'linux': ['chmod +x duckstation.AppImage'],
        'windows': ['move duckstation-windows-x64-release.exe duckstation.exe'],
        'macos': ['mv duckstation-mac-release.dmg duckstation.dmg'],
      },
    ),

    // PCSX2 (PS2)
    EmulatorDownloadInfo(
      name: 'pcsx2',
      displayName: 'PCSX2',
      description: 'PlayStation 2 emulator',
      downloads: {
        'linux': PlatformDownload(
          url:
              'https://github.com/PCSX2/pcsx2/releases/download/v2.6.2/pcsx2-v2.6.2-linux-appimage-x64-Qt.AppImage',
          fileName: 'pcsx2.AppImage',
          estimatedSizeMB: 40,
        ),
        'windows': PlatformDownload(
          url:
              'https://github.com/PCSX2/pcsx2/releases/download/v2.6.2/pcsx2-v2.6.2-windows-x64-Qt.7z',
          fileName: 'pcsx2.7z',
          estimatedSizeMB: 45,
        ),
        'macos': PlatformDownload(
          url:
              'https://github.com/PCSX2/pcsx2/releases/download/v2.6.2/pcsx2-v2.6.2-macos-Qt.tar.xz',
          fileName: 'pcsx2.tar.xz',
          estimatedSizeMB: 50,
        ),
      },
    ),

    // RPCS3 (PS3)
    EmulatorDownloadInfo(
      name: 'rpcs3',
      displayName: 'RPCS3',
      description: 'PlayStation 3 emulator',
      downloads: {
        'linux': PlatformDownload(
          url:
              'https://github.com/RPCS3/rpcs3-binaries-linux/releases/download/build-0f85e9123e781b6ec7fa78fa1c54b1de40179a23/rpcs3-v0.0.39-18705-0f85e912_linux64.AppImage',
          fileName: 'rpcs3.AppImage',
          estimatedSizeMB: 90,
        ),
        'windows': PlatformDownload(
          url:
              'https://github.com/RPCS3/rpcs3-binaries-win/releases/download/build-0f85e9123e781b6ec7fa78fa1c54b1de40179a23/rpcs3-v0.0.39-18705-0f85e912_win64_msvc.7z',
          fileName: 'rpcs3.7z',
          estimatedSizeMB: 34,
        ),
        'macos': PlatformDownload(
          url:
              'https://github.com/RPCS3/rpcs3-binaries-mac-arm64/releases/download/build-0f85e9123e781b6ec7fa78fa1c54b1de40179a23/rpcs3-v0.0.39-18705-0f85e912_macos.7z',
          fileName: 'rpcs3.7z',
          estimatedSizeMB: 43,
        ),
      },
      postDownloadCommands: {
        'linux': ['chmod +x rpcs3.AppImage'],
        'windows': [
          '7z x rpcs3.7z -o./ && rm rpcs3.7z',
          'move rpcs3-v0.0.39-18705-0f85e912_win64_msvc.exe rpcs3.exe',
        ],
        'macos': [
          '7z x rpcs3.7z -o./ && rm rpcs3.7z'
          'mv RPCS3.app App'],
      },
    ),

    // shadPS4 (PS4)
    EmulatorDownloadInfo(
      name: 'shadps4',
      displayName: 'shadPS4',
      description: 'PlayStation 4 emulator',
      downloads: {
        'linux': PlatformDownload(
          url:
              'https://github.com/shadps4-emu/shadPS4/releases/download/v.0.13.0/shadps4-linux-sdl-0.13.0.zip',
          fileName: 'shadps4.zip',
          estimatedSizeMB: 15,
        ),
        'windows': PlatformDownload(
          url:
              'https://github.com/shadps4-emu/shadPS4/releases/download/v.0.13.0/shadps4-win64-sdl-0.13.0.zip',
          fileName: 'shadps4-win.zip',
          estimatedSizeMB: 18,
        ),
      },
      requiresExtraction: true,
      finalFileName: 'shadps4.AppImage',
      postDownloadCommands: {
        'linux': [
          'mv Shadps4*.AppImage ./shadps4.AppImage',
          'chmod +x shadps4.AppImage',
        ],
        'windows': ['move shadps4-win64-qt.exe shadps4.exe'],
      },
    ),

    // Dolphin (GameCube/Wii)
    EmulatorDownloadInfo(
      name: 'dolphin',
      displayName: 'Dolphin',
      description: 'GameCube and Wii emulator',
      downloads: {
        'linux': PlatformDownload(
          url:
              'https://github.com/pkgforge-dev/Dolphin-emu-AppImage/releases/download/2509%402025-12-15_1765785200/Dolphin_Emulator-2509-anylinux.squashfs-x86_64.AppImage',
          fileName: 'dolphin.AppImage',
          estimatedSizeMB: 30,
        ),
        'windows': PlatformDownload(
          url: 'https://dl.dolphin-emu.org/builds/dolphin-master-x64-latest.7z',
          fileName: 'dolphin.7z',
          estimatedSizeMB: 35,
        ),
        'macos': PlatformDownload(
          url:
              'https://dl.dolphin-emu.org/builds/dolphin-master-universal-latest.dmg',
          fileName: 'dolphin.dmg',
          estimatedSizeMB: 40,
        ),
      },
    ),

    // Cemu (Wii U)
    EmulatorDownloadInfo(
      name: 'cemu',
      displayName: 'Cemu',
      description: 'Wii U emulator',
      downloads: {
        'linux': PlatformDownload(
          url:
              'https://github.com/cemu-project/Cemu/releases/download/v2.6/Cemu-2.6-x86_64.AppImage',
          fileName: 'cemu.AppImage',
          estimatedSizeMB: 25,
        ),
        'windows': PlatformDownload(
          url:
              'https://github.com/cemu-project/Cemu/releases/download/v2.6/cemu-2.6-windows-x64.zip',
          fileName: 'cemu-windows.zip',
          estimatedSizeMB: 30,
        ),
      },
    ),

    // Ryujinx (Switch)
    EmulatorDownloadInfo(
      name: 'ryujinx',
      displayName: 'Ryujinx',
      description: 'Nintendo Switch emulator',
      downloads: {
        'linux': PlatformDownload(
          url:
              'https://git.ryujinx.app/api/v4/projects/1/packages/generic/Ryubing/1.3.3/ryujinx-1.3.3-x64.AppImage',
          fileName: 'ryujinx.AppImage',
          estimatedSizeMB: 45,
        ),
        'windows': PlatformDownload(
          url:
              'https://github.com/Ryujinx/release-channel-master/releases/download/1.3.3/ryujinx-1.3.3-win_x64.zip',
          fileName: 'ryujinx-win.zip',
          estimatedSizeMB: 50,
        ),
        'macos': PlatformDownload(
          url:
              'https://github.com/Ryujinx/release-channel-master/releases/download/1.3.3/ryujinx-1.3.3-macos_universal.dmg',
          fileName: 'ryujinx.dmg',
          estimatedSizeMB: 55,
        ),
      },
    ),

    // Citron (Switch)
    EmulatorDownloadInfo(
      name: 'citron',
      displayName: 'Citron',
      description: 'Nintendo Switch emulator (alternative)',
      downloads: {
        'linux': PlatformDownload(
          url:
              'https://git.citron-emu.org/Citron/Emulator/releases/download/0.11.0/Citron_stable_0.11.0_linux.AppImage',
          fileName: 'citron.AppImage',
          estimatedSizeMB: 40,
        ),
        'windows': PlatformDownload(
          url:
              'https://git.citron-emu.org/Citron/Emulator/releases/download/0.11.0/Citron_stable_0.11.0_windows.zip',
          fileName: 'citron.zip',
          estimatedSizeMB: 45,
        ),
      },
    ),

    // Xemu (Original Xbox)
    EmulatorDownloadInfo(
      name: 'xemu',
      displayName: 'xemu',
      description: 'Original Xbox emulator',
      downloads: {
        'linux': PlatformDownload(
          url:
              'https://github.com/xemu-project/xemu/releases/download/v0.8.121/xemu-v0.8.121-x86_64.AppImage',
          fileName: 'xemu.AppImage',
          estimatedSizeMB: 35,
        ),
        'windows': PlatformDownload(
          url:
              'https://github.com/xemu-project/xemu/releases/download/v0.8.121/xemu-win-release.zip',
          fileName: 'xemu.zip',
          estimatedSizeMB: 40,
        ),
        'macos': PlatformDownload(
          url:
              'https://github.com/xemu-project/xemu/releases/download/v0.8.121/xemu-macos-universal-release.zip',
          fileName: 'xemu-mac.zip',
          estimatedSizeMB: 45,
        ),
      },
    ),

    // Xenia (Xbox 360)
    EmulatorDownloadInfo(
      name: 'xenia',
      displayName: 'Xenia',
      description: 'Xbox 360 emulator',
      downloads: {
        'linux': PlatformDownload(
          url:
              'https://github.com/pkgforge-dev/xenia-canary-AppImage/releases/download/4cbcae5%402025-12-15_1765783676/Xenia_Canary-4cbcae5-anylinux-x86_64.AppImage',
          fileName: 'xenia.AppImage',
          estimatedSizeMB: 30,
        ),
        'windows': PlatformDownload(
          url:
              'https://github.com/xenia-canary/xenia-canary/releases/download/latest/xenia_canary.zip',
          fileName: 'xenia.zip',
          estimatedSizeMB: 35,
        ),
      },
    ),

    // Vita3K (PS Vita)
    EmulatorDownloadInfo(
      name: 'vita3k',
      displayName: 'Vita3K',
      description: 'PlayStation Vita emulator',
      downloads: {
        'linux': PlatformDownload(
          url:
              'https://github.com/Vita3K/Vita3K/releases/download/continuous/Vita3K-x86_64.AppImage',
          fileName: 'vita3k.AppImage',
          estimatedSizeMB: 25,
        ),
        'windows': PlatformDownload(
          url:
              'https://github.com/Vita3K/Vita3K/releases/download/continuous/Vita3K-windows-latest.zip',
          fileName: 'vita3k.zip',
          estimatedSizeMB: 30,
        ),
        'macos': PlatformDownload(
          url:
              'https://github.com/Vita3K/Vita3K/releases/download/continuous/Vita3K-macOS-latest.dmg',
          fileName: 'vita3k.dmg',
          estimatedSizeMB: 35,
        ),
      },
    ),

    // EKA2L1 (Nokia N-Gage)
    EmulatorDownloadInfo(
      name: 'eka2l1',
      displayName: 'EKA2L1',
      description: 'Nokia N-Gage/Symbian emulator',
      downloads: {
        'linux': PlatformDownload(
          url:
              'https://github.com/EKA2L1/EKA2L1/releases/download/continous/EKA2L1-Linux-x86_64.AppImage',
          fileName: 'eka2l1.AppImage',
          estimatedSizeMB: 20,
        ),
        'windows': PlatformDownload(
          url:
              'https://github.com/EKA2L1/EKA2L1/releases/download/continous/EKA2L1-Windows-x86_64.7z',
          fileName: 'eka2l1.7z',
          estimatedSizeMB: 25,
        ),
      },
    ),

    // Ruffle (Flash)
    EmulatorDownloadInfo(
      name: 'ruffle',
      displayName: 'Ruffle',
      description: 'Adobe Flash emulator',
      downloads: {
        'linux': PlatformDownload(
          url:
              'https://github.com/Portable-Linux-Apps/ruffle-AppImage/releases/download/nightly-2025-12-22%402025-12-22_1766420590/Ruffle-nightly-2025-12-22-x86_64.AppImage',
          fileName: 'ruffle.AppImage',
          estimatedSizeMB: 10,
        ),
        'windows': PlatformDownload(
          url:
              'https://github.com/ruffle-rs/ruffle/releases/download/nightly-2025-12-22/ruffle-nightly-2025-12-22-windows-x86_64.zip',
          fileName: 'ruffle.zip',
          estimatedSizeMB: 12,
        ),
        'macos': PlatformDownload(
          url:
              'https://github.com/ruffle-rs/ruffle/releases/download/nightly-2025-12-22/ruffle-nightly-2025-12-22-macos-universal.tar.gz',
          fileName: 'ruffle.tar.gz',
          estimatedSizeMB: 15,
        ),
      },
    ),

    // OpenBOR
    EmulatorDownloadInfo(
      name: 'openbor',
      displayName: 'OpenBOR',
      description: 'Beat em up game engine',
      downloads: {
        'linux': PlatformDownload(
          url:
              'https://github.com/DCurrent/openbor/releases/download/v7533/OpenBOR-Linux-x86-v4.0.Build.7533.AppImage',
          fileName: 'openbor.AppImage',
          estimatedSizeMB: 5,
        ),
        'windows': PlatformDownload(
          url:
              'https://github.com/DCurrent/openbor/releases/download/v7533/OpenBOR-v4.0.7533-Windows.zip',
          fileName: 'openbor.zip',
          estimatedSizeMB: 6,
        ),
      },
    ),

    // Utilities
    EmulatorDownloadInfo(
      name: 'vlc',
      displayName: 'VLC Media Player',
      description: 'Video player for movies',
      downloads: {
        'linux': PlatformDownload(
          url:
              'https://ocs-dl.fra1.cdn.digitaloceanspaces.com/data/files/1524979887/VLC_media_player-3.0.11.1-x86_64.AppImage',
          fileName: 'vlc.AppImage',
          estimatedSizeMB: 30,
        ),
        'windows': PlatformDownload(
          url: 'https://get.videolan.org/vlc/last/win64/vlc-3.0.21-win64.exe',
          fileName: 'vlc-installer.exe',
          estimatedSizeMB: 40,
        ),
        'macos': PlatformDownload(
          url:
              'https://get.videolan.org/vlc/last/macosx/vlc-3.0.21-universal.dmg',
          fileName: 'vlc.dmg',
          estimatedSizeMB: 50,
        ),
      },
    ),

    EmulatorDownloadInfo(
      name: 'koreader',
      displayName: 'KOReader',
      description: 'PDF/eBook reader',
      downloads: {
        'linux': PlatformDownload(
          url:
              'https://github.com/koreader/koreader/releases/download/v2025.10/koreader-appimage-x86_64-v2025.10.AppImage',
          fileName: 'pdf.AppImage',
          estimatedSizeMB: 15,
        ),
        'windows': PlatformDownload(
          url:
              'https://github.com/koreader/koreader/releases/download/v2025.10/koreader-v2025.10-windows.zip',
          fileName: 'koreader.zip',
          estimatedSizeMB: 18,
        ),
      },
    ),

    EmulatorDownloadInfo(
      name: 'qbittorrent',
      displayName: 'qBittorrent Enhanced',
      description: 'BitTorrent client for downloading ROMs',
      downloads: {
        'linux': PlatformDownload(
          url:
              'https://github.com/c0re100/qBittorrent-Enhanced-Edition/releases/download/release-5.1.3.10/qBittorrent-Enhanced-Edition-x86_64.AppImage',
          fileName: 'qbittorrent.AppImage',
          estimatedSizeMB: 20,
        ),
        'windows': PlatformDownload(
          url:
              'https://github.com/c0re100/qBittorrent-Enhanced-Edition/releases/download/release-5.1.3.10/qBittorrent_Enhanced_5.1.3.10_x64_setup.exe',
          fileName: 'qbittorrent-setup.exe',
          estimatedSizeMB: 25,
        ),
        'macos': PlatformDownload(
          url:
              'https://github.com/c0re100/qBittorrent-Enhanced-Edition/releases/download/release-5.1.3.10/qBittorrent-Enhanced-Edition-5.1.3.10.dmg',
          fileName: 'qbittorrent.dmg',
          estimatedSizeMB: 30,
        ),
      },
    ),
  ];

  /// Get emulators by category
  static List<EmulatorDownloadInfo> getByCategory(String category) {
    switch (category) {
      case 'sony':
        return emulators
            .where(
              (e) => [
                'duckstation',
                'pcsx2',
                'rpcs3',
                'shadps4',
                'vita3k',
              ].contains(e.name),
            )
            .toList();
      case 'nintendo':
        return emulators
            .where(
              (e) => ['dolphin', 'cemu', 'ryujinx', 'citron'].contains(e.name),
            )
            .toList();
      case 'microsoft':
        return emulators
            .where((e) => ['xemu', 'xenia'].contains(e.name))
            .toList();
      case 'multi':
        return emulators
            .where((e) => ['retroarch', 'retroarch_cores'].contains(e.name))
            .toList();
      case 'utilities':
        return emulators
            .where((e) => ['vlc', 'koreader', 'qbittorrent'].contains(e.name))
            .toList();
      case 'other':
        return emulators
            .where((e) => ['eka2l1', 'ruffle', 'openbor'].contains(e.name))
            .toList();
      default:
        return emulators;
    }
  }

  /// Get emulators available for current platform
  static List<EmulatorDownloadInfo> getAvailableForCurrentPlatform() {
    return emulators.where((e) => e.isAvailableForCurrentPlatform()).toList();
  }
}
