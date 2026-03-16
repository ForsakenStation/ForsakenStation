import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:forsaken/services/debug_service.dart';

export 'package:flutter_test/flutter_test.dart' show expectAsync1;

/// Common test setup/teardown utilities.
class TestHelpers {
  /// Verifies that [callback] throws an exception of type [T].
  ///
  /// Fails the test if no exception is thrown or if the thrown exception
  /// is not of type [T].
  static Future<void> expectThrowsAsync<T extends Exception>(
    Future<void> Function() callback,
  ) async {
    try {
      await callback();
      fail('Expected $T to be thrown, but no exception was thrown.');
    } on T {
      // Expected — test passes.
    }
  }

  /// Creates a temporary directory for use in tests.
  ///
  /// The caller is responsible for deleting it via [cleanupTempDirectory].
  static Future<Directory> createTempTestDirectory() async {
    return Directory.systemTemp.createTemp('flutter_test_');
  }

  /// Deletes [dir] and all its contents if it exists.
  static Future<void> cleanupTempDirectory(Directory dir) async {
    if (dir.existsSync()) {
      await dir.delete(recursive: true);
    }
  }

  /// Resets [DebugService] to a known, quiet state before a service test.
  ///
  /// Disables logging so test output is not polluted by service log calls.
  static void setupServiceTest() {
    DebugService.initialize(
      isEnabled: false,
      minLevel: LogLevel.none,
    );
  }

  /// Restores [DebugService] to default debug-mode settings after a test.
  static void teardownServiceTest() {
    DebugService.initialize(
      isEnabled: true,
      minLevel: LogLevel.debug,
    );
  }
}
