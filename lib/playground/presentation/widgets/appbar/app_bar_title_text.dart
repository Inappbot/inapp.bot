import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String appName = 'InApp.Bot';
const String animatedString = 'PLAYGROUND';
const String fontFamily = 'Poppins';

class AppBarTitleText extends StatefulWidget {
  const AppBarTitleText({Key? key}) : super(key: key);

  @override
  AppBarTitleTextState createState() => AppBarTitleTextState();
}

class AppBarTitleTextState extends State<AppBarTitleText>
    with TickerProviderStateMixin {
  late AnimationController _textController;
  late AnimationController _logoController;
  late Animation<double> _textAnimation;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _textAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    _logoAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    _textController.forward();
    await Future.delayed(const Duration(seconds: 1));
    HapticFeedback.mediumImpact();
    _logoController.forward();
    HapticFeedback.heavyImpact();
  }

  @override
  void dispose() {
    _textController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: 0.1,
            child: Center(
              child: AnimatedBuilder(
                animation: _textAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textAnimation.value,
                    child: child,
                  );
                },
                child: const Text(
                  animatedString,
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 135, 135, 135),
                    fontFamily: fontFamily,
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: AnimatedBuilder(
            animation: _logoAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _logoAnimation.value,
                child: child,
              );
            },
            child: Hero(
              tag: 'logo-tag',
              child: Image.asset(
                'lib/playground/onboarding/assets/images/inappbot_logo_new.webp',
                height: 70,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
