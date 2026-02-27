import 'package:flutter/material.dart';
import '../../../models/emulator_platform.dart';
import '../../../widgets/common/platform_logo.dart';
import '../../../services/media_service.dart';

class RomsHeader extends StatelessWidget {
  final EmulatorPlatform platform;
  final int itemCount;
  final Widget? logoWidget;
  final VoidCallback onBack;

  const RomsHeader({
    super.key,
    required this.platform,
    required this.itemCount,
    this.logoWidget,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBack,
            tooltip: 'Back to Platforms',
          ),
          const SizedBox(width: 8),
          Hero(
            tag: 'platform_logo_${platform.name}',
            child: SizedBox(
              width: 100,
              height: 50,
              child:
                  logoWidget ??
                  PlatformLogo(
                    platformName: platform.name,
                    mediaService: MediaService.instance,
                  ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  platform.displayName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '$itemCount items',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
