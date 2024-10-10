import 'package:flutter/material.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/widgets/replay_button.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/widgets/video_progress_indicator.dart';
import 'package:video_player/video_player.dart';

class VideoAvatarWidget extends StatelessWidget {
  final double videoSize;
  final VideoPlayerController controller;
  final double? progress;
  final bool videoEnded;
  final VoidCallback onReplay;

  const VideoAvatarWidget({
    required this.videoSize,
    required this.controller,
    this.progress,
    required this.videoEnded,
    required this.onReplay,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: videoSize,
      height: videoSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipOval(
            child: AspectRatio(
              aspectRatio: controller.value.isInitialized
                  ? controller.value.aspectRatio
                  : 1.0,
              child: VideoPlayer(controller),
            ),
          ),
          if (progress != null && !videoEnded)
            CustomVideoProgressIndicator(
              progress: progress!,
              totalDuration: controller.value.duration,
              size: videoSize,
            ),
          AnimatedOpacity(
            opacity: videoEnded ? 1.0 : 0.0,
            duration:
                videoEnded ? const Duration(milliseconds: 300) : Duration.zero,
            child: videoEnded
                ? ReplayButton(size: videoSize, onPressed: onReplay)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
