import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:archive/archive.dart';
import 'package:path/path.dart' as path;

/// Service for managing ROM list downloads
///
/// This service handles:
/// - Downloading ROM lists from GitHub
/// - Extracting ROM list archives
/// - Generating fake ROM files with download URLs
/// - Copying gamelist metadata
class RomListDownloadService {
  static final RomListDownloadService instance =
      RomListDownloadService._internal();

  RomListDownloadService._internal();

  static const String _gameListsRepoUrl =
      'https://github.com/vguardiola/romlists/archive/refs/heads/main.zip';

  /// Downloads game lists from GitHub repository
  ///
  /// Downloads the romlists repository as a ZIP file, extracts it,
  /// and returns the path to the extracted lists directory.
  ///
  /// The repository contains:
  /// - *.txt files with ROM download URLs (one file per platform)
  /// - gamelists/*.xml files with ROM metadata
  ///
  /// Progress is reported through [onProgress] (0.0 to 1.0)
  /// Status messages are reported through [onStatus]
  Future<String> downloadGameLists({
    Function(double progress)? onProgress,
    Function(String status)? onStatus,
  }) async {
    final emulatorsPath = dotenv.env['EMULATORS_PATH'];
    if (emulatorsPath == null || emulatorsPath.isEmpty) {
      throw Exception('EMULATORS_PATH not configured in .env');
    }

    // Resolve ~ to home directory
    final resolvedPath = emulatorsPath.replaceFirst(
      RegExp(r'^~'),
      Platform.environment['HOME'] ?? '',
    );

    final listsDir = Directory(path.join(resolvedPath, 'lists'));
    final zipPath = path.join(resolvedPath, 'lists.zip');

    try {
      // Delete existing lists directory if it exists
      onStatus?.call('Cleaning up old lists...');
      if (await listsDir.exists()) {
        await listsDir.delete(recursive: true);
      }

      // Download ZIP file
      onStatus?.call('Downloading game lists from GitHub...');
      debugPrint('Downloading game lists from: $_gameListsRepoUrl');

      final request = http.Request('GET', Uri.parse(_gameListsRepoUrl));
      final response = await request.send();

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to download game lists: HTTP ${response.statusCode}',
        );
      }

      final contentLength = response.contentLength ?? 0;
      var downloadedBytes = 0;
      final chunks = <int>[];

      await for (final chunk in response.stream) {
        chunks.addAll(chunk);
        downloadedBytes += chunk.length;

        if (contentLength > 0) {
          final progress = downloadedBytes / contentLength;
          onProgress?.call(progress * 0.5); // First 50% is download
          onStatus?.call(
            'Downloading... ${(progress * 100).toStringAsFixed(0)}%',
          );
        }
      }

      // Write ZIP file
      onStatus?.call('Saving archive...');
      final zipFile = File(zipPath);
      await zipFile.writeAsBytes(chunks);
      debugPrint('Downloaded ${chunks.length} bytes to $zipPath');

      // Extract ZIP file
      onStatus?.call('Extracting archive...');
      onProgress?.call(0.6);

      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      // Extract to emulators path (will create romlists-main/)
      for (final file in archive) {
        final filename = path.join(resolvedPath, file.name);
        if (file.isFile) {
          final outFile = File(filename);
          await outFile.create(recursive: true);
          await outFile.writeAsBytes(file.content as List<int>);
        } else {
          await Directory(filename).create(recursive: true);
        }
      }

      onProgress?.call(0.8);

      // Delete ZIP file
      await zipFile.delete();

      // Rename romlists-main to lists
      final extractedDir = Directory(path.join(resolvedPath, 'romlists-main'));
      if (await extractedDir.exists()) {
        await extractedDir.rename(listsDir.path);
      }

      onStatus?.call('Game lists downloaded successfully');
      onProgress?.call(1.0);

