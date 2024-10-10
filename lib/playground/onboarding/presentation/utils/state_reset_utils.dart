import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/controllers/video_controllers.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/utils/timer_utils.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';

void resetStates(WidgetRef ref) {
  ref.read(UIState.showMessage.notifier).state = false;
  ref.read(UIState.showImage.notifier).state = false;
  ref.read(UIState.currentPage.notifier).state = 0;
  ref.read(UIState.showImage2.notifier).state = false;
  ref.read(AnimationState.lottieAnimationIndex.notifier).state = 0;
  ref.read(AnimationState.lottieTitles.notifier).state = [];
  ref.read(UIState.videoState.notifier).state = false;
  cancelPreviousTimers(timers);
  timers = [];
  videoController3?.pause();
}
