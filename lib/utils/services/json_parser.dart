import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/services.dart' show rootBundle;

import '../../data/models/photo.dart';

// Loads JSON data from the app's assets
Future<String> loadJsonFromAssets() async {
  return await rootBundle.loadString('assets/photos.json');
}

// Parses JSON data in a background isolate to avoid avoid blocking the UI thread.
Future<List<Photo>> parsePhotosInBackground(String jsonString) async {
  final p = ReceivePort();
  await Isolate.spawn(_parsePhotos, [p.sendPort, jsonString]);
  return await p.first as List<Photo>;
}

// The function that runs in the background isolate to parse JSON
void _parsePhotos(List<dynamic> args) {
  final SendPort sendPort = args[0];
  final String jsonString = args[1];

  try {
    final List<dynamic> jsonList = json.decode(jsonString);
    final photos = jsonList.map((json) => Photo.fromJson(json)).toList();
    Isolate.exit(sendPort, photos);
  } catch (e) {
    Isolate.exit(sendPort, []);
  }
}
