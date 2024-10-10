import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/infrastructure/services/haptic_feedback_service.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/utils/timer_utils.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';
import 'package:in_app_bot/playground/onboarding/services/video_service.dart';

class FirstPageActionsController {
  final WidgetRef ref;
  final bool mounted;
  final AnimationController progressAnimationController;

  FirstPageActionsController(
      this.ref, this.mounted, this.progressAnimationController);

  void initActions() {
    _resetStates(ref);
    HapticFeedbackService.triggerFeedback();
    VideoService().resetAndPlayVideos(progressAnimationController);
    _setupTimers(ref, mounted);
  }

  void _resetStates(WidgetRef ref) {
    ref.read(UIState.showMessage.notifier).state = false;
    ref.read(UIState.showImage.notifier).state = false;
    ref.read(UIState.currentPage.notifier).state = 0;
    ref.read(AnimationState.lottieAnimationIndex.notifier).state = 0;
    ref.read(AnimationState.lottieTitles.notifier).state = [];
  }

  void _setupTimers(WidgetRef ref, bool mounted) {
    if (!mounted) return;
    var timerShowMessage = Timer(const Duration(seconds: 2),
        () => ref.read(UIState.showMessage.notifier).state = true);
    var timerShowImage = Timer(const Duration(milliseconds: 6500),
        () => ref.read(UIState.showImage.notifier).state = true);

    timersFirst
      ..add(timerShowMessage)
      ..add(timerShowImage);
  }
}
