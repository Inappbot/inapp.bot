import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';

void updateLottieIndex3(int index, bool mounted, WidgetRef ref) {
  if (mounted) {
    ref.read(AnimationState.lottieAnimationIndex3.notifier).state = index;
  }
}
