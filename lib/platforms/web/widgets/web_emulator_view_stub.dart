import 'package:flutter/material.dart';

/// Stub implementation for non-web platforms

/// Create the emulator HTML view (stub - shows placeholder)
Widget createEmulatorHtmlView({
  required String containerId,
  double? width,
  double? height,
}) {
  return Container(
    width: width ?? double.infinity,
    height: height ?? 400,
    decoration: BoxDecoration(
      color: Colors.grey.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Center(
      child: Text(
        'Web emulator only available in browser',
        style: TextStyle(color: Colors.grey),
      ),
    ),
  );
}

/// Register the emulator container (stub - no-op)
void registerEmulatorContainer(String containerId) {
  // No-op on non-web platforms
}

/// Check if running on web
bool get isWebPlatform => false;
