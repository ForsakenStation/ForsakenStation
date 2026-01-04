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
        return Icons.computer;
      case 'dreamcast':
      case 'saturn':
        return Icons.album;
      case 'genesis':
      case 'megadrive':
      case 'mastersystem':
        return Icons.videogame_asset_outlined;
      default:
        return Icons.gamepad;
    }
  }
}
