import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'keyboard_service.dart';

/// Configuration for screen-specific keyboard handling
class ScreenKeyboardConfig<T> {
  /// Get display name from item (for alphabetical/number jump)
  final String Function(T item) getDisplayName;

  /// Items to navigate through
  final List<T> Function() getItems;

  /// Current selected index
  final int Function() getCurrentIndex;

  /// Update selected index
  final void Function(int newIndex) setCurrentIndex;

  /// Number of columns (for grid mode), null for non-grid modes
  final int? Function()? getColumns;

  /// Scroll to index callback
  final void Function(int index, {int? columns, bool centerItem}) scrollToIndex;

  /// Handle item selection
  final void Function() onSelect;

  /// Handle back action
  final void Function() onBack;

  /// Refresh action (optional)
  final void Function()? onRefresh;

  /// Toggle view mode (optional)
  final void Function()? onToggleView;

  /// Show help dialog (optional)
  final void Function()? onShowHelp;

  /// Additional custom shortcuts (optional)
  /// Return true if handled
  final bool Function(LogicalKeyboardKey key)? onCustomShortcut;

  /// Schedule media load after navigation (optional)
  final void Function()? onScheduleMediaLoad;

  /// Whether to hide navigation hint after action (optional)
  final void Function()? onHideNavigationHint;

  const ScreenKeyboardConfig({
    required this.getDisplayName,
    required this.getItems,
    required this.getCurrentIndex,
    required this.setCurrentIndex,
    required this.scrollToIndex,
    required this.onSelect,
    required this.onBack,
    this.getColumns,
    this.onRefresh,
    this.onToggleView,
    this.onShowHelp,
    this.onCustomShortcut,
    this.onScheduleMediaLoad,
    this.onHideNavigationHint,
  });
}

/// View mode for keyboard navigation
enum ScreenViewMode { grid, list, carousel }

/// Reusable keyboard handler for screen navigation
///
/// Eliminates duplicated keyboard handling logic across PlatformsScreen and RomsScreen.
/// Provides consistent keyboard navigation patterns:
/// - Alphabetical jump (Shift + Letter)
/// - Number jump (Shift + 0-9)
/// - Directional navigation (arrows, Page Up/Down, Home/End)
/// - Common shortcuts (R=refresh, V=toggle view, ?=help)
/// - Selection (Enter/Space)
/// - Back (Escape)
///
/// Usage:
/// ```dart
/// final handler = ScreenKeyboardHandler(
///   keyboardService: KeyboardService.instance,
///   config: ScreenKeyboardConfig<Platform>(
///     getDisplayName: (p) => p.name,
///     getItems: () => _platforms,
///     getCurrentIndex: () => _selectedIndex,
///     setCurrentIndex: (i) => setState(() => _selectedIndex = i),
///     scrollToIndex: _scrollToIndex,
///     onSelect: _handleSelection,
///     onBack: _navigateBack,
///   ),
/// );
///
/// // In Focus widget:
/// onKeyEvent: (node, event) => handler.handleKeyEvent(event, ViewMode.grid),
/// ```
class ScreenKeyboardHandler<T> {
  final KeyboardService keyboardService;
  final ScreenKeyboardConfig<T> config;

  ScreenKeyboardHandler({required this.keyboardService, required this.config});

  /// Main keyboard event handler
  ///
  /// [event]: Keyboard event to handle
  /// [viewMode]: Current view mode (affects navigation behavior)
  ///
  /// Returns KeyEventResult indicating if event was handled
  KeyEventResult handleKeyEvent(KeyEvent event, ScreenViewMode viewMode) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    // 1. Handle help shortcut (Shift + ?)
    if (keyboardService.isHelpKey(event)) {
      config.onShowHelp?.call();
      return KeyEventResult.handled;
    }

    // 2. Handle alphabetical jump (Shift + Letter)
    if (keyboardService.isAlphabeticalJump(event)) {
      return _handleAlphabeticalJump(event, viewMode);
    }

    // 3. Handle number jump (Shift + 0-9)
    if (keyboardService.isNumberJump(event)) {
      return _handleNumberJump(event, viewMode);
    }

    // 4. Handle custom shortcuts first (before common ones)
    if (config.onCustomShortcut?.call(key) == true) {
      return KeyEventResult.handled;
    }

    // 5. Handle common shortcuts
    if (_handleCommonShortcuts(key)) {
      return KeyEventResult.handled;
    }

    // 6. Handle back action
    if (keyboardService.isBackKey(key)) {
      config.onBack();
      return KeyEventResult.handled;
    }

    // 7. Handle selection
    if (keyboardService.isSelectKey(key)) {
      config.onSelect();
      return KeyEventResult.handled;
    }

