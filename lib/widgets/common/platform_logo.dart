import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../services/media_service.dart';
import '../../utils/platform_icons.dart';

/// Widget that displays a platform logo with icon fallback
///
/// Uses MediaService to load the platform logo from assets.
/// If the logo doesn't exist or fails to load, falls back to the platform icon.
class PlatformLogo extends StatefulWidget {
  final String platformName;
  final double size;
  final Color? iconColor;
  final MediaService? mediaService;

  const PlatformLogo({
    super.key,
    required this.platformName,
    this.size = 32,
    this.iconColor,
    this.mediaService,
  });

  @override
  State<PlatformLogo> createState() => _PlatformLogoState();
}

class _PlatformLogoState extends State<PlatformLogo> {
  String? _logoPath;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogo();
  }

  Future<void> _loadLogo() async {
    try {
      final mediaService =
          widget.mediaService ?? MediaService(mediaBasePath: '');
      final logoPath = await mediaService.getSystemLogo(widget.platformName);

      if (mounted) {
        setState(() {
          _logoPath = logoPath;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _logoPath = null;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: _buildFallbackIcon(),
      );
    }

    if (_logoPath == null) {
      return _buildFallbackIcon();
    }

    return _buildLogoFromPath(_logoPath!);
  }

  Widget _buildLogoFromPath(String path) {
    final isSvg = path.toLowerCase().endsWith('.svg');

    if (isSvg) {
      return SvgPicture.asset(
        path,
        width: widget.size,
        placeholderBuilder: (context) => _buildFallbackIcon(),
      );
    } else {
      return Image.asset(
        path,
        width: widget.size,
        errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
      );
    }
  }

  Widget _buildFallbackIcon() {
    return Icon(
      PlatformIcons.getIconForPlatform(widget.platformName),
      size: widget.size,
      color: widget.iconColor,
    );
  }
}
