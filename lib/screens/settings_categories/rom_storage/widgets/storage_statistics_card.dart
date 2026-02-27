import 'package:flutter/material.dart';
import '../../../../utils/format_utils.dart';

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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Temporary',
                    Icons.access_time,
                    stats['tempCount'] ?? 0,
                    stats['tempSize'] ?? 0,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Permanent',
                    Icons.cloud_done,
                    stats['foreverCount'] ?? 0,
                    stats['foreverSize'] ?? 0,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildPathInfo(context, 'Temp', stats['tempPath']),
            _buildPathInfo(context, 'Forever', stats['foreverPath']),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.storage, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Storage Overview',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        if ((stats['tempCount'] ?? 0) > 0)
          IconButton(
            icon: const Icon(Icons.cleaning_services, size: 20),
            onPressed: onClearTemp,
            tooltip: 'Clear temporary storage',
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
            '$count files',
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

  Widget _buildPathInfo(BuildContext context, String label, String? path) {
    return Text(
      '$label path: ${path ?? 'Unknown'}',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontFamily: 'monospace',
        color: Colors.grey[600],
      ),
    );
  }
}
