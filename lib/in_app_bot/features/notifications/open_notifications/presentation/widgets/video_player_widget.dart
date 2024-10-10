import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/open_notifications/notifiers/video_controller_notifier.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/open_notifications/presentation/widgets/full_screen_video_player.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/open_notifications/presentation/widgets/video_controls_widget.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends ConsumerWidget {
  final String url;

  const VideoPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoControllerAsync = ref.watch(videoControllerProvider(url));
    final showControls = ref.watch(showControlsProvider);

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: videoControllerAsync.when(
        data: (controller) => GestureDetector(
          onTap: () =>
              ref.read(showControlsProvider.notifier).state = !showControls,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
              if (showControls) VideoControlsWidget(controller: controller),
              Positioned(
                right: 8,
                top: 8,
                child: IconButton(
                  icon: const Icon(Icons.fullscreen, color: Colors.white),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FullScreenVideoPlayer(controller: controller),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Icon(Icons.error)),
      ),
    );
  }
}
