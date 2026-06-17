import 'package:flutter/material.dart';

/// Widget for displaying pagination controls
/// 
/// This widget shows navigation buttons and page information for paginated lists.
class PaginationControls extends StatelessWidget {
  /// Current page index (0-based)
  final int currentPage;
  
  /// Total number of pages
  final int totalPages;
  
  /// Whether there is a previous page
  final bool hasPreviousPage;
  
  /// Whether there is a next page
  final bool hasNextPage;
  
  /// Called when previous page button is pressed
  final VoidCallback? onPreviousPage;
  
  /// Called when next page button is pressed
  final VoidCallback? onNextPage;
  
  /// Called when first page button is pressed
  final VoidCallback? onFirstPage;
  
  /// Called when last page button is pressed
  final VoidCallback? onLastPage;
  
  /// Whether to show page numbers
  final bool showPageNumbers;
  
  /// Page number selection callback (page index)
  final void Function(int)? onPageSelected;
  
  /// Text style for page info
  final TextStyle? textStyle;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Padding
  final EdgeInsetsGeometry? padding;
  
  /// Icon size
  final double iconSize;
  
  /// Button style
  final ButtonStyle? buttonStyle;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
    this.onPreviousPage,
    this.onNextPage,
    this.onFirstPage,
    this.onLastPage,
    this.showPageNumbers = true,
    this.onPageSelected,
    this.textStyle,
    this.backgroundColor,
    this.padding,
    this.iconSize = 20.0,
    this.buttonStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // If there's only one page, no need to show controls
    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }

    return Container(
      color: backgroundColor ?? theme.cardTheme.color?.withValues(alpha: 0.9) ?? Colors.black.withValues(alpha: 0.8),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // First page button
          _buildIconButton(
            context: context,
            icon: Icons.first_page,
            tooltip: 'First page',
            onPressed: hasPreviousPage ? onFirstPage : null,
            iconSize: iconSize,
            buttonStyle: buttonStyle,
          ),
          
          // Previous page button
          _buildIconButton(
            context: context,
            icon: Icons.chevron_left,
            tooltip: 'Previous page',
            onPressed: hasPreviousPage ? onPreviousPage : null,
            iconSize: iconSize,
            buttonStyle: buttonStyle,
          ),
          
          // Page info
          if (showPageNumbers) 
            _buildPageInfo(context),
          
          // Next page button
          _buildIconButton(
            context: context,
            icon: Icons.chevron_right,
            tooltip: 'Next page',
            onPressed: hasNextPage ? onNextPage : null,
            iconSize: iconSize,
            buttonStyle: buttonStyle,
          ),
          
          // Last page button
          _buildIconButton(
            context: context,
            icon: Icons.last_page,
            tooltip: 'Last page',
            onPressed: hasNextPage ? onLastPage : null,
            iconSize: iconSize,
            buttonStyle: buttonStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
    required double iconSize,
    required ButtonStyle? buttonStyle,
  }) {
    return IconButton(
      icon: Icon(icon, size: iconSize),
      tooltip: tooltip,
      onPressed: onPressed,
      style: buttonStyle ?? IconButton.styleFrom(
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.grey[500],
      ),
    );
  }

  Widget _buildPageInfo(BuildContext context) {
    final pageText = 'Page ${currentPage + 1} of $totalPages';
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        pageText,
        style: textStyle ?? const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}

/// Simplified pagination controls for bottom bar integration
class SimplePaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final bool hasPreviousPage;
  final bool hasNextPage;
  
  const SimplePaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.onPreviousPage,
    this.onNextPage,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, size: 20),
          tooltip: 'Previous Page',
          onPressed: hasPreviousPage ? onPreviousPage : null,
          style: IconButton.styleFrom(
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.grey[500],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '${currentPage + 1}/$totalPages',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, size: 20),
          tooltip: 'Next Page',
          onPressed: hasNextPage ? onNextPage : null,
          style: IconButton.styleFrom(
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.grey[500],
          ),
        ),
      ],
    );
  }
}

/// Page number buttons for direct navigation
class PageNumberButtons extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final void Function(int) onPageSelected;
  final int maxVisiblePages;
  
  const PageNumberButtons({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
    this.maxVisiblePages = 5,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }
    
    // Calculate range of pages to show
    final List<int> pages = _calculatePageRange();
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: pages.map((page) {
        final isCurrent = page == currentPage;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: _buildPageButton(context, page, isCurrent),
        );
      }).toList(),
    );
  }
  
  List<int> _calculatePageRange() {
    final half = (maxVisiblePages / 2).floor();
    int start = (currentPage - half).clamp(0, totalPages - maxVisiblePages);
    int end = (start + maxVisiblePages).clamp(maxVisiblePages, totalPages);
    
    if (end - start < maxVisiblePages) {
      start = (end - maxVisiblePages).clamp(0, totalPages - maxVisiblePages);
    }
    
    return List<int>.generate(end - start, (index) => start + index);
  }
  
  Widget _buildPageButton(BuildContext context, int page, bool isCurrent) {
    return TextButton(
      onPressed: isCurrent ? null : () => onPageSelected(page),
      style: TextButton.styleFrom(
        backgroundColor: isCurrent 
            ? Colors.white.withValues(alpha: 0.2) 
            : Colors.transparent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        '${page + 1}',
        style: TextStyle(
          fontSize: 14,
          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
