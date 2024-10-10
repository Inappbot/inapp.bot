import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/localization/languages/first_page/welcome_languages.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';

class AnimatedTextWidget extends ConsumerWidget {
  final bool showMessage;
  final bool showImage;

  const AnimatedTextWidget({
    Key? key,
    required this.showMessage,
    required this.showImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double topPosition = MediaQuery.of(context).size.height * 0.15;
    final languageCode = ref.watch(AppConfig.language);
    final welcomeMessage = welcomeMessages[languageCode] ?? 'Welcome to ';

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      top: topPosition,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: showMessage ? 1.0 : 0.0,
        duration: const Duration(seconds: 1),
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                  fontSize: 24,
                  color: Color.fromARGB(255, 47, 47, 47),
                  fontFamily: 'Poppins'),
              children: <TextSpan>[
                TextSpan(
                    text: welcomeMessage,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const TextSpan(
                  text: 'inapp.bot',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2EA0D1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
