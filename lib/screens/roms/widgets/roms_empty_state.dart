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
            isSearchMode ? 'No games found for search' : 'No games found',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[400],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isSearchMode
                ? 'Try a different search term or clear the filter'
                : 'Check your storage settings or download some ROMs',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          if (isSearchMode) ...[
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onClearSearch,
              icon: const Icon(Icons.clear_all),
              label: Text(AppLocalizations.of(context)!.clearSearch),
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
