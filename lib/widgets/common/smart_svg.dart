import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Smart SVG widget that handles both .svg and .svgz (gzip-compressed) files
/// Automatically detects format and decompresses SVGZ in memory
class SmartSvg extends StatefulWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ColorFilter? colorFilter;
  final Alignment alignment;
  final String? semanticsLabel;
  final bool matchTextDirection;
  final Widget Function(BuildContext)? placeholderBuilder;

  const SmartSvg({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.colorFilter,
    this.alignment = Alignment.center,
    this.semanticsLabel,
    this.matchTextDirection = false,
    this.placeholderBuilder,
  });

  /// Factory for asset SVG/SVGZ files
  factory SmartSvg.asset(
    String assetPath, {
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    ColorFilter? colorFilter,
    Color? color, // For convenience, converted to colorFilter
    Alignment alignment = Alignment.center,
    String? semanticsLabel,
    bool matchTextDirection = false,
    Widget Function(BuildContext)? placeholderBuilder,
  }) {
    // Convert color to colorFilter if provided
    ColorFilter? finalColorFilter = colorFilter;
    if (color != null && colorFilter == null) {
      finalColorFilter = ColorFilter.mode(color, BlendMode.srcIn);
    }

    return SmartSvg(
      key: key,
      assetPath: assetPath,
      width: width,
      height: height,
      fit: fit,
      colorFilter: finalColorFilter,
      alignment: alignment,
      semanticsLabel: semanticsLabel,
      matchTextDirection: matchTextDirection,
      placeholderBuilder: placeholderBuilder,
    );
  }

  @override
  State<SmartSvg> createState() => _SmartSvgState();
}

class _SmartSvgState extends State<SmartSvg> {
  Future<String>? _decompressFuture;

  @override
  void initState() {
    super.initState();
    // Cache the future on initialization to prevent rebuilds
    if (_isSvgz(widget.assetPath)) {
      _decompressFuture = _loadAndDecompressSvgz(widget.assetPath);
    }
  }

  @override
  void didUpdateWidget(SmartSvg oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only recreate the future if the asset path changed
    if (oldWidget.assetPath != widget.assetPath && _isSvgz(widget.assetPath)) {
      _decompressFuture = _loadAndDecompressSvgz(widget.assetPath);
    }
  }

  bool _isSvgz(String path) {
    return path.toLowerCase().endsWith('.svgz');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🎨 [SmartSvg] Building widget for: ${widget.assetPath}');
    if (_isSvgz(widget.assetPath)) {
      debugPrint('📦 [SmartSvg] Detected SVGZ format');
      // Handle SVGZ - load and decompress using cached future
      return FutureBuilder<String>(
        future: _decompressFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return widget.placeholderBuilder?.call(context) ??
                SizedBox(
                  width: widget.width,
                  height: widget.height,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
          }

          if (snapshot.hasError) {
            debugPrint('Error loading SVGZ: ${snapshot.error}');
            return _buildErrorWidget();
          }

          if (!snapshot.hasData) {
            return _buildErrorWidget();
          }

          // Render decompressed SVG string
          return SvgPicture.string(
            snapshot.data!,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            colorFilter: widget.colorFilter,
            alignment: widget.alignment,
            semanticsLabel: widget.semanticsLabel,
            matchTextDirection: widget.matchTextDirection,
          );
        },
      );
    } else {
      // Handle regular SVG
      return SvgPicture.asset(
        widget.assetPath,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        colorFilter: widget.colorFilter,
        alignment: widget.alignment,
        semanticsLabel: widget.semanticsLabel,
        matchTextDirection: widget.matchTextDirection,
        placeholderBuilder: widget.placeholderBuilder,
      );
    }
  }

  Widget _buildErrorWidget() {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }

  /// Load and decompress SVGZ file from assets
  Future<String> _loadAndDecompressSvgz(String assetPath) async {
    try {
      debugPrint('🔧 [SmartSvg] Loading SVGZ from: $assetPath');
      // Load compressed data from assets
      final ByteData data = await rootBundle.load(assetPath);
      debugPrint('✅ [SmartSvg] Loaded ${data.lengthInBytes} bytes');
      final List<int> bytes = data.buffer.asUint8List();

      // Decompress using gzip
      final List<int> decompressed = GZipCodec().decode(bytes);
      debugPrint('✅ [SmartSvg] Decompressed to ${decompressed.length} bytes');

      // Convert to string
      final result = String.fromCharCodes(decompressed);
      debugPrint(
        '✅ [SmartSvg] Successfully converted to string (${result.length} chars)',
      );
      return result;
    } catch (e) {
      debugPrint('❌ [SmartSvg] Failed to decompress SVGZ from $assetPath: $e');
      rethrow;
    }
  }
}

/// Extension for SvgPicture to easily create Smart SVG widgets
extension SmartSvgExtension on SvgPicture {
  static Widget smartAsset(
    String assetPath, {
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    ColorFilter? colorFilter,
    Color? color,
    Alignment alignment = Alignment.center,
    String? semanticsLabel,
    bool matchTextDirection = false,
    Widget Function(BuildContext)? placeholderBuilder,
  }) {
    return SmartSvg.asset(
      assetPath,
      key: key,
      width: width,
      height: height,
      fit: fit,
      colorFilter: colorFilter,
      color: color,
      alignment: alignment,
      semanticsLabel: semanticsLabel,
      matchTextDirection: matchTextDirection,
      placeholderBuilder: placeholderBuilder,
    );
  }
}
