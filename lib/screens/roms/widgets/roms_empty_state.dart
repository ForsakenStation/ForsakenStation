import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';

class RomsEmptyState extends StatelessWidget {
  final bool isSearchMode;
  final VoidCallback onClearSearch;

  const RomsEmptyState({
    super.key,
    required this.isSearchMode,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearchMode ? Icons.search_off : Icons.videogame_asset_off,
            size: 80,
            color: Colors.grey[800],
          ),
          const SizedBox(height: 24),
          Text(
            isSearchMode ? l10n.noGamesFoundForSearch : l10n.noGamesFound,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[400],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isSearchMode
                ? l10n.tryDifferentSearchOrClear
                : l10n.checkStorageOrDownload,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          if (isSearchMode) ...[
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onClearSearch,
              icon: const Icon(Icons.clear_all),
              label: Text(l10n.clearSearch),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan[900],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
