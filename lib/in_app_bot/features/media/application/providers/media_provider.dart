import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/media/data/repositories/media_cache.dart';

/// A provider for the [MediaCache] state notifier.
///
/// This provider allows access to the [MediaCache] throughout the app
/// using Riverpod's dependency injection system.
final mediaCacheProvider =
    StateNotifierProvider<MediaCache, Map<String, Map<String, String?>>>((ref) {
  return MediaCache();
});
