import 'package:flutter/material.dart';
import 'package:in_app_bot/playground/onboarding/infrastructure/services/haptic_feedback_service.dart';

class ZoomFadeRoute extends PageRouteBuilder {
  final Widget page;
  ZoomFadeRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            var begin = 0.0;
            var end = 1.0;
            var curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var opacityAnimation = animation.drive(tween);
            var scaleAnimation = animation.drive(
                Tween(begin: 0.5, end: 1.0).chain(CurveTween(curve: curve)));

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (animation.status == AnimationStatus.forward &&
                  animation.value < 0.1) {
                HapticFeedbackService.triggerFeedback();
              }
            });

            return FadeTransition(
              opacity: opacityAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
}
