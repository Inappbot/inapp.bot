import 'package:flutter/material.dart';
import 'package:in_app_bot/playground/onboarding/onboarding.dart';

void navigateToOnboardingScreen(BuildContext context) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const OnboardingScreen(),
    ),
  );
}
