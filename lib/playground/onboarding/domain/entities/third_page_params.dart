import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class ThirdPageParams {
  final bool showImage2;
  final VideoPlayerController controller3;
  final WidgetRef ref;
  final BuildContext context;
  final GlobalKey<FormState> formKey;
  final AnimationController progressAnimationController;
  final AnimationController progressAnimationController3;
  final bool mounted;
  final int currentPage;

  ThirdPageParams({
    required this.showImage2,
    required this.controller3,
    required this.ref,
    required this.context,
    required this.formKey,
    required this.progressAnimationController,
    required this.progressAnimationController3,
    required this.mounted,
    required this.currentPage,
  });
}
