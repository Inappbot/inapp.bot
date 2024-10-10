import 'package:flutter/material.dart';
import 'package:in_app_bot/playground/onboarding/domain/entities/second_page_params.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/second_page/widgets/animated/lottie_animation_widget.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/second_page/widgets/avatar_widget.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/second_page/widgets/intro_image.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/second_page/widgets/titles_list.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';
import 'package:in_app_bot/playground/onboarding/presentation/widgets/language_selector_widget.dart';

class SecondPage extends StatelessWidget {
  final SecondPageParams params;

  const SecondPage({Key? key, required this.params}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildContentColumn(),
        _buildLanguageSelectorPositioned(),
      ],
    );
  }

  Widget _buildContentColumn() {
    return Column(
      children: [
        AvatarWidget(
          controller: params.controller2,
          progressAnimationController: params.progressAnimationController,
          progressAnimationController3: params.progressAnimationController3,
          mounted: params.mounted,
        ),
        AnimatedHandImageWidget(showImage2: params.showImage2),
        LottieAnimationWidget(
          index: params.ref.watch(AnimationState.lottieAnimationIndex),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: SingleChildScrollView(
            child: buildTitlesList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSelectorPositioned() {
    return Positioned(
      top: 10,
      right: 10,
      child: buildLanguageSelector(
        params.ref,
        params.progressAnimationController,
        params.progressAnimationController3,
        true,
        params.currentPage,
        params.context,
      ),
    );
  }
}
