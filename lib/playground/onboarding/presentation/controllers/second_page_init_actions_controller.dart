import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/infrastructure/services/haptic_feedback_service.dart';
import 'package:in_app_bot/playground/onboarding/presentation/controllers/video_controllers.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/localization/languages/second_page/lottie_durations.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/utils/timer_utils.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/second_page/widgets/animated/lottie_index_updater.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';
import 'package:in_app_bot/playground/onboarding/services/video_service.dart';

class SecondPageActionsController {
  final WidgetRef ref;
  final AnimationController progressAnimationController;
  final AnimationController progressAnimationController3;
  final bool mounted;

  SecondPageActionsController({
    required this.ref,
    required this.progressAnimationController,
    required this.progressAnimationController3,
    required this.mounted,
  });

  void initActions() {
    HapticFeedbackService.triggerFeedback();
    resetStatesAndControllers();
    cancelPreviousTimers(timers);
    String currentLanguage = ref.read(AppConfig.language);
    List<Duration> lottieDurations = getLottieDurations(currentLanguage);
    VideoService().pauseOtherVideos();
    startVideoAndPerformActions(lottieDurations);
  }

  void resetStatesAndControllers() {
    ref.read(AnimationState.lottieAnimationIndex.notifier).state = 0;
    ref.read(AnimationState.lottieTitles.notifier).state = [];
    ref.read(AnimationState.lottieAnimationIndex3.notifier).state = 0;
    ref.read(AnimationState.lottieTitles3.notifier).state = [];
    ref.read(UIState.showMessage.notifier).state = false;
    ref.read(UIState.showImage.notifier).state = false;

    progressAnimationController3.reset();
    progressAnimationController3.stop();
  }

  List<Duration> getLottieDurations(String currentLanguage) {
    return lottieDurationsByLanguage[currentLanguage] ??
        lottieDurationsByLanguage['en']!;
  }

  void startVideoAndPerformActions(List<Duration> lottieDurations) {
    videoController2
        ?.seekTo(Duration.zero)
        .then((_) => videoController2?.play())
        .then((_) {
      if (videoController2?.value.isPlaying ?? false) {
        progressAnimationController.reset();
        progressAnimationController.forward();
        setupTimersAndActions(lottieDurations);
      }
    }).catchError((error) {
      log("Error attempting to play the video: $error");
    });
  }

  void setupTimersAndActions(List<Duration> lottieDurations) {
    timers.addAll([
      Timer(const Duration(milliseconds: 200), () => updateUIState(true)),
      Timer(const Duration(milliseconds: 1500), () => updateUIState(false)),
    ]);

    for (var duration in lottieDurations) {
      timers.add(Timer(
          duration,
          () => updateLottieIndexIfMounted(
              lottieDurations.indexOf(duration) + 1)));
    }
  }

  void updateUIState(bool showImage) {
    if (mounted) {
      ref.read(UIState.showImage2.notifier).state = showImage;
    }
  }

  void updateLottieIndexIfMounted(int index) {
    if (mounted) {
      updateLottieIndex(index, mounted, ref);
    }
  }
}
