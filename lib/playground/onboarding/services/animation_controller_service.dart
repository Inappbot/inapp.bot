import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';

class AnimationControllerService {
  late AnimationController progressAnimationController;
  late AnimationController progressAnimationController3;

  AnimationControllerService(
      {required TickerProvider vsync, required WidgetRef ref}) {
    progressAnimationController = AnimationController(vsync: vsync)
      ..addListener(() {
        ref.read(AnimationState.progressAnimation.notifier).state =
            progressAnimationController.value;
      });

    progressAnimationController3 = AnimationController(vsync: vsync)
      ..addListener(() {
        ref.read(AnimationState.progressAnimation3.notifier).state =
            progressAnimationController3.value;
      });
  }

  void dispose() {
    progressAnimationController.dispose();
    progressAnimationController3.dispose();
  }
}
