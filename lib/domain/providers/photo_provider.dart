import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/photo.dart';
import '../../utils/services/json_parser.dart';

// Riverpod Notifier that manages photo data state
class PhotoNotifier extends AsyncNotifier<List<Photo>> {
  @override
  FutureOr<List<Photo>> build() async {
    final jsonString = await loadJsonFromAssets();
    return await parsePhotosInBackground(jsonString);
  }
}

// Provider that exposes the PhotoNotifier to the app
final photoProvider = AsyncNotifierProvider<PhotoNotifier, List<Photo>>(() {
  return PhotoNotifier();
});
