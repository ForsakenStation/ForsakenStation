import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/overlay_config.dart';
import 'debug_service.dart';

/// Simple service to manage RetroArch overlay configurations
class OverlayService {
  static OverlayService? _instance;
  final DebugService _debug = DebugService.instance;

  /// Base path for overlay assets
  static const String _overlayBasePath = 'assets/theme/bezeel';

  OverlayService._();

  /// Get singleton instance
  static OverlayService get instance {
    return _instance ??= OverlayService._();
  }

  /// Check if platform has overlay support by checking if folder exists
  Future<bool> hasOverlaySupport(String platform) async {
    try {
      final manifestJson = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifest = Map<String, dynamic>.from(
        jsonDecode(manifestJson),
      );

      // Check if any assets exist for this platform
      final platformPath = '$_overlayBasePath/$platform/';
      final hasAssets = manifest.keys.any(
        (key) => key.startsWith(platformPath),
      );

      _debug.debug(
        'Platform $platform overlay support: $hasAssets',
        tag: 'OverlayService',
      );

      return hasAssets;
    } catch (e) {
      _debug.error('Error checking overlay support: $e', tag: 'OverlayService');
      return false;
    }
  }

  /// Get default overlay config for a platform (simple version)
  Future<OverlayConfig?> getDefaultOverlay(String platform) async {
    if (!await hasOverlaySupport(platform)) {
      return null;
    }

    // Try to find the main cfg file for the platform
    final defaultCfgPath = '$_overlayBasePath/$platform/$platform.cfg';
    final defaultPngPath = '$_overlayBasePath/$platform/$platform.png';

    try {
      // Check if the default config exists in assets
      await rootBundle.loadString(defaultCfgPath);

      _debug.debug(
        'Found default overlay for $platform',
        tag: 'OverlayService',
      );

      return OverlayConfig(
        platform: platform,
        variant: 'Default',
        configPath: defaultCfgPath,
        imagePath: defaultPngPath,
        isDefault: true,
      );
    } catch (e) {
      _debug.warning(
        'No default overlay found for $platform: $e',
        tag: 'OverlayService',
      );
      return null;
    }
  }

  /// Create RetroArch overlay arguments for a platform using shared directory
  Future<List<String>> createRetroArchOverlayArgs(
    String platform, [
    String? variant,
  ]) async {
    final overlay = await getDefaultOverlay(platform);
    if (overlay == null) {
      _debug.debug('No overlay for $platform', tag: 'OverlayService');
      return [];
    }

    try {
      // Use application support directory - proper location for app data files
      final appDir = await getApplicationSupportDirectory();
      final overlayDir = Directory('${appDir.path}/overlays');

      _debug.info(
        'OVERLAY DEBUG: Using shared app directory: ${overlayDir.path}',
        tag: 'OverlayService',
      );

      // Create overlay directory if it doesn't exist
      if (!await overlayDir.exists()) {
        await overlayDir.create(recursive: true);
        _debug.info(
          'OVERLAY DEBUG: Created overlay directory: ${overlayDir.path}',
          tag: 'OverlayService',
        );
      }

      // Use fixed filenames - always overwrite the same files
      final configFile = File('${overlayDir.path}/current_overlay.cfg');
      final pngFile = File('${overlayDir.path}/current_overlay.png');

      _debug.info(
        'OVERLAY DEBUG: Fixed config path: ${configFile.path}',
        tag: 'OverlayService',
      );
      _debug.info(
        'OVERLAY DEBUG: Fixed PNG path: ${pngFile.path}',
        tag: 'OverlayService',
      );

      // Always recreate files for current platform (overwrite previous ROM's overlay)
      _debug.info(
        'OVERLAY DEBUG: Creating overlay files for platform: $platform',
        tag: 'OverlayService',
      );

      // Copy PNG file from assets
      _debug.info(
        'OVERLAY DEBUG: Loading PNG from asset: ${overlay.imagePath}',
        tag: 'OverlayService',
      );

      final pngBytes = await rootBundle.load(overlay.imagePath);
      _debug.info(
        'OVERLAY DEBUG: Loaded PNG bytes: ${pngBytes.lengthInBytes} bytes',
        tag: 'OverlayService',
      );

      await pngFile.writeAsBytes(pngBytes.buffer.asUint8List());
      _debug.info(
        'OVERLAY DEBUG: Written PNG file: ${pngFile.path}',
        tag: 'OverlayService',
      );

      // Load and modify config file to point to our PNG
      _debug.info(
        'OVERLAY DEBUG: Loading CFG from asset: ${overlay.configPath}',
        tag: 'OverlayService',
      );

      final cfgContent = await rootBundle.loadString(overlay.configPath);
      _debug.info(
        'OVERLAY DEBUG: Loaded CFG content length: ${cfgContent.length} chars',
        tag: 'OverlayService',
      );

      // Replace the overlay path to point to our PNG file
      final modifiedCfg = cfgContent.replaceAll(
        RegExp(r'overlay0_overlay\s*=.*'),
        'overlay0_overlay = "${pngFile.path}"',
      );

      _debug.info(
        'OVERLAY DEBUG: Modified CFG to use: ${pngFile.path}',
        tag: 'OverlayService',
      );

      await configFile.writeAsString(modifiedCfg);
      _debug.info(
        'OVERLAY DEBUG: Written CFG file: ${configFile.path}',
        tag: 'OverlayService',
      );

      // Verify files exist and have content
      final configExists = await configFile.exists();
      final pngExists = await pngFile.exists();
      final configSize = configExists ? await configFile.length() : 0;
      final pngSize = pngExists ? await pngFile.length() : 0;

      _debug.info(
        'OVERLAY DEBUG: Final verification - Config exists: $configExists (${configSize}b), PNG exists: $pngExists (${pngSize}b)',
        tag: 'OverlayService',
      );

      if (!configExists || !pngExists || configSize == 0 || pngSize == 0) {
        _debug.error(
          'OVERLAY DEBUG: File creation failed - Config: $configExists/${configSize}b, PNG: $pngExists/${pngSize}b',
          tag: 'OverlayService',
        );
        return [];
      }

      _debug.info(
        'OVERLAY DEBUG: SUCCESS! RetroArch will use overlay: ${configFile.path}',
        tag: 'OverlayService',
      );

      // Return RetroArch arguments pointing to fixed config file
      return ['--appendconfig', configFile.path];
    } catch (e, stackTrace) {
      _debug.error(
        'OVERLAY DEBUG: Error creating overlay args: $e',
        tag: 'OverlayService',
      );
      _debug.error(
        'OVERLAY DEBUG: Stack trace: $stackTrace',
        tag: 'OverlayService',
      );
      return [];
    }
  }

