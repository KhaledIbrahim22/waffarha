import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/photo.dart';
import '../../domain/providers/photo_provider.dart';
import '../../domain/providers/ui_provider.dart';
import '../widgets/filter_dialog.dart';
import '../widgets/photo_list.dart';
import '../widgets/sort_dialog.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ScrollController();
    final uiState = ref.watch(uiProvider); // Watch UI state
    // Watch photo data (automatically handles loading/error states)
    final asyncPhotos = ref.watch(photoProvider);

    // Applies current filters and sorting to the photo list
    List<Photo> applyFiltersAndSorting(List<Photo> allPhotos) {
      List<Photo> filteredPhotos = allPhotos;

      // Apply filter if set
      if (uiState.filterAlbumId != null) {
        filteredPhotos = filteredPhotos
            .where((photo) => photo.albumId == uiState.filterAlbumId)
            .toList();
      }

      // Apply sorting
      filteredPhotos.sort((a, b) {
        if (uiState.sortBy == 'albumId') {
          return a.albumId.compareTo(b.albumId);
        } else if (uiState.sortBy == 'title') {
          return a.title.compareTo(b.title);
        }
        return a.id.compareTo(b.id);
      });

      return filteredPhotos;
    }

    // Gets the current page of photos from the filtered list
    List<Photo> getPaginatedPhotos(List<Photo> filteredPhotos) {
      const itemsPerPage = 10;
      final startIndex = (uiState.currentPage - 1) * itemsPerPage;
      if (startIndex >= filteredPhotos.length) {
        return [];
      }
      final endIndex = startIndex + itemsPerPage;
      return filteredPhotos.sublist(
        startIndex,
        endIndex > filteredPhotos.length ? filteredPhotos.length : endIndex,
      );
    }

    void showSortDialog() {
      showDialog(context: context, builder: (context) => const SortDialog());
    }

    void showFilterDialog() {
      showDialog(context: context, builder: (context) => const FilterDialog());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        actions: [
          IconButton(icon: const Icon(Icons.sort), onPressed: showSortDialog, tooltip: 'Sort'),
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: showFilterDialog,
            tooltip: 'Filter',
          ),
        ],
      ),
      body: asyncPhotos.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (allPhotos) {
          final filteredPhotos = applyFiltersAndSorting(allPhotos);
          final paginatedPhotos = getPaginatedPhotos(filteredPhotos);
          const itemsPerPage = 10;
          final totalPages = (filteredPhotos.length / itemsPerPage).ceil();
          return Column(
            children: [
              Expanded(
                child: PhotoList(photos: paginatedPhotos, scrollController: scrollController),
              ),
              if (totalPages > 1)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: uiState.currentPage > 1
                            ? () {
                                ref.read(uiProvider.notifier).setPage(uiState.currentPage - 1);
                                scrollController.animateTo(
                                  0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              }
                            : null,
                      ),
                      Text('Page ${uiState.currentPage} of $totalPages'),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: uiState.currentPage < totalPages
                            ? () {
                                ref.read(uiProvider.notifier).setPage(uiState.currentPage + 1);
                                scrollController.animateTo(
                                  0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
