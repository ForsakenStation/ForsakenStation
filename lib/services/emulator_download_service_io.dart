import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:archive/archive.dart';
import 'package:forsaken/models/emulator_download_info.dart';
import 'config_service.dart';
import 'debug_service.dart';

/// Service for downloading and installing emulators
class EmulatorDownloadService {
  static EmulatorDownloadService? _instance;
  final _configService = ConfigService.instance;
  final _debug = DebugService.instance;

  EmulatorDownloadService._();

  static EmulatorDownloadService get instance {
    _instance ??= EmulatorDownloadService._();
    return _instance!;
  }

  /// Download an emulator with progress callback
  ///
  /// Returns the path to the downloaded/extracted file
  Future<String?> downloadEmulator(
    EmulatorDownloadInfo emulator, {
    Function(double progress)? onProgress,
    Function(String status)? onStatus,
  }) async {
    try {
      final platformDownload = emulator.getDownloadForCurrentPlatform();
      if (platformDownload == null) {
        throw Exception('Emulator not available for current platform');
      }

      onStatus?.call('Starting download of ${emulator.displayName}...');
      _debug.info('Downloading ${emulator.name} from ${platformDownload.url}');

      // Get destination directory
      final destDir = Directory(_configService.emulatorsPath);
      if (!await destDir.exists()) {
        await destDir.create(recursive: true);
      }

      final filePath = path.join(destDir.path, platformDownload.fileName);
      final file = File(filePath);

      // Download file with progress
      final request = http.Request('GET', Uri.parse(platformDownload.url));
      final response = await request.send();

      if (response.statusCode != 200) {
        throw Exception('Failed to download: HTTP ${response.statusCode}');
      }

      final contentLength = response.contentLength ?? 0;
      var downloadedBytes = 0;
      final sink = file.openWrite();

      await for (final chunk in response.stream) {
        sink.add(chunk);
        downloadedBytes += chunk.length;

        if (contentLength > 0) {
          final progress = downloadedBytes / contentLength;
          onProgress?.call(progress);
        }
      }

      await sink.close();
      onStatus?.call('Download complete');
      _debug.info('Downloaded ${emulator.name} to $filePath');

      // Extract if needed
      if (emulator.requiresExtraction) {
        onStatus?.call('Extracting files...');
        await _extractArchive(file, destDir.path, onStatus: onStatus);

        // Delete archive after extraction
        await file.delete();
        _debug.info('Extracted and removed archive');
      }

      // Run post-download commands (platform-specific)
      final postCommands = emulator.getPostDownloadCommandsForCurrentPlatform();
      if (postCommands != null && postCommands.isNotEmpty) {
        onStatus?.call('Running post-install commands...');
        await _runPostDownloadCommands(
          postCommands,
          destDir.path,
          onStatus: onStatus,
        );
      }

      // Determine final file path
      String finalPath;
      if (emulator.finalFileName != null) {
        finalPath = path.join(destDir.path, emulator.finalFileName!);
      } else if (emulator.requiresExtraction &&
          emulator.extractedFileName != null) {
        finalPath = path.join(destDir.path, emulator.extractedFileName!);
      } else {
        finalPath = filePath;
      }

      onStatus?.call('Installation complete');
      _debug.info('Emulator ${emulator.name} installed successfully');

      return finalPath;
    } catch (e, stackTrace) {
      _debug.error(
        'Error downloading ${emulator.name}',
        error: e,
        stackTrace: stackTrace,
      );
      onStatus?.call('Error: $e');
      return null;
    }
  }

  /// Extract archive files (7z, zip, tar.gz, etc.)
  Future<void> _extractArchive(
    File archiveFile,
    String destPath, {
    Function(String)? onStatus,
  }) async {
    final fileName = path.basename(archiveFile.path);
    final extension = path.extension(fileName).toLowerCase();

    try {
      if (extension == '.7z' || extension == '.zip') {
        await _extract7z(archiveFile.path, destPath, onStatus: onStatus);
      } else if (extension == '.gz' || extension == '.xz') {
        await _extractTarGz(archiveFile, destPath, onStatus: onStatus);
      } else {
        _debug.warning('Unknown archive format: $extension');
      }
    } catch (e) {
      _debug.error('Error extracting archive', error: e);
      rethrow;
    }
  }

  /// Extract 7z archive using system 7z command
  Future<void> _extract7z(
    String archivePath,
    String destPath, {
    Function(String)? onStatus,
  }) async {
    onStatus?.call('Extracting 7z archive...');

    final result = await Process.run('7z', [
      'x',
      '-y',
      '-o$destPath',
      archivePath,
    ], workingDirectory: destPath);

    if (result.exitCode != 0) {
      throw Exception('7z extraction failed: ${result.stderr}');
    }

    _debug.info('Extracted 7z archive successfully');
  }

