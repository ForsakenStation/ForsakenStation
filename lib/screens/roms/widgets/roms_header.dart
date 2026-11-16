import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../models/emulator_platform.dart';
import '../../../widgets/common/platform_logo.dart';
import '../../../services/media_service.dart';
import '../../../l10n/generated/app_localizations.dart';

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
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.35),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
          ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBack,
            tooltip: AppLocalizations.of(context)!.back,
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
                  AppLocalizations.of(context)!.romsCount(itemCount),
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ],
      ),
        ),
      ),
    );
  }
}
