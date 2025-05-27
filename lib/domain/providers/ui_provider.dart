import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod Notifier that manages UI state
class UINotifier extends Notifier<UIState> {
  @override
  UIState build() {
    return UIState(currentPage: 1, sortBy: 'id', filterAlbumId: null);
  }

  void setPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void setSort(String sortBy) {
    state = state.copyWith(sortBy: sortBy, currentPage: 1);
  }

  void setFilter(int? filterAlbumId) {
    state = state.copyWith(filterAlbumId: filterAlbumId, currentPage: 1);
  }
}

// Provider that exposes the UINotifier to the app
final uiProvider = NotifierProvider<UINotifier, UIState>(() {
  return UINotifier();
});

// Represents the current UI state (pagination, sorting, filtering)
class UIState {
  final int currentPage;
  final String sortBy;
  final int? filterAlbumId;

  UIState({required this.currentPage, required this.sortBy, this.filterAlbumId});

  UIState copyWith({int? currentPage, String? sortBy, int? filterAlbumId}) {
    return UIState(
      currentPage: currentPage ?? this.currentPage,
      sortBy: sortBy ?? this.sortBy,
      filterAlbumId: filterAlbumId ?? this.filterAlbumId,
    );
  }
}
