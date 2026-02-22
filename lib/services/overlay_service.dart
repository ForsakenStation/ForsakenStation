import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/overlay_config.dart';
import 'debug_service.dart';

/// Simple service to manage RetroArch overlay configurations
class OverlayService {
  static OverlayService? _instance;
  final DebugService _debug = DebugService.instance;

  /// Base path for overlay assets
  static const String _overlayBasePath = 'assets/theme/overlays';

  /// Default overlay configuration template
  static const String _defaultOverlayConfig = '''overlays = 1
overlay0_overlay = "{IMAGE_PATH}"
overlay0_full_screen = true
overlay0_descs = 0
input_overlay_opacity = 1.0
overlay0_alpha_mod = 1.0
''';

  OverlayService._();

  /// Get singleton instance
  static OverlayService get instance {
    return _instance ??= OverlayService._();
  }

  /// Check if platform has overlay support by checking if PNG image exists
  Future<bool> hasOverlaySupport(String platform) async {
    try {
      final manifestJson = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifest = Map<String, dynamic>.from(
        jsonDecode(manifestJson),
      );

      final platformPngPath = '$_overlayBasePath/$platform/$platform.png';
      final hasImage = manifest.keys.any((key) => key == platformPngPath);

      return hasImage;
    } catch (e) {
      _debug.error('Error checking overlay support: $e', tag: 'OverlayService');
      return false;
    }
  }

  Future<OverlayConfig?> getDefaultOverlay(String platform) async {
    if (!await hasOverlaySupport(platform)) {
      return null;
    }

    final defaultPngPath = '$_overlayBasePath/$platform/$platform.png';
    final specificCfgPath = '$_overlayBasePath/$platform/$platform.cfg';

    bool hasSpecificConfig = false;
    try {
      await rootBundle.loadString(specificCfgPath);
      hasSpecificConfig = true;
      _debug.debug(
        'Found specific config for $platform: $specificCfgPath',
        tag: 'OverlayService',
      );
    } catch (e) {
      _debug.debug(
        'No specific config for $platform, will use default template',
        tag: 'OverlayService',
      );
    }

    return OverlayConfig(
      platform: platform,
      variant: 'Default',
      configPath: hasSpecificConfig
          ? specificCfgPath
          : null, // null means use default template
      imagePath: defaultPngPath,
      isDefault: true,
    );
  }

  /// Get the base app directory for overlay storage
  /// Same pattern as RomStorageService to ensure compatibility
  Future<Directory> _getBaseOverlayDirectory() async {
    if (kIsWeb) {
      // For web, use simulated directory path
      return Directory('/web-storage/overlays');
    }

    final baseDir = await getApplicationSupportDirectory();
    return Directory('${baseDir.path}/overlays');
  }

  /// Initialize overlay directory (create if it doesn't exist)
  /// Same pattern as RomStorageService
  Future<void> _initializeOverlayDirectory() async {
    try {
      final overlayDir = await _getBaseOverlayDirectory();

      if (!await overlayDir.exists()) {
        await overlayDir.create(recursive: true);
        _debug.info(
          'Created overlay directory: ${overlayDir.path}',
          tag: 'OverlayService',
        );
      }
    } catch (e) {
      _debug.error(
        'Error initializing overlay directory: $e',
        tag: 'OverlayService',
      );
      rethrow;
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
      // Initialize overlay directory first (like RomStorageService pattern)
      await _initializeOverlayDirectory();
      final overlayDir = await _getBaseOverlayDirectory();
      // Use fixed filenames - always overwrite the same files
      final configFile = File('${overlayDir.path}/current_overlay.cfg');
      final pngFile = File('${overlayDir.path}/current_overlay.png');
      final pngBytes = await rootBundle.load(overlay.imagePath);

      // Write PNG file with explicit flush
      final pngData = pngBytes.buffer.asUint8List();
      await pngFile.writeAsBytes(pngData, flush: true);

      // Load config content (either specific or default template)
      String cfgContent;
      if (overlay.configPath != null) {
        cfgContent = await rootBundle.loadString(overlay.configPath!);
      } else {
        cfgContent = _defaultOverlayConfig;
      }

      // Replace the overlay path to point to our PNG file
      final modifiedCfg = cfgContent
          .replaceAll(
            RegExp(r'overlay0_overlay\s*=.*'),
            'overlay0_overlay = "${pngFile.path}"',
          )
          .replaceAll(
            '{IMAGE_PATH}', // Template placeholder replacement
            pngFile.path,
          );

      await configFile.writeAsString(modifiedCfg, flush: true);

      // Verify files exist and have content
      final configExists = await configFile.exists();
      final pngExists = await pngFile.exists();
      final configSize = configExists ? await configFile.length() : 0;
      final pngSize = pngExists ? await pngFile.length() : 0;

      if (!configExists || !pngExists || configSize == 0 || pngSize == 0) {
        _debug.error(
          'Overlay file creation failed - Config: $configExists/${configSize}b, PNG: $pngExists/${pngSize}b',
          tag: 'OverlayService',
        );
        return [];
      }

      _debug.debug(
        'Created overlay config at: ${configFile.path}',
        tag: 'OverlayService',
      );

      // Return RetroArch arguments pointing to fixed config file
      return ['--appendconfig', configFile.path];
    } catch (e, stackTrace) {
      _debug.error(
        'Error creating overlay args: $e\n$stackTrace',
        tag: 'OverlayService',
      );
      return [];
    }
  }
}
