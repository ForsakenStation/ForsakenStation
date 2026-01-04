import 'dart:io';
import 'package:flutter/material.dart';
import '../models/rom.dart';
import '../models/media.dart';
import '../services/media_service.dart';

class RomCard extends StatelessWidget {
  final Rom rom;
  final RomMedia? media;
  final bool isLoadingMedia;
  final VoidCallback onLaunch;
  final MediaService mediaService;

  const RomCard({
    super.key,
    required this.rom,
    this.media,
    this.isLoadingMedia = false,
    required this.onLaunch,
    required this.mediaService,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onLaunch,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildThumbnail(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rom.displayName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rom.platform.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (media?.hasAnyMedia ?? false) ...[
                      const SizedBox(height: 8),
                      _buildMediaIndicators(),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.play_arrow),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    if (isLoadingMedia) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    final imagePath = media != null
        ? mediaService.getBestImagePath(media!)
        : null;

    if (imagePath != null && File(imagePath).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(imagePath),
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _defaultThumbnail(),
        ),
      );
    }

    return _defaultThumbnail();
  }

  Widget _defaultThumbnail() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.games, size: 40, color: Colors.grey),
    );
  }

  Widget _buildMediaIndicators() {
    return Row(
      children: [
        if (media?.box3d?.exists ?? false)
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.view_in_ar, size: 16, color: Colors.purple),
          ),
        if (media?.cover?.exists ?? false)
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.image, size: 16, color: Colors.blue),
          ),
        if (media?.marquee?.exists ?? false)
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.rectangle, size: 16, color: Colors.indigo),
          ),
        if (media?.screenshot?.exists ?? false)
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.photo_camera, size: 16, color: Colors.green),
          ),
        if (media?.mixImage?.exists ?? false)
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.collections, size: 16, color: Colors.teal),
          ),
        if (media?.video?.exists ?? false)
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.videocam, size: 16, color: Colors.orange),
          ),
      ],
    );
  }
}
