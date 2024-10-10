import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/data/repositories/subcription_form_repository.dart';
import 'package:in_app_bot/playground/onboarding/infrastructure/services/haptic_feedback_service.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/localization/languages/continue_languages.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/utils/timer_utils.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/subscription_form_provider.dart';
import 'package:in_app_bot/playground/onboarding/presentation/utils/state_reset_utils.dart';
import 'package:in_app_bot/playground/presentation/screens/play_details_page.dart';

class ContinueButton extends ConsumerWidget {
  final int currentPage;
  final PageController pageController;
  final GlobalKey<FormState> formKey;

  const ContinueButton({
    Key? key,
    required this.currentPage,
    required this.pageController,
    required this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLastPage = currentPage == 2;
    final showForm = ref.watch(UIState.showForm);
    final selectedLanguage = ref.watch(AppConfig.language);
    final buttonText = _getButtonText(isLastPage, showForm, selectedLanguage);

    return TextButton(
      onPressed: () => _onPressed(context, ref, isLastPage, showForm),
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      child: Text(
        buttonText,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  void _onPressed(
      BuildContext context, WidgetRef ref, bool isLastPage, bool showForm) {
    if (isLastPage && showForm) {
      _submitForm(context, ref);
    } else if (!isLastPage) {
      _navigateToNextPage(context, ref);
    }
  }

  void _submitForm(BuildContext context, WidgetRef ref) {
    if (formKey.currentState!.validate()) {
      HapticFeedbackService.triggerFeedback();
      resetStates(ref);

      final email = ref.read(subscriptionFormProvider).email;
      final name = ref.read(subscriptionFormProvider).name;
      ref.read(subcriptionFormRepositoryProvider).saveSubscription(email, name);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const PlayDetailsPage()),
        (Route<dynamic> route) => false,
      );
      ref.read(subscriptionFormProvider.notifier).state = SubscriptionForm();
    } else {
      HapticFeedbackService.triggerFeedback();
    }
  }

  void _navigateToNextPage(BuildContext context, WidgetRef ref) {
    cancelPreviousTimers(timers);
    pageController.animateToPage(
      currentPage + 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  String _getButtonText(
      bool isLastPage, bool showForm, String selectedLanguage) {
    if (isLastPage && showForm) {
      return translations[selectedLanguage]!['submit'] ?? 'Submit';
    } else {
      return translations[selectedLanguage]!['next'] ?? 'Next';
    }
  }
}
