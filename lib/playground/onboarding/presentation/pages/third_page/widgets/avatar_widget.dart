import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/controllers/third_page_init_actions_controller.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/widgets/video_avatar_widget.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';
import 'package:video_player/video_player.dart';

class AvatarWidget extends StatelessWidget {
  final BuildContext context;
  final VideoPlayerController controller3;
  final WidgetRef ref;
  final AnimationController progressAnimationController;
  final AnimationController progressAnimationController3;
  final bool mounted;

  const AvatarWidget({
    required this.context,
    required this.controller3,
    required this.ref,
    required this.progressAnimationController,
    required this.progressAnimationController3,
    required this.mounted,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double videoSize = MediaQuery.of(context).size.width * 0.55;
    final progress = ref.watch(AnimationState.progressAnimation3);
    final videoEnded = ref.watch(UIState.videoState);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: VideoAvatarWidget(
          videoSize: videoSize,
          controller: controller3,
          progress: progress,
          videoEnded: videoEnded,
          onReplay: () => _handleReplay(),
        ),
      ),
    );
  }

  void _handleReplay() {
    if (mounted) {
      progressAnimationController3.reset();
      WidgetsBinding.instance
          .addPostFrameCallback((_) => progressAnimationController3.forward());

      final thirdPageActionsController = ThirdPageActionsController(
        ref: ref,
        mounted: true,
        progressAnimationController3: progressAnimationController3,
        progressAnimationController: progressAnimationController,
      );
      thirdPageActionsController.initActions(null);
    }
  }
}