  /// Simple test method to verify overlay file creation without requiring UI
  Future<void> testOverlayCreation() async {
    _debug.info('=== TESTING OVERLAY FILE CREATION ===', tag: 'OverlayService');

    const platform = 'amiga500';
    _debug.info('Testing platform: $platform', tag: 'OverlayService');

    try {
      final hasSupport = await hasOverlaySupport(platform);
      _debug.info('Has overlay support: $hasSupport', tag: 'OverlayService');

      if (hasSupport) {
        final args = await createRetroArchOverlayArgs(platform);
        _debug.info('Generated args: $args', tag: 'OverlayService');

        if (args.isNotEmpty && args.length >= 2) {
          final configPath = args[1];
          _debug.info('Config path: $configPath', tag: 'OverlayService');

          // Verify files exist
          final configFile = File(configPath);
          final pngPath = configPath.replaceAll(
            'current_overlay.cfg',
            'current_overlay.png',
          );
          final pngFile = File(pngPath);

          final configExists = await configFile.exists();
          final pngExists = await pngFile.exists();

          _debug.info('Config exists: $configExists', tag: 'OverlayService');
          _debug.info('PNG exists: $pngExists', tag: 'OverlayService');

          if (configExists && pngExists) {
            final configSize = await configFile.length();
            final pngSize = await pngFile.length();
            _debug.info(
              '✅ SUCCESS! Files created - Config: ${configSize}b, PNG: ${pngSize}b',
              tag: 'OverlayService',
            );
          } else {
            _debug.error(
              '❌ FAILED! Files not created properly',
              tag: 'OverlayService',
            );
          }
        } else {
          _debug.error(
            '❌ FAILED! No overlay args generated',
            tag: 'OverlayService',
          );
        }
      } else {
        _debug.warning(
          '❌ Platform $platform does not have overlay support',
          tag: 'OverlayService',
        );
      }
    } catch (e, stackTrace) {
      _debug.error('❌ ERROR in overlay test: $e', tag: 'OverlayService');
      _debug.error('Stack trace: $stackTrace', tag: 'OverlayService');
    }

    _debug.info('=== END OVERLAY TEST ===', tag: 'OverlayService');
  }

  /// Debug method to test overlay for a platform
  Future<void> debugTestOverlay(String platform) async {
    _debug.info('=== OVERLAY DEBUG TEST ===', tag: 'OverlayService');

    final hasSupport = await hasOverlaySupport(platform);
    _debug.info(
      'Platform $platform has overlay: $hasSupport',
      tag: 'OverlayService',
    );

    if (hasSupport) {
      final overlay = await getDefaultOverlay(platform);
      if (overlay != null) {
        _debug.info(
          'Default overlay: ${overlay.imagePath}',
          tag: 'OverlayService',
        );

        final args = await createRetroArchOverlayArgs(platform);
        _debug.info('RetroArch args: $args', tag: 'OverlayService');
      }
    }

    _debug.info('=== END DEBUG TEST ===', tag: 'OverlayService');
  }

  /// Cleanup temporary overlay files (called when app closes)
  Future<void> cleanupTempFiles() async {
    try {
      final appDir = await getApplicationSupportDirectory();
      final overlayDir = Directory('${appDir.path}/overlays');

      if (await overlayDir.exists()) {
        // Only clean up our specific overlay files, not the whole directory
        final configFile = File('${overlayDir.path}/current_overlay.cfg');
        final pngFile = File('${overlayDir.path}/current_overlay.png');

        if (await configFile.exists()) {
          await configFile.delete();
        }
        if (await pngFile.exists()) {
          await pngFile.delete();
        }

        _debug.debug('Cleaned up overlay files', tag: 'OverlayService');
      }
    } catch (e) {
      _debug.warning(
        'Error cleaning up overlay files: $e',
        tag: 'OverlayService',
      );
    }
  }
}
