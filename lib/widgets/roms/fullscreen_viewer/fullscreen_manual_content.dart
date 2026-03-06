import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'fullscreen_viewer_controller.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../services/gamepad_service.dart';

class FullScreenManualContent extends StatefulWidget {
  final String path;
  final FullScreenViewerController controller;
  final bool isActive;

  const FullScreenManualContent({
    super.key,
    required this.path,
    required this.controller,
    this.isActive = false,
  });

  @override
  State<FullScreenManualContent> createState() =>
      _FullScreenManualContentState();
}

class _FullScreenManualContentState extends State<FullScreenManualContent> {
  final PdfViewerController _pdfController = PdfViewerController();
  bool _isPdf = false;
  int _currentPage = 1;
  int _totalPages = 0;
  Timer? _gamepadTimer;

  @override
  void initState() {
    super.initState();
    _isPdf = widget.path.toLowerCase().endsWith('.pdf');
    _pdfController.addListener(_updatePageInfo);

    if (_isPdf) {
      _startGamepadPolling();
    }
  }

  void _startGamepadPolling() {
    _gamepadTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted || !widget.isActive) return;

      final gamepad = GamepadService.instance;

      // L1/R1 - First/Last page
      if (gamepad.isPageDownPressed()) {
        _pdfController.goToPage(pageNumber: 1);
      } else if (gamepad.isPageUpPressed()) {
        if (_totalPages > 0) _pdfController.goToPage(pageNumber: _totalPages);
      }

      // L2/R2 - Zoom
      if (gamepad.isLeftTriggerPressed()) {
        _pdfController.zoomDown();
      } else if (gamepad.isRightTriggerPressed()) {
        _pdfController.zoomUp();
      }

      // X - Reset zoom (use help/search button mapping)
      if (gamepad.isSearchPressed()) {
        _pdfController.goToPage(pageNumber: _pdfController.pageNumber ?? 1);
      }
    });
  }

  void _updatePageInfo() {
    if (mounted) {
      final pageNum = _pdfController.pageNumber ?? 1;
      final pageCount = _pdfController.pageCount;
      if (pageNum != _currentPage || pageCount != _totalPages) {
        setState(() {
          _currentPage = pageNum;
          _totalPages = pageCount;
        });
      }
    }
  }

  @override
  void dispose() {
    _gamepadTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isPdf) {
      return Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.file(File(widget.path), key: ValueKey(widget.path)),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // PDF Viewer
        PdfViewer.file(
          widget.path,
          controller: _pdfController,
          params: const PdfViewerParams(backgroundColor: Colors.black),
        ),

        // PDF Specific Controls (Top)
        if (widget.controller.showControls)
          Positioned(
            top: 100, // Below the main top bar
            left: 0,
            right: 0,
            child: _buildPdfTopBar(),
          ),

        // Navigation Hints Overlay (Bottom)
        if (widget.controller.showControls)
          Positioned(
            bottom: 120, // Above the main bottom bar
            left: 0,
            right: 0,
            child: _buildPdfControlsBar(),
          ),
      ],
    );
  }

  Widget _buildPdfTopBar() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          boxShadow: [const BoxShadow(color: Colors.black45, blurRadius: 10)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.zoom_out, color: Colors.white, size: 22),
              onPressed: () => _pdfController.zoomDown(),
              tooltip: l10n.zoomOut,
            ),
            IconButton(
              icon: const Icon(Icons.zoom_in, color: Colors.white, size: 22),
              onPressed: () => _pdfController.zoomUp(),
              tooltip: l10n.zoomIn,
            ),
            const SizedBox(width: 8),
            Container(width: 1, height: 28, color: Colors.white30),
            const SizedBox(width: 12),
            Text(
              l10n.pageCounter(_currentPage.toString(), _totalPages.toString()),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            Container(width: 1, height: 28, color: Colors.white30),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.first_page, color: Colors.white, size: 22),
              onPressed: _currentPage > 1
                  ? () => _pdfController.goToPage(pageNumber: 1)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.last_page, color: Colors.white, size: 22),
              onPressed: _currentPage < _totalPages
                  ? () => _pdfController.goToPage(pageNumber: _totalPages)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfControlsBar() {
    final isGamepad = GamepadService.instance.isGamepadConnected;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildActionHint(isGamepad ? 'L2/R2' : '+/-', l10n.zoom),
            const SizedBox(width: 20),
            _buildActionHint(isGamepad ? 'L1/R1' : 'Home/End', l10n.firstLast),
            const SizedBox(width: 20),
            _buildActionHint(isGamepad ? 'D-Pad' : 'Arrows', l10n.scroll),
          ],
        ),
      ),
    );
  }

  Widget _buildActionHint(String key, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            key,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
