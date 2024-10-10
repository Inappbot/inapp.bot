import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/services/animation_controller_service.dart';
import 'package:in_app_bot/playground/onboarding/utils/video_player_initializer.dart';

class VideoPlayerInitializerFacade {
  final bool mounted;
  final WidgetRef ref;
  final AnimationControllerService animationControllerService;

  VideoPlayerInitializerFacade({
    required this.mounted,
    required this.ref,
    required this.animationControllerService,
  });

  void initializeVideoPlayers() {
    final videoPlayerInitializer = VideoPlayerInitializer(
      mounted: mounted,
      ref: ref,
      progressAnimationController:
          animationControllerService.progressAnimationController,
      progressAnimationController3:
          animationControllerService.progressAnimationController3,
    );

    videoPlayerInitializer.initializeVideoPlayers();
  }
}
