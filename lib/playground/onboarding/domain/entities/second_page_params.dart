import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class SecondPageParams {
  final bool showImage2;
  final VideoPlayerController controller2;
  final WidgetRef ref;
  final BuildContext context;
  final AnimationController progressAnimationController;
  final AnimationController progressAnimationController3;
  final bool mounted;
  final int currentPage;

  SecondPageParams({
    required this.showImage2,
    required this.controller2,
    required this.ref,
    required this.context,
    required this.progressAnimationController,
    required this.progressAnimationController3,
    required this.mounted,
    required this.currentPage,
  });
}
