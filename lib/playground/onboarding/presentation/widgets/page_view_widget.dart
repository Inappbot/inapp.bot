import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/builders/page_content_builder.dart';
import 'package:in_app_bot/playground/onboarding/presentation/controllers/video_controllers.dart';
import 'package:in_app_bot/playground/onboarding/presentation/navigation/navigation_handler.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';
import 'package:in_app_bot/playground/onboarding/services/animation_controller_service.dart';

class PageViewWidget extends StatelessWidget {
  final PageController pageController;
  final GlobalKey<FormState> formKey;
  final WidgetRef ref;
  final bool mounted;
  final AnimationControllerService animationControllerService;
  final Timer? formOpacityTimer;

  const PageViewWidget({
    Key? key,
    required this.pageController,
    required this.formKey,
    required this.ref,
    required this.mounted,
    required this.animationControllerService,
    required this.formOpacityTimer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (videoController == null ||
        videoController2 == null ||
        videoController3 == null) {
      return Container();
    }

    final showMessage = ref.watch(UIState.showMessage);
    final showImage = ref.watch(UIState.showImage);
    final showImage2 = ref.watch(UIState.showImage2);
    final currentPage = ref.watch(UIState.currentPage);

    return PageView.builder(
      controller: pageController,
      itemCount: 3,
      onPageChanged: (int page) => handlePageChange(
        page,
        ref,
        animationControllerService.progressAnimationController,
        mounted,
        animationControllerService.progressAnimationController3,
        formOpacityTimer,
      ),
      itemBuilder: (context, index) => buildPageContent(
        context,
        index,
        showMessage,
        showImage,
        showImage2,
        videoController!,
        videoController2!,
        videoController3!,
        ref,
        formKey,
        animationControllerService.progressAnimationController,
        animationControllerService.progressAnimationController3,
        mounted,
        currentPage,
      ),
    );
  }
}
