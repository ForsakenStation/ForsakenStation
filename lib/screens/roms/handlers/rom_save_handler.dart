import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:forsaken/models/media.dart';
import 'package:forsaken/services/media_service.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/rom_item.dart';
import '../../../services/debug_service.dart';
import '../../../services/rom_storage_service.dart';
import '../../../widgets/roms/save_rom_dialog.dart';
import '../../../widgets/common/app_snackbar.dart';
import '../utils/platform_utils.dart';

/// Handles saving downloaded ROMs permanently to storage
class RomSaveHandler {
  final String platformName;
  final VoidCallback requestFocus;
  final bool isCollection;
  final MediaService mediaService;
  final Map<String, RomMedia> mediaCache;

  RomSaveHandler({
    required this.platformName,
    required this.requestFocus,
    required this.mediaService,
    required this.mediaCache,
    this.isCollection = false,
  });

  Future<bool?> handleRomSave(
    BuildContext context,
    RomItem item,
  ) async {
    final storageService = RomStorageService.instance;

    final actualPlatform = PlatformUtils.getActualPlatform(
      item,
      platformName,
      isCollection: isCollection,
    );

    try {
      final foreverPath = await storageService.findRomInForeverStorage(
        actualPlatform,
        item.name,
      );

      if (foreverPath != null) {
        return null;
      }
    } catch (e) {
      DebugService.instance.error(
        'Error checking ROM storage status: $e',
        tag: 'RomSave',
      );
    }

    if (!context.mounted) return false;
    return await _askToSaveRomPermanently(
      context,
      item,
      actualPlatform,
    );
  }

  /// Ask user if they want to save ROM permanently after playing
  Future<bool> _askToSaveRomPermanently(
    BuildContext context,
    RomItem item,
    String actualPlatform,
  ) async {
    final media = mediaCache[item.name];
    final imagePath = media != null
        ? mediaService.getLaunchImagePath(media)
        : null;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: SaveRomDialog(item: item, imagePath: imagePath),
      ),
    );

    if (!context.mounted) return false;

    if (result == true) {
      return await _saveRomPermanently(context, item, actualPlatform);
    } else {
      _showNotSavedMessage(context, item);
      requestFocus();
      return false;
    }
  }

  /// Save ROM to permanent storage
  Future<bool> _saveRomPermanently(
    BuildContext context,
    RomItem item,
    String actualPlatform,
  ) async {
    try {
      final storageService = RomStorageService.instance;

      // Move ROM from temp to forever storage
      final newPath = await storageService.moveToForeverStorage(
        actualPlatform,
        item.name,
      );

      if (newPath != null && context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        _showNotification(
          context,
          message: l10n.romSavedPermanently(item.displayName),
          icon: Icons.check_circle_rounded,
          accentColor: const Color(0xFF30D158),
          action: SnackBarAction(
            label: l10n.undo,
            textColor: const Color(0xFF64D2FF),
            onPressed: () async {
              // Move back to temp storage by deleting from forever
              await storageService.deleteFromForeverStorage(
                actualPlatform,
                item.name,
              );
            },
          ),
        );
        requestFocus();
        return true;
      } else if (context.mounted) {
        _showNotification(
          context,
          message: AppLocalizations.of(context)!.failedToSaveRom,
          icon: Icons.warning_amber_rounded,
          accentColor: const Color(0xFFFF9F0A),
        );
      }
    } catch (e) {
      if (context.mounted) {
        _showNotification(
          context,
          message: AppLocalizations.of(context)!.errorSavingRom(e.toString()),
          icon: Icons.error_outline_rounded,
          accentColor: const Color(0xFFFF453A),
        );
      }
    }

    requestFocus();
    return false;
  }

  void _showNotification(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color accentColor,
    SnackBarAction? action,
  }) {
    AppSnackBar.show(
      context,
      message: message,
      icon: icon,
      accentColor: accentColor,
      duration: const Duration(seconds: 10),
      action: action,
    );
  }

  /// Show message when user chooses not to save
  void _showNotSavedMessage(BuildContext context, RomItem item) {
    if (context.mounted) {
      AppSnackBar.info(
        context,
        AppLocalizations.of(context)!.romKeptInTemporary(item.displayName),
        duration: const Duration(seconds: 5),
      );
    }
  }
}
