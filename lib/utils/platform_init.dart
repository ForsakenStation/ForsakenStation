import 'dart:io';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/material.dart';

/// Initialize platform-specific features for desktop platforms
Future<void> initializePlatform() async {
  // Initialize window manager for fullscreen support (desktop only)
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(1280, 720),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setFullScreen(true);
    });
  }
}
