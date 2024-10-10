import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

/// Represents the state of the video player.
class VideoState {
  final VideoPlayerController controller;
  final bool showPlayButton;
  final bool isBuffering;

  VideoState({
    required this.controller,
    this.showPlayButton = true,
    this.isBuffering = false,
  });

  /// Creates a copy of the current state with optional new values.
  VideoState copyWith({
    VideoPlayerController? controller,
    bool? showPlayButton,
    bool? isBuffering,
  }) {
    return VideoState(
      controller: controller ?? this.controller,
      showPlayButton: showPlayButton ?? this.showPlayButton,
      isBuffering: isBuffering ?? this.isBuffering,
    );
  }
}

/// Manages the state and logic for the video player.
class VideoNotifier extends StateNotifier<VideoState> {
  VideoNotifier(String url)
      : super(VideoState(
            controller: VideoPlayerController.networkUrl(Uri.parse(url)))) {
    _initializeVideoPlayer();
  }

  Timer? _hidePlayButtonTimer;

  /// Initializes the video player controller.
  Future<void> _initializeVideoPlayer() async {
    try {
      await state.controller.initialize();
      state.controller.addListener(_checkBuffering);
      state = state.copyWith(showPlayButton: true);
    } catch (e) {
      log("Error initializing video player: $e");
    }
  }

  /// Checks and updates the buffering state of the video.
  void _checkBuffering() {
    state = state.copyWith(isBuffering: state.controller.value.isBuffering);
  }

  /// Handles tap events on the video player.
  void handleTap() {
    _hidePlayButtonTimer?.cancel();

    if (state.controller.value.isPlaying) {
      state.controller.pause();
      state = state.copyWith(showPlayButton: true);
    } else {
      state.controller.play();
      state = state.copyWith(showPlayButton: false);
      _hidePlayButtonTimer = Timer(const Duration(seconds: 1), () {
        state = state.copyWith(showPlayButton: false);
      });
    }
  }

  @override
  void dispose() {
    state.controller.removeListener(_checkBuffering);
    state.controller.dispose();
    _hidePlayButtonTimer?.cancel();
    super.dispose();
  }
}

/// Provider for the video player state. Uses family to create unique instances for each URL.
final videoProvider =
    StateNotifierProvider.family<VideoNotifier, VideoState, String>((ref, url) {
  return VideoNotifier(url);
});

/// A widget that displays and controls a video player.
class VideoWidget extends ConsumerWidget {
  final String url;

  const VideoWidget({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoState = ref.watch(videoProvider(url));

    return GestureDetector(
      onTap: () => ref.read(videoProvider(url).notifier).handleTap(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AspectRatio(
          aspectRatio: videoState.controller.value.aspectRatio,
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(videoState.controller),
              if (videoState.isBuffering) const CircularProgressIndicator(),
              if (videoState.showPlayButton)
                Icon(
                  videoState.controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                  size: 64.0,
                ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: VideoProgressIndicator(
                  videoState.controller,
                  allowScrubbing: true,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
