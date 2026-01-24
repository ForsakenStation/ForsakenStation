import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forsaken/models/bios_requirement.dart';
import 'package:forsaken/services/bios_check_service.dart';
import 'package:forsaken/services/keyboard_service.dart';
import 'package:forsaken/widgets/common/controls_bottom_bar.dart';

class BiosHelpScreen extends StatefulWidget {
  const BiosHelpScreen({super.key});

  @override
  State<BiosHelpScreen> createState() => _BiosHelpScreenState();
}

class _BiosHelpScreenState extends State<BiosHelpScreen> {
  final KeyboardService _keyboardService = KeyboardService.instance;
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  bool _showOnlyMissing = false;
  List<BiosRequirement> _allRequirements = [];
  List<BiosRequirement> _filteredRequirements = [];

  @override
  void initState() {
    super.initState();
    _loadBiosData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadBiosData() async {
    setState(() => _isLoading = true);
    try {
      final requirements = await BiosCheckService.scanAllBios();
      setState(() {
        _allRequirements = requirements;
        _updateFilteredList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading BIOS data: $e');
      setState(() => _isLoading = false);
    }
  }

  void _updateFilteredList() {
    setState(() {
      if (_showOnlyMissing) {
        _filteredRequirements = BiosCheckService.filterMissing(
          _allRequirements,
        );
      } else {
        _filteredRequirements = _allRequirements;
      }
    });
  }

  void _toggleFilter() {
    setState(() {
      _showOnlyMissing = !_showOnlyMissing;
      _updateFilteredList();
    });
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    if (_keyboardService.isBackKey(key)) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }

    if (_keyboardService.isSelectKey(key)) {
      // Toggle filter on select
      _toggleFilter();
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.f5 ||
        key == LogicalKeyboardKey.browserRefresh) {
      _loadBiosData();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  Widget _buildStatusIcon(BiosRequirement requirement) {
    if (requirement.hasAllFiles) {
      return const Icon(Icons.check_circle, color: Colors.green, size: 20);
    } else if (requirement.hasSomeFiles) {
      return const Icon(Icons.warning, color: Colors.orange, size: 20);
    } else {
      return const Icon(Icons.cancel, color: Colors.red, size: 20);
    }
  }

  Color _getStatusColor(BiosRequirement requirement) {
    if (requirement.hasAllFiles) {
      return Colors.green.withValues(alpha: 0.1);
    } else if (requirement.hasSomeFiles) {
      return Colors.orange.withValues(alpha: 0.1);
    } else {
      return Colors.red.withValues(alpha: 0.1);
    }
  }

  Widget _buildBiosFileItem(BiosFile file) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        children: [
          Icon(
            file.found ? Icons.check_circle : Icons.cancel,
            color: file.found ? Colors.green : Colors.red,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.filename,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: file.found ? Colors.green : Colors.red,
                  ),
                ),
                if (file.description != null || file.region != null)
                  Text(
                    [
                      if (file.region != null) file.region,
                      if (file.description != null) file.description,
                    ].join(' - '),
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformCard(BiosRequirement requirement) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: _getStatusColor(requirement),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: _buildStatusIcon(requirement),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  requirement.displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              if (requirement.required)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'REQUIRED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'OPTIONAL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              '${requirement.foundCount}/${requirement.totalCount} files found',
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ),
          children: [
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Files list
                  ...requirement.files.map((file) => _buildBiosFileItem(file)),

                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  // Locations
                  Text(
                    'Locations:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...requirement.locations.map(
                    (location) => Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                      child: Text(
                        location,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                  // Notes
                  if (requirement.notes != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.blue.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Colors.blue[700],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              requirement.notes!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    final stats = BiosCheckService.getStatistics(_allRequirements);
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_outlined, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Summary',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryStat(
                'Complete',
                '${stats['platformsComplete']}',
                Colors.green,
              ),
              _buildSummaryStat(
                'Partial',
                '${stats['platformsPartial']}',
                Colors.orange,
              ),
              _buildSummaryStat(
                'Missing',
                '${stats['platformsMissing']}',
                Colors.red,
              ),
              _buildSummaryStat(
                'Files',
                '${stats['foundFiles']}/${stats['totalFiles']}',
                Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BIOS & Firmware Help'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _isLoading ? null : _loadBiosData,
              tooltip: 'Refresh (F5)',
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Summary
                  _buildSummary(),

                  // Filter toggle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SwitchListTile(
                      title: const Text('Show only missing'),
                      value: _showOnlyMissing,
                      onChanged: (value) => _toggleFilter(),
                    ),
                  ),

                  // Platform list
                  Expanded(
                    child: _filteredRequirements.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _showOnlyMissing
                                      ? 'All BIOS files found!'
                                      : 'No BIOS requirements found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: _filteredRequirements.length,
                            itemBuilder: (context, index) {
                              return _buildPlatformCard(
                                _filteredRequirements[index],
                              );
                            },
                          ),
                  ),

                  // Bottom controls bar
                  ControlsBottomBar(
                    actions: const [
                      BottomBarAction(
                        label: 'Back',
                        keyboardKey: 'ESC',
                        gamepadButton: 'B',
                      ),
                      BottomBarAction(
                        label: 'Toggle Filter',
                        keyboardKey: 'Enter',
                        gamepadButton: 'A',
                      ),
                      BottomBarAction(
                        label: 'Refresh',
                        keyboardKey: 'F5',
                        gamepadButton: 'Start',
                      ),
                    ],
                    counterText: _filteredRequirements.isEmpty
                        ? null
                        : '${_filteredRequirements.length} platforms',
                  ),
                ],
              ),
      ),
    );
  }
}
