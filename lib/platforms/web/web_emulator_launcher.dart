import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../models/rom_item.dart';
import '../../platforms/web/web_core_manager.dart';
import '../../platforms/web/screens/web_emulator_screen.dart';

/// Helper class to launch web emulation
class WebEmulatorLauncher {
  /// Check if web emulation is available for this ROM
  static bool isAvailableForRom(RomItem rom) {
    if (!kIsWeb) return false;

    final webCoreManager = WebCoreManager.instance;
    final platform = rom.platform?.toLowerCase() ?? '';

    return webCoreManager.hasCoreSupport(platform);
  }

  /// Launch ROM in fullscreen web emulator
  /// Returns true if the ROM was successfully loaded and played
  static Future<bool> launchFullscreen(
    BuildContext context,
    RomItem rom,
  ) async {
    if (!kIsWeb) {
      throw Exception('Web emulation only available in browser');
    }

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => WebEmulatorScreen(rom: rom)),
    );
    return result ?? false;
  }

  /// Launch ROM in dialog web emulator
  static Future<void> launchDialog(BuildContext context, RomItem rom) async {
    if (!kIsWeb) {
      throw Exception('Web emulation only available in browser');
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(16),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.9,
          child: WebEmulatorScreen(rom: rom),
        ),
      ),
    );
  }

  /// Get list of supported platforms for web emulation
  static List<String> getSupportedPlatforms() {
    if (!kIsWeb) return [];

    final webCoreManager = WebCoreManager.instance;
    final platforms = <String>{};
    for (final core in webCoreManager.allCores.values) {
      platforms.addAll(core.supportedPlatforms);
    }
    return platforms.toList()..sort();
  }

  /// Get core information for a platform
  static String? getCoreDisplayName(String platform) {
    if (!kIsWeb) return null;

    final webCoreManager = WebCoreManager.instance;
    final coreInfo = webCoreManager.getCoreInfo(platform);
    return coreInfo?.displayName;
  }
}
