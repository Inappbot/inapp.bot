import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/infrastructure/services/haptic_feedback_service.dart';
import 'package:in_app_bot/playground/onboarding/presentation/controllers/video_controllers.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/localization/languages/third_page/lottie_durations.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/utils/timer_utils.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/third_page/widgets/animated/lottie_index_updater.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';

class ThirdPageActionsController {
  final WidgetRef ref;
  final bool mounted;
  final AnimationController progressAnimationController3;
  final AnimationController progressAnimationController;

  ThirdPageActionsController({
    required this.ref,
    required this.mounted,
    required this.progressAnimationController3,
    required this.progressAnimationController,
  });

  void initActions(Timer? formOpacityTimer) {
    HapticFeedbackService.triggerFeedback();
    resetStatesAndControllers();
    cancelPreviousTimers(timers);
    String currentLanguage = ref.read(AppConfig.language);
    List<Duration> lottieDurations3 = getLottieDurations3(currentLanguage);
    pauseOtherVideos();
    startVideoAndPerformActions(lottieDurations3);
  }

  void resetStatesAndControllers() {
    ref.read(AnimationState.lottieAnimationIndex.notifier).state = 0;
    ref.read(AnimationState.lottieTitles.notifier).state = [];
    ref.read(AnimationState.lottieAnimationIndex3.notifier).state = 0;
    ref.read(AnimationState.lottieTitles3.notifier).state = [];
    ref.read(UIState.showMessage.notifier).state = false;
    ref.read(UIState.showImage.notifier).state = false;
    ref.read(UIState.showForm.notifier).state = false;
    ref.read(UIState.formOpacity.notifier).state = 0.0;
    progressAnimationController.reset();
    progressAnimationController.stop();
  }

  List<Duration> getLottieDurations3(String currentLanguage) {
    return lottieDurations3ByLanguage[currentLanguage] ??
        lottieDurations3ByLanguage['en']!;
  }

  void pauseOtherVideos() {
    videoController?.pause();
    videoController2?.pause();
  }

  void startVideoAndPerformActions(List<Duration> lottieDurations3) {
    videoController3
        ?.seekTo(Duration.zero)
        .then((_) => videoController3?.play())
        .then((_) {
      if (videoController3?.value.isPlaying ?? false) {
        progressAnimationController3.reset();
        progressAnimationController3.forward();
        setupTimersAndActions(lottieDurations3);
      }
    }).catchError((error) {
      log("Error attempting to play the video: $error");
    });
  }

  void setupTimersAndActions(List<Duration> lottieDurations3) {
    timers.addAll([
      Timer(const Duration(milliseconds: 200), () => updateUIState(true)),
      Timer(const Duration(milliseconds: 1500), () => updateUIState(false)),
    ]);

    for (int i = 0; i < lottieDurations3.length - 1; i++) {
      timers.add(
          Timer(lottieDurations3[i], () => updateLottieIndex3IfMounted(i + 1)));
    }

    Duration showFormDuration = lottieDurations3.last;
    timers.add(Timer(showFormDuration, () => updateFormVisibilityIfMounted()));
  }

  void updateUIState(bool showImage) {
    if (mounted) {
      ref.read(UIState.showImage2.notifier).state = showImage;
    }
  }

  void updateLottieIndex3IfMounted(int index) {
    if (mounted) {
      updateLottieIndex3(index, mounted, ref);
    }
  }

  void updateFormVisibilityIfMounted() {
    if (mounted) {
      ref.read(UIState.showForm.notifier).state = true;
      ref.read(UIState.formOpacity.notifier).state = 1.0;
    }
  }
}
