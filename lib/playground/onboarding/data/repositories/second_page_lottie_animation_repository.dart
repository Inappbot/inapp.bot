import 'package:in_app_bot/playground/onboarding/domain/usecases/lottie_animation_use_case.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/services/translation_service.dart';

class SecondLottieAnimationRepository implements LottieAnimationUseCase {
  final TranslationService translationService;

  SecondLottieAnimationRepository(this.translationService);

  @override
  String getTranslatedTitle(int index) {
    Map<int, String> titleKeys = {
      1: 'focusOnYourBusiness',
      2: 'managedUsers',
      3: 'adminPanel',
      4: 'variousAvatars',
      5: 'pdfsWebText',
      6: 'accurateAnswers',
      7: 'support247',
      8: 'instantReplies',
      9: 'developmentMaintenance',
      10: 'swiftApp',
      11: 'kotlinApp',
      12: 'flutterApp',
      13: 'webApp',
      14: 'explorePlayground',
    };

    String titleKey = titleKeys[index] ?? 'defaultKey';
    return translationService.getTranslation(titleKey);
  }

  @override
  String getAnimationPath(int index) {
    switch (index) {
      case 1:
        return 'lib/playground/onboarding/assets/animations/business.json';
      case 2:
        return 'lib/playground/onboarding/assets/animations/chat247.json';
      case 3:
        return 'lib/playground/onboarding/assets/animations/adminpanel.json';
      case 4:
        return 'lib/playground/onboarding/assets/animations/avatars.json';
      case 5:
        return 'lib/playground/onboarding/assets/animations/3files.json';
      case 6:
        return 'lib/playground/onboarding/assets/animations/newsupport.json';
      case 7:
        return 'lib/playground/onboarding/assets/animations/24.json';
      case 8:
        return 'lib/playground/onboarding/assets/animations/peoples.json';
      case 9:
        return 'lib/playground/onboarding/assets/animations/development.json';
      case 10:
        return 'lib/playground/onboarding/assets/animations/swift.json';
      case 11:
        return 'lib/playground/onboarding/assets/animations/kotlin.json';
      case 12:
        return 'lib/playground/onboarding/assets/animations/flutter.json';
      case 13:
        return 'lib/playground/onboarding/assets/animations/web.json';
      case 14:
        return 'lib/playground/onboarding/assets/animations/explore.json';
      default:
        return '';
    }
  }
}
