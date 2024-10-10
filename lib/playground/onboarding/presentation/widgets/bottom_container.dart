import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/localization/languages/continue_languages.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/theme/decoration_extensions.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/theme/text_style_extensions.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/utils/timer_utils.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';
import 'package:in_app_bot/playground/onboarding/presentation/utils/state_reset_utils.dart';
import 'package:in_app_bot/playground/presentation/screens/play_details_page.dart';

class BottomContainer extends ConsumerWidget {
  final Widget child;
  final int currentPage;
  final PageController pageController;

  const BottomContainer({
    Key? key,
    required this.child,
    required this.currentPage,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isKeyboardVisible = ref.watch(UIState.keyboardVisibility);
    final selectedLanguage = ref.watch(AppConfig.language);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!isKeyboardVisible) _skipButton(context, ref, selectedLanguage),
        _gradientChildContainer(child: child),
      ],
    );
  }

  Widget _skipButton(
      BuildContext context, WidgetRef ref, String selectedLanguage) {
    final skipText = translations[selectedLanguage]?['skip'] ?? 'Skip';
    return Padding(
      padding: const EdgeInsets.only(right: 16, top: 16),
      child: GestureDetector(
        onTap: () => _handleSkipTap(context, ref),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(skipText, style: TextStyleExtensions.skipButton),
        ),
      ),
    );
  }

  void _handleSkipTap(BuildContext context, WidgetRef ref) {
    final isLastPage = currentPage < 2;
    cancelPreviousTimers(timersFirst);
    cancelPreviousTimers(timers);
    if (isLastPage) {
      pageController.animateToPage(
        currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      resetStates(ref);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const PlayDetailsPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  Widget _gradientChildContainer({required Widget child}) => Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: DecorationExtensions.gradientChildContainer,
        child: child,
      );
}
