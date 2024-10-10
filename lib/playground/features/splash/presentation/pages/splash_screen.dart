import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/onboarding.dart';
import 'package:in_app_bot/playground/presentation/screens/play_details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: 'logo-tags',
              child: Image.asset(
                'lib/playground/onboarding/assets/images/inappbot_logo_new.webp',
                width: 110.0,
                height: 110.0,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingViewed = prefs.getBool('onboardingViewed') ?? false;

    final page =
        onboardingViewed ? const PlayDetailsPage() : const OnboardingScreen();

    await prefs.setBool('onboardingViewed', true);

    log('onboardingViewed:$page');

    Timer(const Duration(seconds: 1), () {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation.drive(Tween(begin: 0.0, end: 1.0)),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
        (route) => false,
      );
    });
  }
}
