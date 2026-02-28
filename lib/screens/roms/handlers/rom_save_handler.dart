import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../models/rom_item.dart';
import '../../../services/debug_service.dart';
import '../../../services/rom_storage_service.dart';
import '../../../widgets/roms/save_rom_dialog.dart';
import '../utils/platform_utils.dart';

/// Handles saving downloaded ROMs permanently to storage
class RomSaveHandler {
  final String platformName; // Default platform
  final VoidCallback requestFocus;
  final bool isCollection; // Whether this is a collection view

  RomSaveHandler({
    required this.platformName,
    required this.requestFocus,
    this.isCollection = false,
  });

  /// Check if a ROM should be saved and handle the save process
  /// Returns true if user chose to save, false if declined, null if already saved
  Future<bool?> handleRomSave(
    BuildContext context,
    RomItem item,
    String? imagePath,
  ) async {
    final storageService = RomStorageService.instance;

    // For collections, use the ROM's platform; otherwise use default
    final actualPlatform = PlatformUtils.getActualPlatform(
      item,
      platformName,
      isCollection: isCollection,
    );

    try {
      // Check if ROM is already in forever storage
      final foreverPath = await storageService.findRomInForeverStorage(
        actualPlatform,
        item.name,
      );

      // Already saved, no need to ask
      if (foreverPath != null) {
        return null;
      }
    } catch (e) {
      DebugService.instance.error(
        'Error checking ROM storage status: $e',
        tag: 'RomSave',
      );
      // Continue to ask user to save, even if check failed
    }

    // Ask user if they want to save ROM permanently
    if (!context.mounted) return false;
    return await _askToSaveRomPermanently(
      context,
      item,
      imagePath,
      actualPlatform,
    );
  }

  /// Ask user if they want to save ROM permanently after playing
  Future<bool> _askToSaveRomPermanently(
    BuildContext context,
    RomItem item,
    String? imagePath,
    String actualPlatform,
  ) async {
    // Show dialog asking if user wants to save ROM permanently
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.7), // Darker barrier
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur background
        child: SaveRomDialog(item: item, imagePath: imagePath),
      ),
    );

    if (!context.mounted) return false;

    // If user chose to save permanently
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
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.displayName} saved permanently'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Undo',
              textColor: Colors.white,
              onPressed: () async {
                // Move back to temp storage by deleting from forever
                await storageService.deleteFromForeverStorage(
                  actualPlatform,
                  item.name,
                );
              },
            ),
          ),
        );
        requestFocus();
        return true;
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save ROM permanently'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving ROM: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    requestFocus();
    return false;
  }

  /// Show message when user chooses not to save
  void _showNotSavedMessage(BuildContext context, RomItem item) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.displayName} kept in temporary storage'),
          backgroundColor: Colors.grey[700],
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
