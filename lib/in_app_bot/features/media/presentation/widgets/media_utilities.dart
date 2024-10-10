import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/media/application/providers/media_provider.dart';
import 'package:in_app_bot/in_app_bot/features/media/presentation/widgets/video_media.dart';

/// Creates a media widget based on the type of media.
Widget _mediaWidgetFromType(Map<String, String?> mediaItem) {
  final url = mediaItem['url'];
  final type = mediaItem['type'];

  if (url == null || type == null) {
    return const Text("Invalid media data");
  }

  switch (type) {
    case 'image':
      return _imageWidget(url);
    case 'video':
      return VideoWidget(url: url);
    default:
      return Text("Unknown media type: $type");
  }
}

/// Creates an image widget with caching and error handling.
Widget _imageWidget(String url) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => const Icon(Icons.error),
      placeholder: (context, url) => const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    ),
  );
}

/// Adds a media widget to the list of message parts.
void _addMediaWidget(
    Map<String, String?> mediaItem, List<Widget> messageParts) {
  final mediaWidget = _mediaWidgetFromType(mediaItem);
  messageParts.add(mediaWidget);
}

/// Processes a media marker and adds the corresponding widget to message parts.
void processMediaMarker(
    String marker, List<Widget> messageParts, WidgetRef ref) {
  final cachedMedia = ref.read(mediaCacheProvider.notifier).getMedia(marker);

  if (cachedMedia != null) {
    _addMediaWidget(cachedMedia, messageParts);
  } else {
    messageParts.add(
      FutureBuilder<Map<String, String?>>(
        future: ref.read(mediaCacheProvider.notifier).cacheMedia(marker),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return _mediaWidgetFromType(snapshot.data!);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error loading media: ${snapshot.error}");
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