  /// Extract tar.gz or tar.xz archive
  Future<void> _extractTarGz(
    File archiveFile,
    String destPath, {
    Function(String)? onStatus,
  }) async {
    onStatus?.call('Extracting TAR archive...');

    final bytes = await archiveFile.readAsBytes();

    // Decompress first
    List<int> decompressed;
    final extension = path.extension(archiveFile.path).toLowerCase();

    if (extension == '.gz') {
      decompressed = GZipDecoder().decodeBytes(bytes);
    } else if (extension == '.xz') {
      // XZ requires external tool
      final result = await Process.run('tar', [
        'xf',
        archiveFile.path,
        '-C',
        destPath,
      ]);
      if (result.exitCode != 0) {
        throw Exception('Tar extraction failed: ${result.stderr}');
      }
      return;
    } else {
      decompressed = bytes;
    }

    // Extract tar
    final archive = TarDecoder().decodeBytes(decompressed);

    for (final file in archive) {
      final filename = path.join(destPath, file.name);

      if (file.isFile) {
        final outFile = File(filename);
        await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content as List<int>);
      } else {
        await Directory(filename).create(recursive: true);
      }
    }

    _debug.info('Extracted TAR archive successfully');
  }

  /// Run post-download commands
  Future<void> _runPostDownloadCommands(
    List<String> commands,
    String workingDir, {
    Function(String)? onStatus,
  }) async {
    for (final command in commands) {
      onStatus?.call('Running: $command');
      _debug.info('Running command: $command');
      try {
        final result = await Process.run(
          'sh',
          ['-c', command],
          workingDirectory: workingDir,
          runInShell: true,
        );
        if (result.exitCode != 0) {
          _debug.warning(
            'Command failed with exit code ${result.exitCode}: ${result.stderr}',
          );
        } else {
          _debug.info('Command executed successfully');
        }
      } catch (e) {
        _debug.warning('Error running command: $e');
        // Continue with other commands even if one fails
      }
    }
  }

  /// Make all AppImage files executable
  Future<void> makeAppImagesExecutable(String directory) async {
    if (kIsWeb || !Platform.isLinux) return;

    final dir = Directory(directory);
    await for (final entity in dir.list()) {
      if (entity is File && entity.path.endsWith('.AppImage')) {
        try {
          await Process.run('chmod', ['+x', entity.path]);
          _debug.info('Made executable: ${path.basename(entity.path)}');
        } catch (e) {
          _debug.warning('Failed to make executable: $e');
        }
      }
    }
  }

  /// Download all emulators in a list
  Future<Map<String, String?>> downloadMultipleEmulators(
    List<EmulatorDownloadInfo> emulators, {
    Function(String emulatorName, double progress)? onProgress,
    Function(String emulatorName, String status)? onStatus,
  }) async {
    final results = <String, String?>{};

    for (final emulator in emulators) {
      onStatus?.call(emulator.name, 'Starting...');

      final result = await downloadEmulator(
        emulator,
        onProgress: (progress) => onProgress?.call(emulator.name, progress),
        onStatus: (status) => onStatus?.call(emulator.name, status),
      );

      results[emulator.name] = result;
    }

    return results;
  }

  /// Check if emulator is already installed
  Future<bool> isEmulatorInstalled(EmulatorDownloadInfo emulator) async {
    final destDir = Directory(_configService.emulatorsPath);

    String? fileName;
    if (emulator.finalFileName != null) {
      fileName = emulator.finalFileName;
    } else {
      final platformDownload = emulator.getDownloadForCurrentPlatform();
      if (platformDownload != null) {
        fileName = platformDownload.fileName;
      }
    }

    if (fileName == null) return false;

    final file = File(path.join(destDir.path, fileName));
    return await file.exists();
  }

  /// Delete an installed emulator
  Future<bool> deleteEmulator(EmulatorDownloadInfo emulator) async {
    try {
      final destDir = Directory(_configService.emulatorsPath);

      String? fileName;
      if (emulator.finalFileName != null) {
        fileName = emulator.finalFileName;
      } else {
        final platformDownload = emulator.getDownloadForCurrentPlatform();
        if (platformDownload != null) {
          fileName = platformDownload.fileName;
        }
      }

      if (fileName == null) return false;

      final file = File(path.join(destDir.path, fileName));
      if (await file.exists()) {
        await file.delete();
        _debug.info('Deleted emulator: ${emulator.name}');
        return true;
      }

      return false;
    } catch (e) {
      _debug.error('Error deleting emulator', error: e);
      return false;
    }
  }

  /// Get download size estimates for emulators
  int getTotalDownloadSize(List<EmulatorDownloadInfo> emulators) {
    int totalMB = 0;
    for (final emulator in emulators) {
      final download = emulator.getDownloadForCurrentPlatform();
      if (download?.estimatedSizeMB != null) {
        totalMB += download!.estimatedSizeMB!;
      }
    }
    return totalMB;
  }
}
