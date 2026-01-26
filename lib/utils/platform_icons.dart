import 'package:flutter/material.dart';

/// Utility class for getting platform-specific icons
class PlatformIcons {
  /// Get the icon for a given platform name
  static IconData getIconForPlatform(String platformName) {
    switch (platformName.toLowerCase()) {
      case 'snes':
      case 'nes':
      case 'n64':
      case 'gamecube':
      case 'wii':
        return Icons.sports_esports;
      case 'playstation':
      case 'ps1':
      case 'ps2':
      case 'psx':
        return Icons.videogame_asset;
      case 'gameboy':
      case 'gba':
      case 'gbc':
        return Icons.phonelink;
      case 'arcade':
        return Icons.casino;
      case 'amiga':
      case 'atari':
      case 'commodore':
      case 'msx':
      case 'msx_sony':
      case 'msx_panasonic':
      case 'msx_philips':
      case 'msx_toshiba':
      case 'msx_yamaha':
      case 'msx_european':
      case 'msx_korean':
      case 'msx_arabic':
      case 'msx_brazilian':
        return Icons.computer;
      case 'dreamcast':
      case 'saturn':
        return Icons.album;
      case 'cdi':
        return Icons.album; // CD-i uses CDs, so album icon is appropriate
      case 'genesis':
      case 'megadrive':
      case 'mastersystem':
        return Icons.videogame_asset_outlined;
      default:
        return Icons.gamepad;
    }
  }
}
