import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forsaken/models/rom_item.dart';
import 'package:forsaken/services/keyboard_service.dart';
import 'package:forsaken/screens/roms/utils/scroll_utils.dart';

/// Keyboard event handlers for ROM screen
class KeyboardHandlers {
  final KeyboardService _keyboardService = KeyboardService.instance;

  /// Handle alphabetical jump based on current view mode
  KeyEventResult handleAlphabeticalJump({
    required KeyEvent event,
    required List<RomItem> filteredItems,
    required int selectedIndex,
    required ViewMode viewMode,
    required BuildContext context,
    required ScrollController listController,
    required ScrollController gridController,
    required ScrollController carouselController,
    required Function(int newIndex) onIndexChanged,
    required Function() onScheduleMediaLoad,
    required Function() onHideNavigationHint,
  }) {
    final letter = _keyboardService.getAlphabeticalJumpLetter(event);
    if (letter == null) return KeyEventResult.ignored;

    final newIndex = _keyboardService.findIndexByLetter(
      letter: letter,
      items: filteredItems,
      getDisplayName: (item) => item.displayName,
    );

    if (newIndex == null) return KeyEventResult.ignored;

    onIndexChanged(newIndex);
    onHideNavigationHint();

    if (viewMode == ViewMode.grid) {
      final columns = ScrollUtils.calculateCrossAxisCount(context);
      ScrollUtils.scrollToIndexInGrid(
        gridController,
        context,
        newIndex,
        columns,
        centerItem: true,
      );
    } else if (viewMode == ViewMode.list) {
      ScrollUtils.scrollToIndexInList(
        listController,
        newIndex,
        centerItem: true,
      );
    } else {
      ScrollUtils.scrollToCarouselIndex(
        carouselController,
        newIndex,
        centerItem: true,
      );
    }

    onScheduleMediaLoad();

    return KeyEventResult.handled;
  }

  /// Handle grid-specific navigation
  KeyEventResult handleGridNavigation({
    required LogicalKeyboardKey key,
    required int selectedIndex,
    required int itemCount,
    required BuildContext context,
    required ScrollController controller,
    required Function(int newIndex) onIndexChanged,
    required Function() onScheduleMediaLoad,
  }) {
    final columns = ScrollUtils.calculateCrossAxisCount(context);
    final newIndex = _keyboardService.handleGridNavigation(
      key: key,
      currentIndex: selectedIndex,
      itemCount: itemCount,
      columns: columns,
    );

    if (newIndex != null) {
      onIndexChanged(newIndex);
      ScrollUtils.scrollToIndexInGrid(controller, context, newIndex, columns);
      onScheduleMediaLoad();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  /// Handle list-specific navigation
  KeyEventResult handleListNavigation({
    required LogicalKeyboardKey key,
    required int selectedIndex,
    required int itemCount,
    required bool isAtRoot,
    required ScrollController controller,
    required Function(int newIndex) onIndexChanged,
    required Function() onScheduleMediaLoad,
    required Function()? onPreviousPlatform,
    required Function()? onNextPlatform,
  }) {
    // Check for lateral platform navigation first (only at root)
    if (isAtRoot && onPreviousPlatform != null && onNextPlatform != null) {
      if (key == LogicalKeyboardKey.arrowLeft ||
          key == LogicalKeyboardKey.keyQ) {
        onPreviousPlatform();
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.arrowRight ||
          key == LogicalKeyboardKey.keyE) {
        onNextPlatform();
        return KeyEventResult.handled;
      }
    }

    final newIndex = _keyboardService.handleListNavigation(
      key: key,
      currentIndex: selectedIndex,
      itemCount: itemCount,
    );

    if (newIndex != null) {
      onIndexChanged(newIndex);
      ScrollUtils.scrollToIndexInList(controller, newIndex);
      onScheduleMediaLoad();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  /// Handle carousel-specific navigation
  KeyEventResult handleCarouselNavigation({
    required LogicalKeyboardKey key,
    required int selectedIndex,
    required int itemCount,
    required bool showNavigationHint,
    required ScrollController controller,
    required Function(int newIndex) onIndexChanged,
    required Function() onScheduleMediaLoad,
    required Function() onHideNavigationHint,
  }) {
    final newIndex = _keyboardService.handleCarouselNavigation(
      key: key,
      currentIndex: selectedIndex,
      itemCount: itemCount,
      loop: true,
    );

    if (newIndex != null) {
      if (showNavigationHint) {
        onHideNavigationHint();
      }
      onIndexChanged(newIndex);
      ScrollUtils.scrollToCarouselIndex(controller, selectedIndex);
      onScheduleMediaLoad();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  /// Handle directional navigation based on current view mode
  KeyEventResult handleDirectionalNavigation({
    required LogicalKeyboardKey key,
    required ViewMode viewMode,
    required int selectedIndex,
    required int itemCount,
    required bool isAtRoot,
    required bool showNavigationHint,
    required BuildContext context,
    required ScrollController listController,
    required ScrollController gridController,
    required ScrollController carouselController,
    required Function(int newIndex) onIndexChanged,
    required Function() onScheduleMediaLoad,
    required Function() onHideNavigationHint,
    required Function()? onPreviousPlatform,
    required Function()? onNextPlatform,
  }) {
    if (viewMode == ViewMode.grid) {
      return handleGridNavigation(
        key: key,
        selectedIndex: selectedIndex,
        itemCount: itemCount,
        context: context,
        controller: gridController,
        onIndexChanged: onIndexChanged,
        onScheduleMediaLoad: onScheduleMediaLoad,
      );
    } else if (viewMode == ViewMode.list) {
      return handleListNavigation(
        key: key,
        selectedIndex: selectedIndex,
        itemCount: itemCount,
        isAtRoot: isAtRoot,
        controller: listController,
        onIndexChanged: onIndexChanged,
        onScheduleMediaLoad: onScheduleMediaLoad,
        onPreviousPlatform: onPreviousPlatform,
        onNextPlatform: onNextPlatform,
      );
    } else {
      return handleCarouselNavigation(
        key: key,
        selectedIndex: selectedIndex,
        itemCount: itemCount,
        showNavigationHint: showNavigationHint,
        controller: carouselController,
        onIndexChanged: onIndexChanged,
        onScheduleMediaLoad: onScheduleMediaLoad,
        onHideNavigationHint: onHideNavigationHint,
      );
    }
  }
}

/// View mode enum for ROM screen
enum ViewMode { list, grid, carousel }