    // 8. Handle directional navigation (depends on view mode)
    return _handleDirectionalNavigation(key, viewMode);
  }

  /// Handle common shortcuts (R, V)
  bool _handleCommonShortcuts(LogicalKeyboardKey key) {
    // R = Refresh
    if (key == LogicalKeyboardKey.keyR && config.onRefresh != null) {
      config.onRefresh!();
      return true;
    }

    // V = Toggle view mode
    if (key == LogicalKeyboardKey.keyV && config.onToggleView != null) {
      config.onToggleView!();
      return true;
    }

    return false;
  }

  /// Handle alphabetical jump (Shift + Letter)
  KeyEventResult _handleAlphabeticalJump(
    KeyEvent event,
    ScreenViewMode viewMode,
  ) {
    final letter = keyboardService.getAlphabeticalJumpLetter(event);
    if (letter == null) return KeyEventResult.ignored;

    final items = config.getItems();
    final newIndex = keyboardService.findIndexByLetter(
      letter: letter,
      items: items,
      getDisplayName: config.getDisplayName,
    );

    if (newIndex == null) return KeyEventResult.ignored;

    config.setCurrentIndex(newIndex);
    config.onHideNavigationHint?.call();

    // Scroll to new position
    final columns = config.getColumns?.call();
    config.scrollToIndex(newIndex, columns: columns, centerItem: true);

    config.onScheduleMediaLoad?.call();

    return KeyEventResult.handled;
  }

  /// Handle number jump (Shift + 0-9)
  KeyEventResult _handleNumberJump(KeyEvent event, ScreenViewMode viewMode) {
    final digit = keyboardService.getNumberJumpDigit(event);
    if (digit == null) return KeyEventResult.ignored;

    final items = config.getItems();
    final newIndex = keyboardService.findIndexByNumber(
      digit: digit,
      items: items,
      getDisplayName: config.getDisplayName,
    );

    if (newIndex == null) return KeyEventResult.ignored;

    config.setCurrentIndex(newIndex);
    config.onHideNavigationHint?.call();

    // Scroll to new position
    final columns = config.getColumns?.call();
    config.scrollToIndex(newIndex, columns: columns, centerItem: true);

    config.onScheduleMediaLoad?.call();

    return KeyEventResult.handled;
  }

  /// Handle directional navigation based on view mode
  KeyEventResult _handleDirectionalNavigation(
    LogicalKeyboardKey key,
    ScreenViewMode viewMode,
  ) {
    switch (viewMode) {
      case ScreenViewMode.grid:
        return _handleGridNavigation(key);
      case ScreenViewMode.list:
        return _handleListNavigation(key);
      case ScreenViewMode.carousel:
        return _handleCarouselNavigation(key);
    }
  }

  /// Handle grid-specific navigation
  KeyEventResult _handleGridNavigation(LogicalKeyboardKey key) {
    final columns = config.getColumns?.call();
    if (columns == null) {
      debugPrint('Grid mode requires getColumns callback');
      return KeyEventResult.ignored;
    }

    final items = config.getItems();
    final currentIndex = config.getCurrentIndex();

    final newIndex = keyboardService.handleGridNavigation(
      key: key,
      currentIndex: currentIndex,
      itemCount: items.length,
      columns: columns,
    );

    if (newIndex != null) {
      config.setCurrentIndex(newIndex);
      config.scrollToIndex(newIndex, columns: columns, centerItem: false);
      config.onScheduleMediaLoad?.call();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  /// Handle list-specific navigation
  KeyEventResult _handleListNavigation(LogicalKeyboardKey key) {
    final items = config.getItems();
    final currentIndex = config.getCurrentIndex();

    final newIndex = keyboardService.handleListNavigation(
      key: key,
      currentIndex: currentIndex,
      itemCount: items.length,
    );

    if (newIndex != null) {
      config.setCurrentIndex(newIndex);
      config.scrollToIndex(newIndex, centerItem: false);
      config.onScheduleMediaLoad?.call();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  /// Handle carousel-specific navigation
  KeyEventResult _handleCarouselNavigation(LogicalKeyboardKey key) {
    final items = config.getItems();
    final currentIndex = config.getCurrentIndex();

    final newIndex = keyboardService.handleCarouselNavigation(
      key: key,
      currentIndex: currentIndex,
      itemCount: items.length,
    );

    if (newIndex != null) {
      config.setCurrentIndex(newIndex);
      config.onHideNavigationHint?.call();
      config.scrollToIndex(newIndex, centerItem: false);
      config.onScheduleMediaLoad?.call();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }
}
