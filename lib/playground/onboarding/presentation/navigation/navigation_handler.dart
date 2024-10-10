import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/controllers/first_page_init_actions_controller.dart';
import 'package:in_app_bot/playground/onboarding/presentation/controllers/second_page_init_actions_controller.dart';
import 'package:in_app_bot/playground/onboarding/presentation/controllers/third_page_init_actions_controller.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';
import 'package:in_app_bot/playground/onboarding/services/video_service.dart';

void handlePageChange(
    int page,
    WidgetRef ref,
    AnimationController progressAnimationController,
    bool mounted,
    AnimationController progressAnimationController3,
    Timer? formOpacityTimer) {
  ref.read(UIState.currentPage.notifier).state = page;

  switch (page) {
    case 0:
      final firstPageActionsController =
          FirstPageActionsController(ref, mounted, progressAnimationController);
      firstPageActionsController.initActions();

      break;
    case 1:
      final secondPageActionsController = SecondPageActionsController(
        ref: ref,
        progressAnimationController: progressAnimationController,
        progressAnimationController3: progressAnimationController3,
        mounted: mounted,
      );
      secondPageActionsController.initActions();
      break;
    case 2:
      final thirdPageActionsController = ThirdPageActionsController(
        ref: ref,
        mounted: mounted,
        progressAnimationController3: progressAnimationController3,
        progressAnimationController: progressAnimationController,
      );
      thirdPageActionsController.initActions(formOpacityTimer);
      break;
    default:
      VideoService().pauseAllVideos();
      break;
  }
}
