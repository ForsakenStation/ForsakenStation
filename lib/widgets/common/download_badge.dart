import 'package:flutter/material.dart';

/// Badge indicating a ROM is downloaded / available locally.
///
/// Use [compact] for smaller contexts (list cards) and the default
/// for larger contexts (grid cards).
class DownloadBadge extends StatelessWidget {
  const DownloadBadge({super.key, required this.future, this.compact = false});

  /// Future that resolves to true when the ROM is downloaded.
  final Future<bool> future;

  /// Whether to use compact styling (smaller icon, no shadow).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          final iconSize = compact ? 14.0 : 20.0;
          final padding = compact ? 4.0 : 6.0;
          final radius = compact ? 12.0 : 20.0;

          return Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(radius),
              boxShadow: compact
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Icon(Icons.cloud_done, color: Colors.white, size: iconSize),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
