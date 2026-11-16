import 'package:flutter/material.dart';

/// Unified floating notification SnackBar matching the ROM save notification style.
class AppSnackBar {
  const AppSnackBar._();

  static void show(
    BuildContext context, {
    required String message,
    IconData icon = Icons.info_outline,
    Color accentColor = const Color(0xFF0A84FF),
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    if (!context.mounted) return;
    final screenWidth = MediaQuery.of(context).size.width;
    showWithMessenger(
      ScaffoldMessenger.of(context),
      screenWidth: screenWidth,
      message: message,
      icon: icon,
      accentColor: accentColor,
      duration: duration,
      action: action,
    );
  }

  static void showWithMessenger(
    ScaffoldMessengerState messenger, {
    required double screenWidth,
    required String message,
    IconData icon = Icons.info_outline,
    Color accentColor = const Color(0xFF0A84FF),
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: accentColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1C1F28),
        duration: duration,
        persist: false,
        behavior: SnackBarBehavior.floating,
        width: screenWidth > 600 ? 480 : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: accentColor.withValues(alpha: 0.35)),
        ),
        action: action,
      ),
    );
  }

  static void success(
    BuildContext context,
    String message, {
    IconData icon = Icons.check_circle_outline,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    show(
      context,
      message: message,
      icon: icon,
      accentColor: Colors.green.shade400,
      duration: duration,
      action: action,
    );
  }

  static void error(
    BuildContext context,
    String message, {
    IconData icon = Icons.error_outline,
    Duration duration = const Duration(seconds: 5),
    SnackBarAction? action,
  }) {
    show(
      context,
      message: message,
      icon: icon,
      accentColor: Colors.red.shade400,
      duration: duration,
      action: action,
    );
  }

  static void warning(
    BuildContext context,
    String message, {
    IconData icon = Icons.warning_amber_rounded,
    Duration duration = const Duration(seconds: 5),
    SnackBarAction? action,
  }) {
    show(
      context,
      message: message,
      icon: icon,
      accentColor: Colors.orange.shade400,
      duration: duration,
      action: action,
    );
  }

  static void info(
    BuildContext context,
    String message, {
    IconData icon = Icons.info_outline,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    show(
      context,
      message: message,
      icon: icon,
      accentColor: const Color(0xFF0A84FF),
      duration: duration,
      action: action,
    );
  }
}
