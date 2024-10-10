import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/providers/third_page_animation_providers.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/third_page/widgets/animated/animation_widgets.dart';

Widget lottieAnimationWidget3(int index, BuildContext context, WidgetRef ref) {
  final viewModel = ref.read(animationViewModelProvider);
  final titles = viewModel.getUpdatedTitles(ref);
  final animationPath = viewModel.getAnimationPath(index);
  final title = titles[index] ?? '';
  if (animationPath.isEmpty) return Container();
  final animationSize = MediaQuery.of(context).size.width * 0.20;
  final fixedSize = MediaQuery.of(context).size.width * 0.25;
  final key = ValueKey<int>(index);

  return Align(
    alignment: Alignment.center,
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 750),
      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      switchInCurve: Curves.easeInOutCubic,
      switchOutCurve: Curves.easeInOutCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation.drive(CurveTween(curve: Curves.easeInOutCubic)),
          child: ScaleTransition(
            scale: animation.drive(Tween(begin: 0.0, end: 1.0)),
            child: child,
          ),
        );
      },
      child: Stack(
        key: key,
        children: [
          fixedLottieWidget(fixedSize),
          currentLottieWidget(animationPath, animationSize, title),
          fixedLottieWidget(fixedSize),
        ],
      ),
    ),
  );
}
