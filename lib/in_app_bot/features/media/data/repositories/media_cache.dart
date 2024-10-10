import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A cache for media data, implemented as a Riverpod StateNotifier.
class MediaCache extends StateNotifier<Map<String, Map<String, String?>>> {
  MediaCache() : super({});

  /// Fetches and caches media data for a given marker ID.
  ///
  /// Returns the cached data if it exists, otherwise fetches from Firestore.
  Future<Map<String, String?>> cacheMedia(String markerId) async {
    if (state.containsKey(markerId)) {
      log('Cache hit for marker: $markerId');
      return state[markerId]!;
    }

    try {
      final data = await _fetchMediaData(markerId);
      state = {...state, markerId: data};
      log('Cached media for marker: $markerId');
      return data;
    } catch (e) {
      log('Error caching media for marker $markerId: $e');
      rethrow;
    }
  }

  /// Retrieves cached media data for a given marker ID.
  Map<String, String?>? getMedia(String markerId) => state[markerId];

  /// Fetches media data from Firestore for a given marker ID.
  Future<Map<String, String?>> _fetchMediaData(String markerId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('chatbots')
        .doc('f_media')
        .collection('media')
        .where('image_code', isEqualTo: markerId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var data = querySnapshot.docs[0].data();
      return {'url': data['url'] as String?, 'type': data['type'] as String?};
    } else {
      throw Exception('No data found for marker: $markerId');
    }
  }
}
