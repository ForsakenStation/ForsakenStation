import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'debug_service.dart';

/// Service for generating and verifying BIOS file checksums
class BiosChecksumService {
  /// Calculate MD5 checksum of a file
  static Future<String> calculateMd5(File file) async {
    final bytes = await file.readAsBytes();
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  /// Calculate SHA1 checksum of a file
  static Future<String> calculateSha1(File file) async {
    final bytes = await file.readAsBytes();
    final digest = sha1.convert(bytes);
    return digest.toString();
  }

  /// Calculate SHA256 checksum of a file
  static Future<String> calculateSha256(File file) async {
    final bytes = await file.readAsBytes();
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Calculate CRC32 checksum of a file
  static Future<String> calculateCrc32(File file) async {
    final bytes = await file.readAsBytes();
    final crc32 = _calculateCrc32(bytes);
    return crc32.toRadixString(16).padLeft(8, '0').toUpperCase();
  }

  /// Internal CRC32 calculation using standard CRC32 algorithm
  static int _calculateCrc32(Uint8List bytes) {
    const int crc32Poly = 0xEDB88320;

    // Pre-computed CRC32 lookup table
    final List<int> crcTable = List<int>.filled(256, 0);
    for (int i = 0; i < 256; i++) {
      int crc = i;
      for (int j = 0; j < 8; j++) {
        if ((crc & 1) != 0) {
          crc = (crc >> 1) ^ crc32Poly;
        } else {
          crc = crc >> 1;
        }
      }
      crcTable[i] = crc;
    }

    // Calculate CRC32
    int crc = 0xFFFFFFFF;
    for (int byte in bytes) {
      crc = crcTable[(crc ^ byte) & 0xFF] ^ (crc >> 8);
    }

    return crc ^ 0xFFFFFFFF;
  }

  /// Generate comprehensive checksum information for a file
  static Future<Map<String, dynamic>> generateFileInfo(File file) async {
    if (!await file.exists()) {
      throw FileSystemException('File does not exist', file.path);
    }

    final stat = await file.stat();
    final bytes = await file.readAsBytes();

    return {
      'filename': file.path.split('/').last,
      'path': file.path,
      'size': stat.size,
      'modified': stat.modified.toIso8601String(),
      'md5': md5.convert(bytes).toString(),
      'sha1': sha1.convert(bytes).toString(),
      'sha256': sha256.convert(bytes).toString(),
      'crc32': _calculateCrc32(
        bytes,
      ).toRadixString(16).padLeft(8, '0').toUpperCase(),
    };
  }

  /// Verify file integrity using multiple checksum methods
  static Future<ChecksumVerificationResult> verifyFile({
    required File file,
    String? expectedMd5,
    String? expectedSha1,
    String? expectedSha256,
    String? expectedCrc32,
    int? expectedSize,
  }) async {
    if (!await file.exists()) {
      return ChecksumVerificationResult(
        success: false,
        error: 'File does not exist: ${file.path}',
      );
    }

    try {
      final fileInfo = await generateFileInfo(file);
      final results = <String, bool>{};
      final errors = <String>[];

      // Verify size if provided
      if (expectedSize != null) {
        final sizeMatches = fileInfo['size'] == expectedSize;
        results['size'] = sizeMatches;
        if (!sizeMatches) {
          errors.add(
            'Size mismatch: expected $expectedSize, got ${fileInfo['size']}',
          );
        }
      }

      // Verify MD5 if provided
      if (expectedMd5 != null) {
        final md5Matches =
            fileInfo['md5'].toLowerCase() == expectedMd5.toLowerCase();
        results['md5'] = md5Matches;
        if (!md5Matches) {
          errors.add(
            'MD5 mismatch: expected $expectedMd5, got ${fileInfo['md5']}',
          );
        }
      }

      // Verify SHA1 if provided
      if (expectedSha1 != null) {
        final sha1Matches =
            fileInfo['sha1'].toLowerCase() == expectedSha1.toLowerCase();
        results['sha1'] = sha1Matches;
        if (!sha1Matches) {
          errors.add(
            'SHA1 mismatch: expected $expectedSha1, got ${fileInfo['sha1']}',
          );
        }
      }

      // Verify SHA256 if provided
      if (expectedSha256 != null) {
        final sha256Matches =
            fileInfo['sha256'].toLowerCase() == expectedSha256.toLowerCase();
        results['sha256'] = sha256Matches;
        if (!sha256Matches) {
          errors.add(
            'SHA256 mismatch: expected $expectedSha256, got ${fileInfo['sha256']}',
          );
        }
      }

      // Verify CRC32 if provided
      if (expectedCrc32 != null) {
        final crc32Matches =
            fileInfo['crc32'].toLowerCase() == expectedCrc32.toLowerCase();
        results['crc32'] = crc32Matches;
        if (!crc32Matches) {
          errors.add(
            'CRC32 mismatch: expected $expectedCrc32, got ${fileInfo['crc32']}',
          );
        }
      }

      final allChecksumsPassed =
          results.values.isEmpty || results.values.every((result) => result);

      return ChecksumVerificationResult(
        success: allChecksumsPassed,
        fileInfo: fileInfo,
        verificationResults: results,
        error: errors.isNotEmpty ? errors.join('; ') : null,
      );
    } catch (e) {
      return ChecksumVerificationResult(
        success: false,
        error: 'Verification failed: $e',
      );
    }
  }

  /// Generate checksums for multiple files in a directory
  static Future<List<Map<String, dynamic>>> generateDirectoryInfo(
    Directory directory, {
    List<String>? fileExtensions,
    bool recursive = false,
  }) async {
    if (!await directory.exists()) {
      throw FileSystemException('Directory does not exist', directory.path);
    }

    final results = <Map<String, dynamic>>[];

    await for (final entity in directory.list(recursive: recursive)) {
      if (entity is File) {
        // Filter by file extensions if specified
        if (fileExtensions != null && fileExtensions.isNotEmpty) {
          final extension = entity.path.split('.').last.toLowerCase();
          if (!fileExtensions
              .map((ext) => ext.toLowerCase())
              .contains(extension)) {
            continue;
          }
        }

        try {
          final fileInfo = await generateFileInfo(entity);
          results.add(fileInfo);
        } catch (e) {
          DebugService.instance.error(
            'Error processing file ${entity.path}: $e',
            tag: 'BiosChecksum',
          );
        }
      }
    }

    return results;
  }
}

/// Result of checksum verification
class ChecksumVerificationResult {
  final bool success;
  final Map<String, dynamic>? fileInfo;
  final Map<String, bool>? verificationResults;
  final String? error;

  const ChecksumVerificationResult({
    required this.success,
    this.fileInfo,
    this.verificationResults,
    this.error,
  });

  @override
  String toString() {
    if (!success) {
      return 'Verification failed: $error';
    }

    final buffer = StringBuffer('Verification passed');
    if (verificationResults != null && verificationResults!.isNotEmpty) {
      buffer.write(' (');
      buffer.write(
        verificationResults!.entries
            .map((entry) => '${entry.key}: ${entry.value ? "✓" : "✗"}')
            .join(', '),
      );
      buffer.write(')');
    }
    return buffer.toString();
  }
}
