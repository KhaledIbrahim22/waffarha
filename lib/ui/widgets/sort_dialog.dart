import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/providers/ui_provider.dart';

class SortDialog extends ConsumerWidget {
  const SortDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSort = ref.watch(uiProvider.select((state) => state.sortBy));

    return AlertDialog(
      title: const Text('Sort By'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<String>(
            title: const Text('Album ID'),
            value: 'albumId',
            groupValue: currentSort,
            onChanged: (value) {
              ref.read(uiProvider.notifier).setSort(value!);
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: const Text('Title'),
            value: 'title',
            groupValue: currentSort,
            onChanged: (value) {
              ref.read(uiProvider.notifier).setSort(value!);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
