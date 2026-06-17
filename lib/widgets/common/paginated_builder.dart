import 'package:flutter/material.dart';
import 'pagination_controls.dart';

/// A wrapper widget that adds pagination to any sliver-based list
/// 
/// This widget wraps a ListView.builder or GridView.builder and adds
/// pagination controls at the bottom. It's useful for large datasets where
/// you want to load items in pages rather than all at once.
class PaginatedBuilder extends StatefulWidget {
  /// Builder function for list items
  final Widget Function(BuildContext context, int index) itemBuilder;
  
  /// Total number of items
  final int itemCount;
  
  /// Number of items per page
  final int itemsPerPage;
  
  /// Whether to show pagination controls
  final bool showControls;
  
  /// Scroll controller for the list
  final ScrollController? scrollController;
  
  /// Padding for the list
  final EdgeInsetsGeometry? padding;
  
  /// Physics for the list
  final ScrollPhysics? physics;
  
  /// Whether the list is a grid
  final bool isGrid;
  
  /// Grid delegate for grid views
  final SliverGridDelegate? gridDelegate;
  
  /// Called when page changes
  final void Function(int newPage)? onPageChanged;
  
  /// Custom pagination controls builder
  final Widget Function(BuildContext context, int currentPage, int totalPages, 
      bool hasPrevious, bool hasNext, void Function() goToPrevious, 
      void Function() goToNext)? customControlsBuilder;
  
  /// Background color for pagination controls
  final Color controlsBackgroundColor;
  
  /// Whether to scroll to top when page changes
  final bool scrollToTopOnPageChange;

  const PaginatedBuilder({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.itemsPerPage = 50,
    this.showControls = true,
    this.scrollController,
    this.padding,
    this.physics,
    this.isGrid = false,
    this.gridDelegate,
    this.onPageChanged,
    this.customControlsBuilder,
    this.controlsBackgroundColor = const Color(0xCC000000),
    this.scrollToTopOnPageChange = true,
  });

  @override
  State<PaginatedBuilder> createState() => _PaginatedBuilderState();
}

class _PaginatedBuilderState extends State<PaginatedBuilder> {
  int _currentPage = 0;
  final ScrollController _internalController = ScrollController();

  @override
  void initState() {
    super.initState();
    _internalController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _internalController.removeListener(_onScroll);
    _internalController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Could implement auto-pagination on scroll here if needed
  }

  int get totalPages => ((widget.itemCount + widget.itemsPerPage - 1) / widget.itemsPerPage).ceil();
  
  bool get hasPreviousPage => _currentPage > 0;
  bool get hasNextPage => _currentPage < totalPages - 1;
  
  int get firstItemIndex => _currentPage * widget.itemsPerPage;
  int get lastItemIndex => (firstItemIndex + widget.itemsPerPage - 1).clamp(0, widget.itemCount - 1);
  
  int get currentPageItemCount => 
      widget.itemCount - firstItemIndex > widget.itemsPerPage
      ? widget.itemsPerPage
      : widget.itemCount - firstItemIndex;

  void _goToPreviousPage() {
    if (hasPreviousPage) {
      setState(() {
        _currentPage--;
      });
      widget.onPageChanged?.call(_currentPage);
      if (widget.scrollToTopOnPageChange) {
        _scrollToTop();
      }
    }
  }

  void _goToNextPage() {
    if (hasNextPage) {
      setState(() {
        _currentPage++;
      });
      widget.onPageChanged?.call(_currentPage);
      if (widget.scrollToTopOnPageChange) {
        _scrollToTop();
      }
    }
  }

  void _scrollToTop() {
    final controller = widget.scrollController ?? _internalController;
    if (controller.hasClients) {
      controller.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // If there are no items or pagination is not needed, just show the list
    if (widget.itemCount == 0 || totalPages <= 1) {
      return _buildList(0, widget.itemCount);
    }

    return Column(
      children: [
        Expanded(child: _buildList(firstItemIndex, currentPageItemCount)),
        if (widget.showControls) 
          _buildPaginationControls(context),
      ],
    );
  }

  Widget _buildList(int startIndex, int count) {
    final controller = widget.scrollController ?? _internalController;
    
    if (widget.isGrid && widget.gridDelegate != null) {
      return GridView.builder(
        controller: controller,
        padding: widget.padding,
        physics: widget.physics,
        gridDelegate: widget.gridDelegate!,
        itemCount: count,
        itemBuilder: (context, localIndex) {
          final globalIndex = startIndex + localIndex;
          return widget.itemBuilder(context, globalIndex);
        },
      );
    } else {
      return ListView.builder(
        controller: controller,
        padding: widget.padding,
        physics: widget.physics,
        itemCount: count,
        itemBuilder: (context, localIndex) {
          final globalIndex = startIndex + localIndex;
          return widget.itemBuilder(context, globalIndex);
        },
      );
    }
  }

  Widget _buildPaginationControls(BuildContext context) {
    if (widget.customControlsBuilder != null) {
      return widget.customControlsBuilder!(
        context,
        _currentPage,
        totalPages,
        hasPreviousPage,
        hasNextPage,
        _goToPreviousPage,
        _goToNextPage,
      );
    }
    
    return SimplePaginationControls(
      currentPage: _currentPage,
      totalPages: totalPages,
      hasPreviousPage: hasPreviousPage,
      hasNextPage: hasNextPage,
      onPreviousPage: _goToPreviousPage,
      onNextPage: _goToNextPage,
    );
  }
}

/// A pagination-aware list view that can be used as a drop-in replacement
/// for ListView.builder with pagination support
class PaginatedListView<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final int itemsPerPage;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool showControls;
  final Color controlsBackgroundColor;
  final bool scrollToTopOnPageChange;