      debugPrint('Game lists extracted to: ${listsDir.path}');
      return listsDir.path;
    } catch (e) {
      debugPrint('Error downloading game lists: $e');
      rethrow;
    }
  }

  /// Generates fake ROM files with download URLs
  ///
  /// Reads the downloaded game list *.txt files and creates fake ROM files
  /// in the roms/ directory. Each ROM file contains the download URL.
  ///
  /// Format of *.txt files:
  /// ```
  /// Game Name=URL*metadata
  /// Another Game=URL*metadata
  /// ```
  ///
  /// Creates ROM files like:
  /// - roms/nes/Game Name.nes (contains URL)
  /// - roms/snes/Another Game.snes (contains URL)
  ///
  /// Progress is reported through [onProgress] (0.0 to 1.0)
  /// Status messages are reported through [onStatus]
  Future<void> generateFakeRoms({
    Function(double progress)? onProgress,
    Function(String status)? onStatus,
  }) async {
    final emulatorsPath = dotenv.env['EMULATORS_PATH'];
    if (emulatorsPath == null || emulatorsPath.isEmpty) {
      throw Exception('EMULATORS_PATH not configured in .env');
    }

    // Resolve ~ to home directory
    final resolvedPath = emulatorsPath.replaceFirst(
      RegExp(r'^~'),
      Platform.environment['HOME'] ?? '',
    );

    final romsPath = dotenv.env['ROMS_PATH'];
    if (romsPath == null || romsPath.isEmpty) {
      throw Exception('ROMS_PATH not configured in .env');
    }

    final resolvedRomsPath = romsPath.replaceFirst(
      RegExp(r'^~'),
      Platform.environment['HOME'] ?? '',
    );

    final listsDir = Directory(path.join(resolvedPath, 'lists'));
    final romsDir = Directory(resolvedRomsPath);

    if (!await listsDir.exists()) {
      throw Exception(
        'Lists directory not found. Please download game lists first.',
      );
    }

    try {
      // Delete existing roms directory
      onStatus?.call('Cleaning up old ROMs...');
      if (await romsDir.exists()) {
        await romsDir.delete(recursive: true);
      }

      // Create roms directory structure
      await romsDir.create(recursive: true);
      await Directory(path.join(resolvedRomsPath, '_temp')).create();
      await Directory(path.join(resolvedRomsPath, '_forever')).create();

      // Get all .txt files in lists directory
      final txtFiles = await listsDir
          .list()
          .where((entity) => entity is File && entity.path.endsWith('.txt'))
          .cast<File>()
          .toList();

      if (txtFiles.isEmpty) {
        throw Exception('No game list files found in lists directory');
      }

      onStatus?.call('Found ${txtFiles.length} platforms');
      debugPrint('Processing ${txtFiles.length} platform files');

      var processedCount = 0;

      for (final txtFile in txtFiles) {
        // Get platform name from filename
        final fileName = path.basenameWithoutExtension(txtFile.path);

        // Convert underscores to directory separators
        // e.g., "nes_special" -> "nes/special"
        final platformPath = fileName.replaceAll('_', '/');
        final romPlatformDir = Directory(
          path.join(resolvedRomsPath, platformPath),
        );
        await romPlatformDir.create(recursive: true);

        onStatus?.call('Processing $fileName...');
        debugPrint('Processing platform: $fileName');

        // Read all lines from the file
        final lines = await txtFile.readAsLines();
        var romCount = 0;

        for (final line in lines) {
          final trimmedLine = line.trim();
          if (trimmedLine.isEmpty) continue;

          try {
            // Parse line format: "Game Name=URL*metadata"
            final parts = trimmedLine.split('=');
            if (parts.length < 2) continue;

            final gameName = parts[0].trim();
            final urlPart = parts[1].split('*')[0].trim();

            if (gameName.isEmpty || urlPart.isEmpty) continue;

            // Create ROM file with game name
            final romFile = File(path.join(romPlatformDir.path, gameName));
            await romFile.writeAsString(urlPart);
            romCount++;
          } catch (e) {
            debugPrint('Error parsing line: $line - $e');
            // Continue with next line
          }
        }

        debugPrint('Created $romCount ROMs for $fileName');
        processedCount++;

        final progress = processedCount / txtFiles.length;
        onProgress?.call(progress);
        onStatus?.call(
          'Processed $processedCount/${txtFiles.length} platforms',
        );
      }

      onStatus?.call('Generated fake ROMs successfully');
      onProgress?.call(1.0);

      debugPrint('Fake ROMs generated in: $resolvedRomsPath');
    } catch (e) {
      debugPrint('Error generating fake ROMs: $e');
      rethrow;
    }
  }

  /// Copies game list metadata to ES-DE configuration directory
  ///
  /// Copies the gamelists/*.xml files from the downloaded lists
  /// to the ES-DE gamelists directory (~/.emulationstation/gamelists)
  Future<void> copyGameListsToESDE({Function(String status)? onStatus}) async {
    final emulatorsPath = dotenv.env['EMULATORS_PATH'];
    if (emulatorsPath == null || emulatorsPath.isEmpty) {
      throw Exception('EMULATORS_PATH not configured in .env');
    }

    // Resolve ~ to home directory
    final resolvedPath = emulatorsPath.replaceFirst(
      RegExp(r'^~'),
      Platform.environment['HOME'] ?? '',
    );

    final homeDir = Platform.environment['HOME'];
    if (homeDir == null) {
      throw Exception('HOME environment variable not set');
    }

    final sourceDir = Directory(path.join(resolvedPath, 'lists', 'gamelists'));
    final destDir = Directory(path.join(homeDir, 'ES-DE', 'gamelists'));

    if (!await sourceDir.exists()) {
      throw Exception('Gamelists directory not found in downloaded lists');
    }

    try {
      onStatus?.call('Copying game lists to ES-DE...');

      // Create destination directory
      await destDir.create(recursive: true);

      // Copy all files recursively
      await _copyDirectory(sourceDir, destDir);

      onStatus?.call('Game lists copied successfully');
      debugPrint('Copied game lists to: ${destDir.path}');
    } catch (e) {
      debugPrint('Error copying game lists: $e');
      rethrow;
    }
  }

  /// Helper method to recursively copy directories
  Future<void> _copyDirectory(Directory source, Directory destination) async {
    await destination.create(recursive: true);

    await for (final entity in source.list()) {
      if (entity is File) {
        final newPath = path.join(destination.path, path.basename(entity.path));
        await entity.copy(newPath);
      } else if (entity is Directory) {
        final newDir = Directory(
          path.join(destination.path, path.basename(entity.path)),
        );
        await _copyDirectory(entity, newDir);
      }
    }
  }

  /// Checks if game lists have been downloaded
  Future<bool> isGameListsDownloaded() async {
    final emulatorsPath = dotenv.env['EMULATORS_PATH'];
    if (emulatorsPath == null || emulatorsPath.isEmpty) {
      return false;
    }

    final resolvedPath = emulatorsPath.replaceFirst(
      RegExp(r'^~'),
      Platform.environment['HOME'] ?? '',
    );

    final listsDir = Directory(path.join(resolvedPath, 'lists'));
    return listsDir.exists();
  }

  /// Checks if fake ROMs have been generated
  Future<bool> isRomsGenerated() async {
    final romsPath = dotenv.env['ROMS_PATH'];
    if (romsPath == null || romsPath.isEmpty) {
      return false;
    }

    final resolvedPath = romsPath.replaceFirst(
      RegExp(r'^~'),
      Platform.environment['HOME'] ?? '',
    );

    final romsDir = Directory(resolvedPath);
    if (!await romsDir.exists()) return false;

    // Check if directory has any ROM files
    final files = await romsDir.list(recursive: true).toList();
    return files.whereType<File>().isNotEmpty;
  }
}
