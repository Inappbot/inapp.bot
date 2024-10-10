import 'package:flutter/material.dart';
import 'package:in_app_bot/playground/onboarding/domain/entities/first_page_params.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/first_page/widgets/animated_text_widget.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/first_page/widgets/avatar_widget.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/first_page/widgets/image_widget.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/first_page/widgets/logo_widget.dart';
import 'package:in_app_bot/playground/onboarding/presentation/widgets/language_selector_widget.dart';

class FirstPage extends StatelessWidget {
  final FirstPageParams params;

  const FirstPage({Key? key, required this.params}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildLanguageSelector(),
        _buildLogoWidget(),
        if (params.currentPage == 0) _buildAnimatedTextWidget(),
        if (params.currentPage == 0) _buildImageWidget(),
        _buildAvatarWidget(),
      ],
    );
  }

  Widget _buildLanguageSelector() {
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

  Widget _buildLogoWidget() {
    return LogoWidget(showMessage: params.showMessage);
  }

  Widget _buildAnimatedTextWidget() {
    return AnimatedTextWidget(
      showMessage: params.showMessage,
      showImage: params.showImage,
    );
  }

  Widget _buildImageWidget() {
    return ImageWidget(showImage: params.showImage);
  }

  Widget _buildAvatarWidget() {
    return AvatarWidget(
      showImage: params.showImage,
      controller: params.controller,
      progressAnimationController: params.progressAnimationController,
      mounted: params.mounted,
    );
  }
}