  const PaginatedListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.itemsPerPage = 50,
    this.scrollController,
    this.padding,
    this.physics,
    this.showControls = true,
    this.controlsBackgroundColor = const Color(0xCC000000),
    this.scrollToTopOnPageChange = true,
  });

  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  int _currentPage = 0;

  int get totalPages => ((widget.items.length + widget.itemsPerPage - 1) / widget.itemsPerPage).ceil();
  
  bool get hasPreviousPage => _currentPage > 0;
  bool get hasNextPage => _currentPage < totalPages - 1;
  
  int get firstItemIndex => _currentPage * widget.itemsPerPage;
  int get currentPageItemCount => 
      widget.items.length - firstItemIndex > widget.itemsPerPage
      ? widget.itemsPerPage
      : widget.items.length - firstItemIndex;

  void _goToPreviousPage() {
    if (hasPreviousPage) {
      setState(() {
        _currentPage--;
      });
      _scrollToTop();
    }
  }

  void _goToNextPage() {
    if (hasNextPage) {
      setState(() {
        _currentPage++;
      });
      _scrollToTop();
    }
  }

  void _scrollToTop() {
    if (widget.scrollController?.hasClients ?? false) {
      widget.scrollController!.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty || totalPages <= 1) {
      return ListView.builder(
        controller: widget.scrollController,
        padding: widget.padding,
        physics: widget.physics,
        itemCount: widget.items.length,
        itemBuilder: (context, index) => widget.itemBuilder(context, widget.items[index], index),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: widget.scrollController,
            padding: widget.padding,
            physics: widget.physics,
            itemCount: currentPageItemCount,
            itemBuilder: (context, localIndex) {
              final globalIndex = firstItemIndex + localIndex;
              return widget.itemBuilder(context, widget.items[globalIndex], globalIndex);
            },
          ),
        ),
        if (widget.showControls)
          SimplePaginationControls(
            currentPage: _currentPage,
            totalPages: totalPages,
            hasPreviousPage: hasPreviousPage,
            hasNextPage: hasNextPage,
            onPreviousPage: _goToPreviousPage,
            onNextPage: _goToNextPage,
          ),
      ],
    );
  }
}

/// A pagination-aware grid view that can be used as a drop-in replacement
/// for GridView.builder with pagination support
class PaginatedGridView<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final int itemsPerPage;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final SliverGridDelegate gridDelegate;
  final bool showControls;
  final Color controlsBackgroundColor;
  final bool scrollToTopOnPageChange;

  const PaginatedGridView({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.gridDelegate,
    this.itemsPerPage = 60,
    this.scrollController,
    this.padding,
    this.physics,
    this.showControls = true,
    this.controlsBackgroundColor = const Color(0xCC000000),
    this.scrollToTopOnPageChange = true,
  });

  @override
  State<PaginatedGridView<T>> createState() => _PaginatedGridViewState<T>();
}

class _PaginatedGridViewState<T> extends State<PaginatedGridView<T>> {
  int _currentPage = 0;

  int get totalPages => ((widget.items.length + widget.itemsPerPage - 1) / widget.itemsPerPage).ceil();
  
  bool get hasPreviousPage => _currentPage > 0;
  bool get hasNextPage => _currentPage < totalPages - 1;
  
  int get firstItemIndex => _currentPage * widget.itemsPerPage;
  int get currentPageItemCount => 
      widget.items.length - firstItemIndex > widget.itemsPerPage
      ? widget.itemsPerPage
      : widget.items.length - firstItemIndex;

  void _goToPreviousPage() {
    if (hasPreviousPage) {
      setState(() {
        _currentPage--;
      });
      _scrollToTop();
    }
  }

  void _goToNextPage() {
    if (hasNextPage) {
      setState(() {
        _currentPage++;
      });
      _scrollToTop();
    }
  }

  void _scrollToTop() {
    if (widget.scrollController?.hasClients ?? false) {
      widget.scrollController!.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty || totalPages <= 1) {
      return GridView.builder(
        controller: widget.scrollController,
        padding: widget.padding,
        physics: widget.physics,
        gridDelegate: widget.gridDelegate,
        itemCount: widget.items.length,
        itemBuilder: (context, index) => widget.itemBuilder(context, widget.items[index], index),
      );
    }

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            controller: widget.scrollController,
            padding: widget.padding,
            physics: widget.physics,
            gridDelegate: widget.gridDelegate,
            itemCount: currentPageItemCount,
            itemBuilder: (context, localIndex) {
              final globalIndex = firstItemIndex + localIndex;
              return widget.itemBuilder(context, widget.items[globalIndex], globalIndex);
            },
          ),
        ),
        if (widget.showControls)
          SimplePaginationControls(
            currentPage: _currentPage,
            totalPages: totalPages,
            hasPreviousPage: hasPreviousPage,
            hasNextPage: hasNextPage,
            onPreviousPage: _goToPreviousPage,
            onNextPage: _goToNextPage,
          ),
      ],
    );
  }
}
