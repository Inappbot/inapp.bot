import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/controllers/second_page_init_actions_controller.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/widgets/video_avatar_widget.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';
import 'package:video_player/video_player.dart';

class AvatarWidget extends ConsumerWidget {
  final VideoPlayerController controller;
  final AnimationController progressAnimationController;
  final AnimationController progressAnimationController3;
  final bool mounted;

  const AvatarWidget({
    Key? key,
    required this.controller,
    required this.progressAnimationController,
    required this.progressAnimationController3,
    required this.mounted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double videoSize = MediaQuery.of(context).size.width * 0.55;
    final progress = ref.watch(AnimationState.progressAnimation);
    final videoEnded = ref.watch(UIState.videoState);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: VideoAvatarWidget(
          videoSize: videoSize,
          controller: controller,
          progress: progress,
          videoEnded: videoEnded,
          onReplay: () => _handleReplayPressed(ref),
        ),
      ),
    );
  }

  void _handleReplayPressed(WidgetRef ref) {
    if (mounted) {
      final secondPageActionsController = SecondPageActionsController(
        ref: ref,
        progressAnimationController: progressAnimationController,
        progressAnimationController3: progressAnimationController3,
        mounted: mounted,
      );
      secondPageActionsController.initActions();
    }
  }
}
