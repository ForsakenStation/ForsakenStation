import 'package:flutter/material.dart';
import '../../../../utils/format_utils.dart';
import '../../../../l10n/generated/app_localizations.dart';

class StorageStatisticsCard extends StatelessWidget {
  final Map<String, dynamic> stats;
  final VoidCallback onClearTemp;

  const StorageStatisticsCard({
    super.key,
    required this.stats,
    required this.onClearTemp,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, l10n),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    l10n.temporary,
                    Icons.access_time,
                    stats['tempCount'] ?? 0,
                    stats['tempSize'] ?? 0,
                    Colors.orange,
                    l10n,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    context,
                    l10n.permanent,
                    Icons.cloud_done,
                    stats['foreverCount'] ?? 0,
                    stats['foreverSize'] ?? 0,
                    Colors.green,
                    l10n,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildPathInfo(
              context,
              l10n.tempPathLabel,
              stats['tempPath'],
              l10n,
            ),
            _buildPathInfo(
              context,
              l10n.foreverPathLabel,
              stats['foreverPath'],
              l10n,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Icon(Icons.storage, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            l10n.storageOverview,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        if ((stats['tempCount'] ?? 0) > 0)
          IconButton(
            icon: const Icon(Icons.cleaning_services, size: 20),
            onPressed: onClearTemp,
            tooltip: l10n.clearTemporaryStorage,
          ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    IconData icon,
    int count,
    int bytes,
    Color color,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.filesCount(count.toString()),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            formatBytes(bytes),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPathInfo(
    BuildContext context,
    String label,
    String? path,
    AppLocalizations l10n,
  ) {
    return Text(
      l10n.pathDisplay(label, path ?? l10n.unknown),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontFamily: 'monospace',
        color: Colors.grey[600],
      ),
    );
  }
}
