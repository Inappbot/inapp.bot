import 'package:video_player/video_player.dart';

class VideoPlayerManager {
  void pauseVideoPlayers({
    VideoPlayerController? videoController,
    VideoPlayerController? videoController2,
    VideoPlayerController? videoController3,
  }) {
    videoController?.pause();
    videoController?.seekTo(Duration.zero);
    videoController?.dispose();
    videoController = null;

    videoController2?.pause();
    videoController2?.seekTo(Duration.zero);
    videoController2?.dispose();
    videoController2 = null;

    videoController3?.pause();
    videoController3?.seekTo(Duration.zero);
    videoController3?.dispose();
    videoController3 = null;
  }
}
