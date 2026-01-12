import '../../../models/rom_item.dart';

/// Utilities for platform name resolution in ROM screens
class PlatformUtils {
  /// Resolve the actual platform name for a ROM item
  ///
  /// In collection views, ROMs have a `platform` field with their real platform.
  /// In regular platform views, use the provided default platform name.
  ///
  /// Example:
  /// - In "Favorites" collection, a SNES ROM has item.platform = "snes"
  /// - Use "snes" for configs, media, storage (not "favorites")
  static String getActualPlatform(
    RomItem item,
    String defaultPlatformName, {
    required bool isCollection,
  }) {
    return isCollection && item.platform != null
        ? item.platform!
        : defaultPlatformName;
  }
}
