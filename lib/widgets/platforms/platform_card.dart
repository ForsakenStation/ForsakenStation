import 'package:flutter/material.dart';
import '../../models/platform.dart';
import '../../utils/platform_icons.dart';
import '../common/smart_svg.dart';

/// Card widget for displaying a platform in grid view
class PlatformCard extends StatefulWidget {
  final Platform platform;
  final VoidCallback onTap;
  final String? logoPath;
  final String? backgroundPath;
  final VoidCallback onLoadLogo;
  final VoidCallback onLoadBackground;
  final bool isSelected;

  const PlatformCard({
    super.key,
    required this.platform,
    required this.onTap,
    required this.logoPath,
    required this.backgroundPath,
    required this.onLoadLogo,
    required this.onLoadBackground,
    this.isSelected = false,
  });

  @override
  State<PlatformCard> createState() => _PlatformCardState();
}

class _PlatformCardState extends State<PlatformCard> {
  @override
  void initState() {
    super.initState();
    // Trigger lazy loading of logo and background
    if (widget.logoPath == null) {
      widget.onLoadLogo();
    }
    if (widget.backgroundPath == null) {
      widget.onLoadBackground();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: widget.isSelected ? 8 : 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: widget.isSelected
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 3)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: widget.onTap,
        child: Stack(
          children: [
            // Background image (full card)
            if (widget.backgroundPath != null)
              Positioned.fill(
                child: Image.asset(
                  widget.backgroundPath!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Theme.of(context).colorScheme.surface),
                ),
              ),
            // Gradient overlay to ensure text readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo section
                Expanded(
                  flex: 3,
                  child: Center(
                    child: widget.logoPath != null
                        ? _buildLogoImage(widget.logoPath!, height: 80)
                        : _buildFallbackIcon(),
                  ),
                ),
                // Info section
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.platform.displayName,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    const Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 3,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.platform.romCount} ROMs',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.white70,
                                  shadows: [
                                    const Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 3,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.primaryContainer.withValues(alpha: 0.8),
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(16),
      child: Icon(
        PlatformIcons.getIconForPlatform(widget.platform.name),
        size: 64,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildLogoImage(String logoPath, {required double height}) {
    final isSvg =
        logoPath.toLowerCase().endsWith('.svg') ||
        logoPath.toLowerCase().endsWith('.svgz');

    if (isSvg) {
      return SmartSvg.asset(
        logoPath,
        height: height,
        fit: BoxFit.contain,
        placeholderBuilder: (context) => _buildFallbackIcon(),
      );
    } else {
      return Image.asset(
        logoPath,
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
      );
    }
  }
}
