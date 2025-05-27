import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/providers/ui_provider.dart';

class FilterDialog extends ConsumerStatefulWidget {
  const FilterDialog({super.key});

  @override
  ConsumerState<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends ConsumerState<FilterDialog> {
  final _controller = TextEditingController();
  int? _filterValue;

  @override
  void initState() {
    super.initState();
    _filterValue = ref.read(uiProvider).filterAlbumId;
    _controller.text = _filterValue?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter by Album ID'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Album ID',
          hintText: 'Enter album ID to filter',
        ),
        onChanged: (value) {
          _filterValue = int.tryParse(value);
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(uiProvider.notifier).setFilter(null);
            Navigator.pop(context);
          },
          child: const Text('Clear'),
        ),
        TextButton(
          onPressed: () {
            ref.read(uiProvider.notifier).setFilter(_filterValue);
            Navigator.pop(context);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
