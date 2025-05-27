import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/photo.dart';
import 'photo_item.dart';

class PhotoList extends ConsumerWidget {
  final List<Photo> photos;
  final ScrollController scrollController;

  const PhotoList({super.key, required this.photos, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      controller: scrollController,
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return PhotoItem(photo: photo);
      },
    );
  }
}
