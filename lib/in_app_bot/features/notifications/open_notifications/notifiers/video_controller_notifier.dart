import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

final videoControllerProvider = StateNotifierProvider.family<
    VideoControllerNotifier, AsyncValue<VideoPlayerController>, String>(
  (ref, url) => VideoControllerNotifier(url),
);

class VideoControllerNotifier
    extends StateNotifier<AsyncValue<VideoPlayerController>> {
  VideoControllerNotifier(String url) : super(const AsyncValue.loading()) {
    _initializeController(url);
  }

  Future<void> _initializeController(String url) async {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
        throw Exception('Invalid URL');
      }

      final controller = VideoPlayerController.networkUrl(uri);
      await controller.initialize();
      controller.setLooping(false);
      controller.play();
      state = AsyncValue.data(controller);
      controller.addListener(_listener);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void _listener() {}

  @override
  void dispose() {
    state.whenData((controller) {
      controller.removeListener(_listener);
      controller.dispose();
    });
    super.dispose();
  }

  void togglePlayPause() {
    state.whenData((controller) {
      if (controller.value.isPlaying) {
        controller.pause();
      } else {
        controller.play();
      }
    });
  }

  void stopAndResetVideo() {
    state.whenData((controller) {
      controller.pause();
      controller.seekTo(Duration.zero);
    });
  }
}

final showControlsProvider = StateProvider.autoDispose<bool>((ref) => false);
