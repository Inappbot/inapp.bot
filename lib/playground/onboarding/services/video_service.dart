import 'package:flutter/material.dart';
import 'package:in_app_bot/playground/onboarding/presentation/controllers/video_controllers.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/utils/timer_utils.dart';
import 'package:video_player/video_player.dart';

class VideoService {
  static final VideoService _instance = VideoService._internal();

  factory VideoService() {
    return _instance;
  }

  VideoService._internal();

  void pauseAllVideos() {
    _pauseVideos([videoController, videoController2, videoController3]);
    cancelPreviousTimers(timers);
    timers = [];
  }

  void _pauseVideos(List<VideoPlayerController?> controllers) {
    for (var controller in controllers) {
      controller?.pause();
    }
  }

  void disposeVideoControllers() {
    _disposeControllers([videoController, videoController2, videoController3]);
    videoController = null;
    videoController2 = null;
    videoController3 = null;
  }

  void _disposeControllers(List<VideoPlayerController?> controllers) {
    for (var controller in controllers) {
      controller?.dispose();
    }
  }

  void resetAndPlayVideos(AnimationController progressAnimationController) {
    cancelPreviousTimers(timers);
    cancelPreviousTimers(timersFirst);
    progressAnimationController.stop();
    _resetVideoControllers();
  }

  void _resetVideoControllers() {
    _seekToStartAndPlay(videoController);
    _pauseVideos([videoController2, videoController3]);
    _setupVideoListener();
  }

  void _seekToStartAndPlay(VideoPlayerController? controller) {
    controller?.seekTo(Duration.zero).then((_) => controller.play());
  }

  void _setupVideoListener() {
    videoController?.addListener(() {
      if (videoController?.value.isPlaying ?? false) {
        videoController?.removeListener(() {});
      }
    });
  }

  void pauseOtherVideos() {
    _pauseVideos([videoController, videoController3]);
  }
}
