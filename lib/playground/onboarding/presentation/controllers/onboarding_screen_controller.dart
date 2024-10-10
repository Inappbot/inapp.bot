import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/infrastructure/services/video_player_manager.dart';
import 'package:in_app_bot/playground/onboarding/presentation/controllers/video_controllers.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/utils/timer_utils.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';
import 'package:in_app_bot/playground/onboarding/services/animation_controller_service.dart';
import 'package:in_app_bot/playground/onboarding/services/video_player_initializer_service.dart';

class OnboardingScreenController {
  final BuildContext context;
  final WidgetRef ref;
  final TickerProviderStateMixin tickerProvider;

  late final PageController pageController;
  late final AnimationControllerService animationControllerService;
  final formKey = GlobalKey<FormState>();
  Timer? formOpacityTimer;
  String? currentLanguage;
  bool isVideoInitialized = false;
  final VideoPlayerManager videoPlayerManager = VideoPlayerManager();
  late VoidCallback onNeedUpdate;

  OnboardingScreenController(this.context, this.ref, this.tickerProvider);

  void setupInitialDependencies() {
    animationControllerService =
        AnimationControllerService(vsync: tickerProvider, ref: ref);
    setupLanguageDependencies();
    pageController = PageController();
  }

  void setupLanguageDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String newLanguage = ref.watch(AppConfig.language);
      if (currentLanguage != newLanguage) {
        updateLanguage(newLanguage);
      }
    });
  }

  void updateLanguage(String newLanguage) {
    pauseAllVideoPlayers();
    setCurrentLanguage(newLanguage);
    initializeVideoPlayers();
    finalizeUpdate();
  }

  void pauseAllVideoPlayers() {
    videoPlayerManager.pauseVideoPlayers(
      videoController: videoController,
      videoController2: videoController2,
      videoController3: videoController3,
    );
  }

  void setCurrentLanguage(String newLanguage) {
    currentLanguage = newLanguage;
  }

  void initializeVideoPlayers() {
    final videoPlayerInitializer = VideoPlayerInitializerFacade(
      mounted: tickerProvider.mounted,
      ref: ref,
      animationControllerService: animationControllerService,
    );
    videoPlayerInitializer.initializeVideoPlayers();
    isVideoInitialized = true;
  }

  void finalizeUpdate() {
    if (tickerProvider.mounted) {
      onNeedUpdate.call();
    }
  }

  void handleKeyboardVisibility() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
      ref.read(UIState.keyboardVisibility.notifier).state = keyboardVisible;
    });
  }

  void dispose() {
    disposeControllers();
    formOpacityTimer?.cancel();
    cancelPreviousTimers(timers);
    cancelPreviousTimers(timersFirst);
  }

  void disposeControllers() {
    videoController?.dispose();
    videoController2?.dispose();
    videoController3?.dispose();
    animationControllerService.dispose();
    pageController.dispose();
  }
}
