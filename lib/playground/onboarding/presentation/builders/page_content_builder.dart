import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/domain/entities/first_page_params.dart';
import 'package:in_app_bot/playground/onboarding/domain/entities/second_page_params.dart';
import 'package:in_app_bot/playground/onboarding/domain/entities/third_page_params.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/first_page/first_page.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/second_page/second_page.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/third_page/third_page_builder.dart';
import 'package:video_player/video_player.dart';

Widget buildPageContent(
  BuildContext context,
  int index,
  bool showMessage,
  bool showImage,
  bool showImage2,
  VideoPlayerController controller,
  VideoPlayerController controller2,
  VideoPlayerController controller3,
  WidgetRef ref,
  GlobalKey<FormState> formKey,
  AnimationController progressAnimationController,
  AnimationController progressAnimationController3,
  bool mounted,
  int currentPage,
) {
  switch (index) {
    case 0:
      return FirstPage(
        params: FirstPageParams(
          showMessage: showMessage,
          showImage: showImage,
          controller: controller,
          context: context,
          ref: ref,
          progressAnimationController: progressAnimationController,
          progressAnimationController3: progressAnimationController3,
          mounted: mounted,
          currentPage: currentPage,
        ),
      );

    case 1:
      return SecondPage(
        params: SecondPageParams(
          showImage2: showImage2,
          controller2: controller2,
          ref: ref,
          context: context,
          progressAnimationController: progressAnimationController,
          progressAnimationController3: progressAnimationController3,
          mounted: mounted,
          currentPage: currentPage,
        ),
      );
    case 2:
      return ThirdPageBuilder.buildThirdPage(
        ThirdPageParams(
          showImage2: showImage2,
          controller3: controller3,
          ref: ref,
          context: context,
          formKey: formKey,
          progressAnimationController: progressAnimationController,
          progressAnimationController3: progressAnimationController3,
          mounted: mounted,
          currentPage: currentPage,
        ),
      );
    default:
      return Container();
  }
}
