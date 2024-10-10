import 'package:flutter/material.dart';
import 'package:in_app_bot/playground/onboarding/presentation/widgets/video_progress_indicator.dart';

class CustomVideoProgressIndicator extends StatelessWidget {
  final double progress;
  final Duration totalDuration;
  final double size;

  const CustomVideoProgressIndicator({
    required this.progress,
    required this.totalDuration,
    required this.size,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: VideoProgressIndicatorCircle(
        progress: progress,
        totalDuration: totalDuration,
      ),
    );
  }
}
