import 'package:in_app_bot/playground/onboarding/domain/usecases/lottie_animation_use_case.dart';

class ThirdLottieAnimationRepository implements LottieAnimationUseCase {
  @override
  String getAnimationPath(int index) {
    switch (index) {
      case 1:
        return 'lib/playground/onboarding/assets/animations/ai.json';
      case 2:
        return 'lib/playground/onboarding/assets/animations/notification.json';
      default:
        return '';
    }
  }

  @override
  String getTranslatedTitle(int index) {
    return '';
  }
}
