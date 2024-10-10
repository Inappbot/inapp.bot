import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/controllers/first_page_init_actions_controller.dart';
import 'package:in_app_bot/playground/onboarding/presentation/controllers/video_controllers.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/localization/languages/third_page/language_video_paths.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/utils/timer_utils.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerInitializer {
  final bool mounted;
  final WidgetRef ref;
  final AnimationController progressAnimationController;
  final AnimationController progressAnimationController3;

  VideoPlayerInitializer({
    required this.mounted,
    required this.ref,
    required this.progressAnimationController,
    required this.progressAnimationController3,
  });

  Future<void> initializeVideoPlayers() async {
    final language = ref.read(AppConfig.language);

    final videoPaths = LanguageVideoPaths.paths[language] ??
        [
          'lib/playground/onboarding/assets/videos/en/avatar_onboarding_1.mp4',
          'lib/playground/onboarding/assets/videos/en/avatar_onboarding_2.mp4',
          'lib/playground/onboarding/assets/videos/en/avatar_onboarding_3.mp4',
        ];

    for (var i = 0; i < videoPaths.length; i++) {
      await _initializeVideoPlayer(videoPaths[i], videoIndex: i);
    }
  }

  Future<void> _initializeVideoPlayer(String videoPath,
      {int videoIndex = 0}) async {
    final controller = VideoPlayerController.asset(videoPath);
    controller.initialize().then((_) {
      _onVideoControllerInitialized(controller, videoIndex);
    });

    _setupVideoControllerListener(controller, videoIndex);
  }

  void _onVideoControllerInitialized(
      VideoPlayerController controller, int videoIndex) {
    switch (videoIndex) {
      case 0:
        _onFirstVideoControllerInitialized(controller);
        break;
      case 1:
        _onSecondVideoControllerInitialized(controller);
        break;
      case 2:
        _onThirdVideoControllerInitialized(controller);
        break;
      default:
        break;
    }
  }

  void _setupVideoControllerListener(
      VideoPlayerController controller, int videoIndex) {
    controller.addListener(() {
      final shouldPause = _shouldPauseVideo(controller);
      if (shouldPause) {
        controller.pause();
      }
      ref.read(UIState.videoState.notifier).state = shouldPause;
    });
    _assignControllerToGlobal(controller, videoIndex);
  }

  bool _shouldPauseVideo(VideoPlayerController controller) {
    final isPlaying = controller.value.isPlaying;
    final currentPosition = controller.value.position;
    final videoLength = controller.value.duration;
    const endMargin = Duration(milliseconds: 500);

    final remainingTimeIsLessOrEqualEndMargin =
        currentPosition.inMilliseconds >=
            (videoLength - endMargin).inMilliseconds;

    final shouldPause = isPlaying && remainingTimeIsLessOrEqualEndMargin;

    return shouldPause;
  }

  void _assignControllerToGlobal(
      VideoPlayerController controller, int videoIndex) {
    switch (videoIndex) {
      case 0:
        videoController = controller;
        break;
      case 1:
        videoController2 = controller;
        break;
      case 2:
        videoController3 = controller;
        break;
      default:
        break;
    }
  }

  void _onFirstVideoControllerInitialized(VideoPlayerController controller) {
    if (mounted) {
      controller.play().then((_) {
        if (mounted) {
          final firstPageActionsController = FirstPageActionsController(
              ref, mounted, progressAnimationController);
          firstPageActionsController.initActions();
        }
      });
    }
  }

  void _onSecondVideoControllerInitialized(VideoPlayerController controller) {
    cancelPreviousTimers(timers);
    progressAnimationController.duration = controller.value.duration;
  }

  void _onThirdVideoControllerInitialized(VideoPlayerController controller) {
    cancelPreviousTimers(timers3);
    progressAnimationController3.duration = controller.value.duration;
  }
}
