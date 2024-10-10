import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/domain/entities/third_page_params.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/third_page/widgets/animated/lottie_animation_widget.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/third_page/widgets/avatar_widget.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/third_page/widgets/form/state/third_page_form_ui_state.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/third_page/widgets/form_onboarding.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';

class ThirdPageContent extends StatelessWidget {
  final ThirdPageParams params;

  const ThirdPageContent({Key? key, required this.params}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uiState = getUIState(params.ref);
    final newFormOffset = uiState.isKeyboardVisible ? -90.0 : 0.0;
    final videoScale = uiState.isKeyboardVisible ? 0.6 : 1.0;
    final scale = uiState.isKeyboardVisible ? 0.8 : 1.0;
    final formVerticalOffset = uiState.isKeyboardVisible ? -30.0 : 0.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(0, newFormOffset, 0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildVideoScale(context, params, videoScale),
            _buildLottieAnimation(context, params.ref, scale),
            _buildForm(context, params.ref, uiState, formVerticalOffset,
                params.formKey),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoScale(
      BuildContext context, ThirdPageParams params, double scale) {
    return AnimatedScale(
      alignment: Alignment.bottomCenter,
      scale: scale,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Center(
        child: AvatarWidget(
          context: context,
          controller3: params.controller3,
          ref: params.ref,
          progressAnimationController: params.progressAnimationController,
          progressAnimationController3: params.progressAnimationController3,
          mounted: params.mounted,
        ),
      ),
    );
  }

  Widget _buildLottieAnimation(
      BuildContext context, WidgetRef ref, double scale) {
    return AnimatedScale(
      alignment: Alignment.topCenter,
      scale: scale,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Center(
        child: lottieAnimationWidget3(
          ref.watch(AnimationState.lottieAnimationIndex3),
          context,
          ref,
        ),
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    WidgetRef ref,
    FormUIStateValues uiState,
    double formVerticalOffset,
    GlobalKey<FormState> formKey,
  ) {
    return Transform.translate(
      offset: Offset(0, formVerticalOffset),
      child: AnimatedOpacity(
        opacity: uiState.showForm ? uiState.formOpacity : 0.0,
        duration: const Duration(milliseconds: 500),
        child:
            uiState.showForm ? buildForm(context, formKey, ref) : Container(),
      ),
    );
  }
}
