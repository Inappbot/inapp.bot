import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/controllers/first_page_init_actions_controller.dart';
import 'package:in_app_bot/playground/onboarding/presentation/controllers/second_page_init_actions_controller.dart';
import 'package:in_app_bot/playground/onboarding/presentation/controllers/third_page_init_actions_controller.dart';
import 'package:in_app_bot/playground/onboarding/presentation/navigation/language_navigation.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';
import 'package:in_app_bot/playground/onboarding/services/video_service.dart';

void performLanguageChangeActions(
  WidgetRef ref,
  String newLanguage,
  int currentPage,
  bool mounted,
  AnimationController progressAnimationController,
  AnimationController progressAnimationController3,
  BuildContext context,
) {
  ref.read(UIConfig.dropdownButtonEnabled.notifier).state = false;
  VideoService().disposeVideoControllers();

  _performPageSpecificActions(
    ref,
    currentPage,
    mounted,
    progressAnimationController,
    progressAnimationController3,
  );

  ref.read(AppConfig.language.notifier).state = newLanguage;
  navigateToOnboardingScreen(context);

  _reenableDropdownButton(ref);
}

void _performPageSpecificActions(
  WidgetRef ref,
  int currentPage,
  bool mounted,
  AnimationController progressAnimationController,
  AnimationController progressAnimationController3,
) {
  final actions = {
    0: () {
      final firstPageActionsController =
          FirstPageActionsController(ref, mounted, progressAnimationController);
      firstPageActionsController.initActions();
    },
    1: () {
      final secondPageActionsController = SecondPageActionsController(
          ref: ref,
          progressAnimationController: progressAnimationController,
          progressAnimationController3: progressAnimationController3,
          mounted: mounted);
      secondPageActionsController.initActions();
    },
    2: () {
      final thirdPageActionsController = ThirdPageActionsController(
        ref: ref,
        mounted: mounted,
        progressAnimationController3: progressAnimationController3,
        progressAnimationController: progressAnimationController,
      );
      thirdPageActionsController.initActions(null);
    },
  };

  actions[currentPage]?.call();
}

void _reenableDropdownButton(WidgetRef ref) {
  Future.delayed(const Duration(milliseconds: 500), () {
    ref.read(UIConfig.dropdownButtonEnabled.notifier).state = true;
  });
}
