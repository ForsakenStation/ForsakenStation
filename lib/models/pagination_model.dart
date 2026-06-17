/// Model for pagination state and configuration
/// 
/// This model helps manage pagination for large lists of items,
/// particularly useful for ROMs and platforms screens.
class PaginationModel<T> {
  /// All items (the complete dataset)
  final List<T> allItems;
  
  /// Items currently displayed (current page)
  List<T> get currentPageItems {
    final start = currentPage * pageSize;
    final end = start + pageSize;
    return allItems.sublist(
      start,
      end > allItems.length ? allItems.length : end,
    );
  }
  
  /// Current page index (0-based)
  int currentPage;
  
  /// Number of items per page
  final int pageSize;
  
  /// Total number of pages
  int get totalPages => ((allItems.length + pageSize - 1) / pageSize).ceil();
  
  /// Whether there is a previous page
  bool get hasPreviousPage => currentPage > 0;
  
  /// Whether there is a next page
  bool get hasNextPage => currentPage < totalPages - 1;
  
  /// Index of the first item in current page
  int get firstItemIndex => currentPage * pageSize;
  
  /// Index of the last item in current page
  int get lastItemIndex => (firstItemIndex + pageSize - 1).clamp(0, allItems.length - 1);
  
  /// Total number of items
  int get totalItems => allItems.length;
  
  /// Whether pagination is needed (more than one page)
  bool get needsPagination => totalPages > 1;
  
  /// Create a new pagination model
  PaginationModel({
    required List<T> items,
    this.currentPage = 0,
    int? pageSize,
  }) : allItems = items,
       pageSize = pageSize ?? _defaultPageSize;
  
  /// Default page size for ROMs
  static const int _defaultPageSize = 50;
  
  /// Go to next page
  void nextPage() {
    if (hasNextPage) {
      currentPage++;
    }
  }
  
  /// Go to previous page
  void previousPage() {
    if (hasPreviousPage) {
      currentPage--;
    }
  }
  
  /// Go to specific page
  void goToPage(int page) {
    if (page >= 0 && page < totalPages) {
      currentPage = page;
    }
  }
  
  /// Go to first page
  void goToFirstPage() {
    currentPage = 0;
  }
  
  /// Go to last page
  void goToLastPage() {
    currentPage = totalPages - 1;
  }
  
  /// Reset to first page
  void reset() {
    currentPage = 0;
  }
  
  /// Create a copy with new items
  PaginationModel<T> copyWithNewItems(List<T> newItems) {
    return PaginationModel<T>(
      items: newItems,
      currentPage: 0, // Reset to first page when items change
      pageSize: pageSize,
    );
  }
  
  /// Get item at global index
  T? getItemAtGlobalIndex(int globalIndex) {
    if (globalIndex >= 0 && globalIndex < allItems.length) {
      return allItems[globalIndex];
    }
    return null;
  }
  
  /// Convert local page index to global index
  int toGlobalIndex(int localIndex) {
    return firstItemIndex + localIndex;
  }
  
  /// Convert global index to local page index
  int? toLocalIndex(int globalIndex) {
    if (globalIndex >= firstItemIndex && globalIndex <= lastItemIndex) {
      return globalIndex - firstItemIndex;
    }
    return null;
  }
  
  @override
  String toString() {
    return 'PaginationModel(currentPage: $currentPage, totalPages: $totalPages, '
           'pageSize: $pageSize, totalItems: $totalItems)';
  }
}

/// Predefined page sizes for different contexts
class PaginationConfig {
  /// Page size for grid views (more items visible at once)
  static const int gridPageSize = 60;
  
  /// Page size for list views
  static const int listPageSize = 50;
  
  /// Page size for carousel views (less items, more detail)
  static const int carouselPageSize = 30;
  
  /// Page size for platform selection (fewer platforms)
  static const int platformsPageSize = 24;
}
