import 'package:flutter/material.dart';
import '../../services/platform_info_service.dart';

/// Compact, high-contrast badge showing a ROM's platform display name.
class PlatformBadge extends StatefulWidget {
  final String platformId;
  final bool compact;

  const PlatformBadge({
    super.key,
    required this.platformId,
    this.compact = false,
  });

  @override
  State<PlatformBadge> createState() => _PlatformBadgeState();
}

class _PlatformBadgeState extends State<PlatformBadge> {
  String? _displayName;

  @override
  void initState() {
    super.initState();
    _resolveDisplayName();
  }

  @override
  void didUpdateWidget(PlatformBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.platformId != widget.platformId) {
      _displayName = null;
      _resolveDisplayName();
    }
  }

  Future<void> _resolveDisplayName() async {
    final info = await PlatformInfoService.instance.getPlatformInfo(
      widget.platformId,
    );
    if (mounted && info != null) {
      setState(() {
        _displayName = info.fullName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = _displayName ?? widget.platformId.toUpperCase();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.compact ? 6 : 8,
        vertical: widget.compact ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.16),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.videogame_asset_rounded,
            size: widget.compact ? 11 : 13,
            color: Colors.white.withValues(alpha: 0.8),
          ),
          SizedBox(width: widget.compact ? 4 : 5),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: widget.compact ? 10 : 11,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.9),
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
