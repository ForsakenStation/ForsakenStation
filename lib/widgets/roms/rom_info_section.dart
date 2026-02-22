import 'package:flutter/material.dart';
import '../../models/game_info.dart';
import '../common/info_row.dart';

/// Shared widget that renders the standard ROM information rows
/// (Description, Release Date/Developer, Publisher/Genre, Players/Rating).
///
/// Used by both [RomDetailPanel] and [RomDetailDialog] to avoid duplication.
class RomInfoSection extends StatelessWidget {
  const RomInfoSection({
    super.key,
    required this.gameInfo,
    this.rowSpacing = 16.0,
    this.columnGap = 16.0,
  });

  /// The game info to display. May be null (fields will show empty).
  final GameInfo? gameInfo;

  /// Vertical spacing between rows.
  final double rowSpacing;

  /// Horizontal gap between columns in a row.
  final double columnGap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        InfoRow(
          label: 'Description',
          value: gameInfo?.desc ?? 'No description available for this ROM.',
        ),
        SizedBox(height: rowSpacing),

        // Row 1: Release Date, Developer
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: InfoRow(
                label: 'Release Date',
                value: gameInfo?.releaseDate?.toString().split(' ')[0] ?? '',
              ),
            ),
            SizedBox(width: columnGap),
            Expanded(
              child: InfoRow(
                label: 'Developer',
                value: gameInfo?.developer ?? '',
              ),
            ),
          ],
        ),
        SizedBox(height: rowSpacing),

        // Row 2: Publisher, Genre
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: InfoRow(
                label: 'Publisher',
                value: gameInfo?.publisher ?? '',
              ),
            ),
            SizedBox(width: columnGap),
            Expanded(
              child: InfoRow(label: 'Genre', value: gameInfo?.genre ?? ''),
            ),
          ],
        ),
        SizedBox(height: rowSpacing),

        // Row 3: Players, Rating
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: InfoRow(
                label: 'Players',
                value: gameInfo?.playersText ?? '',
              ),
            ),
            SizedBox(width: columnGap),
            Expanded(
              child: InfoRow(
                label: 'Rating',
                value: gameInfo?.ratingPercentage ?? '--',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
