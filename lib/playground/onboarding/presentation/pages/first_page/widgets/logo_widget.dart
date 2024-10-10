import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final bool showMessage;

  const LogoWidget({Key? key, required this.showMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: AnimatedOpacity(
          opacity: showMessage ? 1.0 : 0.0,
          duration: const Duration(seconds: 1),
          child: Image.asset(
            'lib/playground/onboarding/assets/images/inappbot_logo_new.webp',
            width: 80.0,
            height: 80.0,
          ),
        ),
      ),
    );
  }
}
