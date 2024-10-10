import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/localization/languages/second_page/translation_utils.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';

void updateLottieIndex(int index, bool mounted, WidgetRef ref) {
  if (mounted) {
    ref.read(AnimationState.lottieAnimationIndex.notifier).state = index;

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
    String translatedTitle = getTranslatedText(ref, titleKey);

    final currentTitles = ref.read(AnimationState.lottieTitles.notifier).state;
    if (!currentTitles.contains(translatedTitle)) {
      ref.read(AnimationState.lottieTitles.notifier).state = [
        ...currentTitles,
        translatedTitle
      ];
    }
  }
}
