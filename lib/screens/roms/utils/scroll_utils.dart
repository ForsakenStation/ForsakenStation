import 'package:flutter/material.dart';

/// Scroll utility functions for ROM screen
class ScrollUtils {
  /// Scroll to index in list view
  /// Uses minimal scroll for sequential navigation, centered for alphabetical jumps
  static void scrollToIndexInList(
    ScrollController controller,
    int index, {
    bool centerItem = false,
  }) {
    if (!controller.hasClients) return;
    const listPaddingTop = 8.0;
    const itemHeight = 72.0;

    final itemOffset = listPaddingTop + (index * itemHeight);
    final viewportHeight = controller.position.viewportDimension;
    final currentScroll = controller.offset;
    final maxScroll = controller.position.maxScrollExtent;

    double targetScroll;

    if (centerItem) {
      // CENTER: For alphabetical jumps - center the item in viewport
      targetScroll = itemOffset - (viewportHeight / 2) + (itemHeight / 2);
    } else {
      // MINIMAL: For sequential navigation - only scroll if not visible
      final itemTop = itemOffset;
      final itemBottom = itemOffset + itemHeight;

      if (itemTop < currentScroll) {
        targetScroll = itemTop - 16;
      } else if (itemBottom > currentScroll + viewportHeight) {
        targetScroll = itemBottom - viewportHeight + 16;
      } else {
        return; // Already visible
      }
    }

    controller.jumpTo(targetScroll.clamp(0.0, maxScroll));
  }

  /// Scroll to index in grid view
  /// Uses minimal scroll for sequential navigation, centered for alphabetical jumps
  static void scrollToIndexInGrid(
    ScrollController controller,
    BuildContext context,
    int index,
    int columns, {
    bool centerItem = false,
  }) {
    if (!controller.hasClients) return;

    // Calculate item dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 16 * 2 - 16 * (columns - 1)) / columns;
    final itemHeight = itemWidth / 0.7; // Based on childAspectRatio

    // Calculate row
    final row = index ~/ columns;
    final rowOffset = row * (itemHeight + 16);

    // Get viewport height
    final viewportHeight = controller.position.viewportDimension;
    final currentScroll = controller.offset;
    final maxScroll = controller.position.maxScrollExtent;

    double targetScroll;

    if (centerItem) {
      // CENTER: For alphabetical jumps
      targetScroll = rowOffset - (viewportHeight / 2) + (itemHeight / 2);
    } else {
      // MINIMAL: For sequential navigation
      final itemTop = rowOffset;
      final itemBottom = rowOffset + itemHeight;

      if (itemTop < currentScroll) {
        targetScroll = itemTop - 16;
      } else if (itemBottom > currentScroll + viewportHeight) {
        targetScroll = itemBottom - viewportHeight + 16;
      } else {
        return; // Already visible
      }
    }

    // Always use jumpTo for instant response
    controller.jumpTo(targetScroll.clamp(0.0, maxScroll));
  }

  /// Scroll to index in carousel view
  /// Uses minimal scroll for sequential navigation, centered for alphabetical jumps
  static void scrollToCarouselIndex(
    ScrollController controller,
    int index, {
    bool centerItem = false,
  }) {
    if (!controller.hasClients) return;

    const cardWidth = 180.0 + 16.0; // Card width + padding
    final itemOffset = index * cardWidth;
    final viewportWidth = controller.position.viewportDimension;
    final currentScroll = controller.offset;
    final maxScroll = controller.position.maxScrollExtent;

    double targetScroll;

    if (centerItem) {
      // CENTER: For alphabetical jumps
      targetScroll = itemOffset - (viewportWidth / 2) + (cardWidth / 2);
    } else {
      // MINIMAL: For sequential navigation
      final itemLeft = itemOffset;
      final itemRight = itemOffset + cardWidth;

      if (itemLeft < currentScroll) {
        targetScroll = itemLeft;
      } else if (itemRight > currentScroll + viewportWidth) {
        targetScroll = itemRight - viewportWidth;
      } else {
        return; // Already visible
      }
    }

    // Always use jumpTo for instant response
    controller.jumpTo(targetScroll.clamp(0.0, maxScroll));
  }

  /// Calculate cross-axis count for grid view based on screen width
  static int calculateCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 6;
    if (width > 900) return 5;
    if (width > 600) return 4;
    if (width > 400) return 3;
    return 2;
  }
}
