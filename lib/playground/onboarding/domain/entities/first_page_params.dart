import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class FirstPageParams {
  final bool showMessage;
  final bool showImage;
  final VideoPlayerController controller;
  final BuildContext context;
  final WidgetRef ref;
  final AnimationController progressAnimationController;
  final AnimationController progressAnimationController3;
  final bool mounted;
  final int currentPage;

  FirstPageParams({
    required this.showMessage,
    required this.showImage,
    required this.controller,
    required this.context,
    required this.ref,
    required this.progressAnimationController,
    required this.progressAnimationController3,
    required this.mounted,
    required this.currentPage,
  });
}
