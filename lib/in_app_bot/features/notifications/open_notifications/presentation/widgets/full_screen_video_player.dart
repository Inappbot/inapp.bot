import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/open_notifications/notifiers/video_controller_notifier.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/open_notifications/presentation/widgets/video_controls_widget.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPlayer extends ConsumerWidget {
  final VideoPlayerController controller;

  const FullScreenVideoPlayer({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showControls = ref.watch(showControlsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTap: () =>
              ref.read(showControlsProvider.notifier).state = !showControls,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                ),
              ),
              if (showControls) VideoControlsWidget(controller: controller),
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
