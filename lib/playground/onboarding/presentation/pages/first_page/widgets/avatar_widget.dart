import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/controllers/first_page_init_actions_controller.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/widgets/video_avatar_widget.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';
import 'package:video_player/video_player.dart';

class AvatarWidget extends ConsumerWidget {
  final bool showImage;
  final VideoPlayerController controller;
  final bool mounted;
  final AnimationController progressAnimationController;

  const AvatarWidget({
    Key? key,
    required this.showImage,
    required this.controller,
    required this.mounted,
    required this.progressAnimationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoEnded = ref.watch(UIState.videoState);
    double videoSize =
        MediaQuery.of(context).size.width * (showImage ? 0.20 : 0.55);
    double imageWidth = MediaQuery.of(context).size.width * 0.394;
    double margin = 10;
    double videoPosition = imageWidth + margin;

    return AnimatedPositioned(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        left: showImage
            ? videoPosition
            : MediaQuery.of(context).size.width / 2 - videoSize / 2,
        top: MediaQuery.of(context).size.height / 2 - videoSize,
        width: videoSize,
        height: videoSize,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 216, 216, 216),
              width: 3,
            ),
            borderRadius: BorderRadius.circular(200),
          ),
          child: VideoAvatarWidget(
            videoSize: videoSize,
            controller: controller,
            videoEnded: videoEnded,
            onReplay: () {
              final firstPageActionsController = FirstPageActionsController(
                  ref, mounted, progressAnimationController);
              firstPageActionsController.initActions();
            },
          ),
        ));
  }
}
