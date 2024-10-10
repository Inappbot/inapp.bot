import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/providers/second_page_translation_and_animation_providers.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationWidget extends ConsumerWidget {
  final int index;

  const LottieAnimationWidget({Key? key, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
// Watches the 'lottieAnimationUseCaseProvider' to obtain an instance of the use case.
// This enables access to the business logic related to Lottie animations.
    final lottieAnimationUseCase = ref.watch(lottieAnimationUseCaseProvider);

// Uses the use case instance to get the translated title corresponding to the current index.
// This call takes care of finding the appropriate title, which is then translated according to the current language settings.
    final translatedTitle = lottieAnimationUseCase.getTranslatedTitle(index);

// Similarly, uses the instance to get the file path of the Lottie animation corresponding to the current index.
// This allows the widget to load and display the specific animation designated for this index.
    final animationPath = lottieAnimationUseCase.getAnimationPath(index);

    if (animationPath.isEmpty) return Container();

    final double animationSize = MediaQuery.of(context).size.width * 0.35;
    final double fixedSize = MediaQuery.of(context).size.width * 0.40;
    final key = ValueKey<int>(index);

    return Align(
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 750),
        layoutBuilder: _animatedLayoutBuilder,
        switchInCurve: Curves.easeInOutCubic,
        switchOutCurve: Curves.easeInOutCubic,
        transitionBuilder: _animatedTransitionBuilder,
        child: Stack(
          key: key,
          children: [
            _buildFixedLottieWidget(fixedSize),
            _buildCurrentLottieWidget(
                translatedTitle, animationSize, animationPath),
            _buildFixedLottieWidget(fixedSize),
          ],
        ),
      ),
    );
  }

  Widget _animatedLayoutBuilder(
      Widget? currentChild, List<Widget> previousChildren) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        ...previousChildren,
        if (currentChild != null) currentChild,
      ],
    );
  }

  Widget _animatedTransitionBuilder(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation.drive(CurveTween(curve: Curves.easeInOutCubic)),
      child: ScaleTransition(
        scale: animation.drive(Tween(begin: 0.0, end: 1.0)),
        child: child,
      ),
    );
  }

  Widget _buildCurrentLottieWidget(String title, double size, String path) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'poppins',
            ),
          ),
          SizedBox(
            width: size,
            height: size,
            child: Lottie.asset(path, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedLottieWidget(double size) {
    return Positioned(
      top: 30,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: size,
          height: size,
          child: Lottie.asset(
              'lib/playground/onboarding/assets/animations/fixed.json',
              fit: BoxFit.contain),
        ),
      ),
    );
  }
}
