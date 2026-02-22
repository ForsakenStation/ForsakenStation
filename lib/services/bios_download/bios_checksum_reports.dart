/// Report for individual BIOS file checksum verification
class BiosFileChecksumReport {
  final String filename;
  final bool exists;
  final bool hasChecksum;
  final String? expectedMd5;
  final String? actualMd5;
  final String? expectedSha1;
  final String? actualSha1;
  final bool? md5Match;
  final bool? sha1Match;
  final bool? verificationPassed;
  final int? fileSize;
  final int? expectedSize;
  final String? error;

  const BiosFileChecksumReport({
    required this.filename,
    required this.exists,
    required this.hasChecksum,
    this.expectedMd5,
    this.actualMd5,
    this.expectedSha1,
    this.actualSha1,
    this.md5Match,
    this.sha1Match,
    this.verificationPassed,
    this.fileSize,
    this.expectedSize,
    this.error,
  });
}

/// Report for platform checksum verification
class PlatformChecksumReport {
  final String platformId;
  final List<BiosFileChecksumReport> files;

  const PlatformChecksumReport({required this.platformId, required this.files});

  int get totalFiles => files.length;
  int get verifiedFiles =>
      files.where((f) => f.verificationPassed == true).length;
  int get failedFiles =>
      files.where((f) => f.verificationPassed == false).length;
  int get missingFiles => files.where((f) => !f.exists).length;
}

/// Comprehensive BIOS checksum verification report
class BiosChecksumReport {
  final int totalFiles;
  final int verifiedFiles;
  final int missingChecksums;
  final int failedVerifications;
  final Map<String, PlatformChecksumReport> platformReports;
  final DateTime generatedAt;

  const BiosChecksumReport({
    required this.totalFiles,
    required this.verifiedFiles,
    required this.missingChecksums,
    required this.failedVerifications,
    required this.platformReports,
    required this.generatedAt,
  });

  double get verificationCoverage {
    if (totalFiles == 0) return 0.0;
    return (totalFiles - missingChecksums) / totalFiles;
  }

  double get verificationSuccessRate {
    final filesWithChecksums = totalFiles - missingChecksums;
    if (filesWithChecksums == 0) return 0.0;
    return verifiedFiles / filesWithChecksums;
  }
}
