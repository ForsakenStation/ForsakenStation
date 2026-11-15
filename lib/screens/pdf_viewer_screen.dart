import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:path/path.dart' as path;
import '../services/debug_service.dart';
import '../services/gamepad_service.dart';
import '../widgets/common/controls_bottom_bar.dart';
import '../l10n/generated/app_localizations.dart';

/// Full-screen PDF viewer with page navigation and zoom
/// Works on all platforms including Linux desktop
/// Supports keyboard shortcuts and gamepad controls
class PdfViewerScreen extends StatefulWidget {
  final String pdfPath;
  final String? title;

  const PdfViewerScreen({super.key, required this.pdfPath, this.title});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final PdfViewerController _controller = PdfViewerController();
  final GamepadService _gamepadService = GamepadService.instance;

  int _currentPage = 1;
  int _totalPages = 0;
  Timer? _gamepadPollTimer;
  PdfDocument? _pdfDocument;

  // Focus node for keyboard shortcuts
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updatePageInfo);
    _startGamepadPolling();
    _loadPdfDocument();

    // Request focus for keyboard shortcuts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  /// Load PDF document
  Future<void> _loadPdfDocument() async {
    try {
      final doc = await PdfDocument.openFile(widget.pdfPath);
      if (mounted) {
        setState(() {
          _pdfDocument = doc;
          _totalPages = doc.pages.length;
        });
      }
    } catch (e) {
      DebugService.instance.error('Error loading PDF: $e', tag: 'PdfViewer');
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updatePageInfo);
    _gamepadPollTimer?.cancel();
    _focusNode.dispose();
    _pdfDocument?.dispose();
    super.dispose();
  }

  void _updatePageInfo() {
    if (mounted && _pdfDocument != null) {
      final pageNum = _controller.pageNumber ?? 1;
      final pageCount = _pdfDocument!.pages.length;

      if (pageNum != _currentPage || pageCount != _totalPages) {
        setState(() {
          _currentPage = pageNum;
          _totalPages = pageCount;
        });
      }
    }
  }

  /// Start polling gamepad state periodically
  void _startGamepadPolling() {
    _gamepadPollTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => _handleGamepadInput(),
    );
  }

  /// Handle gamepad input
  void _handleGamepadInput() {
    if (!_gamepadService.isGamepadConnected) return;

    // Back button - close viewer
    if (_gamepadService.isBackPressed()) {
      Navigator.pop(context);
      return;
    }

    // Navigation
    final direction = _gamepadService.getNavigationDirection();
    if (direction != null) {
      switch (direction) {
        case 'up':
        case 'left':
          _previousPage();
          break;
        case 'down':
        case 'right':
          _nextPage();
          break;
      }
    }

    // L1/R1 - First/Last page
    if (_gamepadService.isPageDownPressed()) {
      _firstPage();
    } else if (_gamepadService.isPageUpPressed()) {
      _lastPage();
    }

    // L2/R2 - Zoom
    if (_gamepadService.isLeftTriggerPressed()) {
      _zoomOut();
    } else if (_gamepadService.isRightTriggerPressed()) {
      _zoomIn();
    }

    // X - Reset zoom
    if (_gamepadService.isSearchPressed()) {
      _resetZoom();
    }
  }

  /// Handle keyboard shortcuts
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    switch (event.logicalKey) {
      // Navigation
      case LogicalKeyboardKey.arrowRight:
      case LogicalKeyboardKey.pageDown:
      case LogicalKeyboardKey.space:
        _nextPage();
        return KeyEventResult.handled;

      case LogicalKeyboardKey.arrowLeft:
      case LogicalKeyboardKey.pageUp:
        _previousPage();
        return KeyEventResult.handled;

      case LogicalKeyboardKey.home:
        _firstPage();
        return KeyEventResult.handled;

      case LogicalKeyboardKey.end:
        _lastPage();
        return KeyEventResult.handled;

      // Zoom controls
      case LogicalKeyboardKey.equal:
      case LogicalKeyboardKey.add:
      case LogicalKeyboardKey.numpadAdd:
        _zoomIn();
        return KeyEventResult.handled;

      case LogicalKeyboardKey.minus:
      case LogicalKeyboardKey.numpadSubtract:
        _zoomOut();
        return KeyEventResult.handled;

      case LogicalKeyboardKey.digit0:
      case LogicalKeyboardKey.numpad0:
        _resetZoom();
        return KeyEventResult.handled;

      // Exit
      case LogicalKeyboardKey.escape:
      case LogicalKeyboardKey.backspace:
        Navigator.pop(context);
        return KeyEventResult.handled;

      default:
        return KeyEventResult.ignored;
    }
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      _controller.goToPage(pageNumber: page);
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages) {
      _controller.goToPage(pageNumber: _currentPage + 1);
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      _controller.goToPage(pageNumber: _currentPage - 1);
    }
  }

  void _firstPage() {
    _goToPage(1);
  }

  void _lastPage() {
    _goToPage(_totalPages);
  }

  void _zoomIn() {
    _controller.zoomUp();
  }

  void _zoomOut() {
    _controller.zoomDown();
  }

  void _resetZoom() {
    // Reset zoom by going to current page
    _controller.goToPage(pageNumber: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    final fileName = path.basename(widget.pdfPath);
    final displayTitle = widget.title ?? fileName;

    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      autofocus: true,
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayTitle,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
              if (_totalPages > 0)
                Text(
                  AppLocalizations.of(
                    context,
                  )!.pdfPageIndicator(_currentPage, _totalPages),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
            ],
          ),
          actions: [
            // Zoom controls
            IconButton(
              icon: const Icon(Icons.zoom_out),
              onPressed: _zoomOut,
              tooltip: AppLocalizations.of(context)!.pdfZoomOut,
            ),
            IconButton(
              icon: const Icon(Icons.zoom_in),
              onPressed: _zoomIn,
              tooltip: AppLocalizations.of(context)!.pdfZoomIn,
            ),
            IconButton(
              icon: const Icon(Icons.fit_screen),
              onPressed: _resetZoom,
              tooltip: AppLocalizations.of(context)!.pdfResetZoom,
            ),
            const SizedBox(width: 8),
            // Navigation controls
            IconButton(
              icon: const Icon(Icons.first_page),
              onPressed: _currentPage > 1 ? _firstPage : null,
              tooltip: AppLocalizations.of(context)!.pdfFirstPage,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: _currentPage > 1 ? _previousPage : null,
              tooltip: AppLocalizations.of(context)!.pdfPreviousPage,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: _currentPage < _totalPages ? _nextPage : null,
              tooltip: AppLocalizations.of(context)!.pdfNextPage,
            ),
            IconButton(
              icon: const Icon(Icons.last_page),
              onPressed: _currentPage < _totalPages ? _lastPage : null,
              tooltip: AppLocalizations.of(context)!.pdfLastPage,
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(child: _buildBody()),
            ControlsBottomBar(
              actions: [
                BottomBarAction(
                  label: AppLocalizations.of(context)!.navigate,
                  keyboardKey: '←/→',
                  gamepadButton: 'D-Pad',
                ),
                BottomBarAction(
                  label: AppLocalizations.of(context)!.firstLast,
                  keyboardKey: 'Home/End',
                  gamepadButton: 'L1/R1',
                ),
                BottomBarAction(
                  label: AppLocalizations.of(context)!.zoom,
                  keyboardKey: '+/-',
                  gamepadButton: 'L2/R2',
                ),
                BottomBarAction(
                  label: AppLocalizations.of(context)!.back,
                  keyboardKey: 'ESC',
                  gamepadButton: 'B',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    final file = File(widget.pdfPath);

    if (!file.existsSync()) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.pdfFileNotFound,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.pdfPath,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: Text(AppLocalizations.of(context)!.goBack),
              ),
            ],
          ),
        ),
      );
    }

    return PdfViewer.file(widget.pdfPath, controller: _controller);
  }
}
