import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../models/rom_item.dart';
import '../../../services/config_service.dart';
import '../../../platforms/web/web_emulator_launcher.dart';
import '../../../models/emulator_config.dart';
import '../../../models/media.dart';
import '../../../services/emulator_service.dart';
import '../../../services/media_service.dart';
import '../../../widgets/roms/launch_progress_dialog.dart';
import '../../../widgets/roms/emulator_selection_dialog.dart';
import '../../../widgets/common/error_dialog.dart';
import '../../pdf_viewer_screen.dart';
import '../utils/platform_utils.dart';

/// Handles ROM launching logic including emulator selection,
/// download progress, and launch execution.
class RomLauncher {
  final BuildContext context;
  final EmulatorService emulatorService;
  final MediaService mediaService;
  final String platformName; // Default platform (for non-collection views)
  final String platformDisplayName; // Default platform display name
  final Map<String, RomMedia> mediaCache;
  final VoidCallback requestFocus;
  final bool isCollection; // Whether this is a collection view

  RomLauncher({
    required this.context,
    required this.emulatorService,
    required this.mediaService,
    required this.platformName,
    required this.platformDisplayName,
    required this.mediaCache,
    required this.requestFocus,
    this.isCollection = false,
  });

  /// Main entry point for launching a ROM
  /// Returns true if launch was successful, false otherwise
  Future<bool> launchRom(RomItem item) async {
    // Web platform: use WebEmulatorLauncher
    if (kIsWeb) {
      return _launchWebEmulator(item);
    }

    // Desktop platform: use native emulator
    // For collections, use the ROM's platform; otherwise use default
    final actualPlatform = PlatformUtils.getActualPlatform(
      item,
      platformName,
      isCollection: isCollection,
    );

    final actualDisplayName = isCollection && item.platform != null
        ? item.platform! // TODO: Get display name from platform list if needed
        : platformDisplayName;

    final config = await emulatorService.loadPlatformConfig(actualPlatform);

    if (config == null || config.commands.isEmpty) {
      _showErrorDialog(
        'No emulator configured for $actualDisplayName.\n\n'
        'Please add configuration for "$actualPlatform" in:\n'
        '${ConfigService.instance.emulatorsConfigPath}',
      );
      return false;
    }

    // If multiple commands, show selection dialog
    EmulatorCommand? selectedCommand;
    if (config.hasMultipleCommands) {
      selectedCommand = await _showEmulatorSelectionDialog(config);
      if (selectedCommand == null) {
        return false; // User cancelled
      }
    } else {
      selectedCommand = config.defaultCommand;
    }

    if (selectedCommand == null) {
      _showErrorDialog('No emulator command available');
      return false;
    }

    return await _launchWithCommand(item, selectedCommand, actualPlatform);
  }

  /// Show emulator selection dialog when multiple commands available
  Future<EmulatorCommand?> _showEmulatorSelectionDialog(
    EmulatorConfig config,
  ) async {
    return await EmulatorSelectionDialog.show(
      context: context,
      config: config,
      onClose: requestFocus,
    );
  }

  /// Launch ROM using web emulator (EmulatorJS)
  Future<bool> _launchWebEmulator(RomItem item) async {
    // Check if platform is supported
    if (!WebEmulatorLauncher.isAvailableForRom(item)) {
      final platform = item.platform ?? platformName;
      _showErrorDialog(
        'Platform "$platform" is not yet supported in web browser.\n\n'
        'Supported platforms: ${WebEmulatorLauncher.getSupportedPlatforms().join(", ")}',
      );
      return false;
    }

    try {
      await WebEmulatorLauncher.launchFullscreen(context, item);
      requestFocus();
      return true;
    } catch (e) {
      _showErrorDialog('Failed to launch web emulator: $e');
      requestFocus();
      return false;
    }
  }

  /// Launch ROM with a specific emulator command
  Future<bool> _launchWithCommand(
    RomItem item,
    EmulatorCommand command,
    String actualPlatform,
  ) async {
    // Get media for this ROM to show marquee/boxart
    final media = mediaCache[item.name];
    final imagePath = media != null
        ? mediaService.getLaunchImagePath(media)
        : null;

    final isDownloading =
        item.downloadUrl != null && item.downloadUrl!.isNotEmpty;

    // Create dialog key to access state
    final GlobalKey<LaunchProgressDialogState> dialogKey = GlobalKey();
    bool wasCancelled = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LaunchProgressDialog(
        key: dialogKey,
        item: item,
        command: command,
        imagePath: imagePath,
        isDownloading: isDownloading,
        onCancel: isDownloading
            ? () {
                // Cancel the download
                emulatorService.cancelDownload();
                wasCancelled = true;
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Download cancelled'),
                      backgroundColor: Colors.orange,
                      duration: Duration(seconds: 5),
                    ),
                  );
                }
              }
            : null,
      ),
    );

    try {
      final result = await emulatorService.launchRom(
        romItem: item,
        platform: actualPlatform, // Use actual platform from ROM item
        selectedCommand: command,
        onDownloadProgress: (progress, received, total) {
          // Update dialog progress
          dialogKey.currentState?.updateProgress(progress, received, total);
        },
      );

      if (!context.mounted) return false;

      // Only close dialog if not already closed by cancel
      if (!wasCancelled) {
        Navigator.pop(context);
      }

      if (result.success) {
        // If it's a PDF, open the PDF viewer instead of showing success
        if (result.isPdf && result.filePath != null) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewerScreen(
                pdfPath: result.filePath!,
                title: item.displayName,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Launched: ${item.displayName}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }

        requestFocus();
        return true;
      } else if (!wasCancelled) {
        _showErrorDialog(
          'Failed to launch ROM.\n\n'
          'Check that:\n'
          '• Emulator is installed correctly\n'
          '• ROM file is valid\n'
          '• Configuration is correct\n\n'
          'Error: ${result.error ?? "Unknown error"}',
        );
      }

      requestFocus();
      return false;
    } catch (e) {
      if (!context.mounted) return false;
      if (!wasCancelled) {
        Navigator.pop(context); // Close loading dialog
        _showErrorDialog('Error launching ROM: $e');
      }
      requestFocus();
      return false;
    }
  }

  void _showErrorDialog(String message) {
    ErrorDialog.show(context: context, message: message, onClose: requestFocus);
  }
}
