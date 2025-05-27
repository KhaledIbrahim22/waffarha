import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/photo.dart';

class PhotoItem extends StatelessWidget {
  final Photo photo;

  const PhotoItem({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Flexible(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                clipBehavior: Clip.hardEdge,
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: photo.thumbnailUrl,
                    placeholder: (_, _) => const CircularProgressIndicator(),
                    errorWidget: (_, _, _) => const Icon(Icons.image_rounded),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    photo.title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Album ID: ${photo.albumId}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
