import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_bot/in_app_bot/features/auth/presentation/providers/user_provider.dart';
import 'package:in_app_bot/playground/auth/presentation/providers/auth_provider.dart';
import 'package:in_app_bot/playground/auth/presentation/providers/auth_state.dart';
import 'package:in_app_bot/playground/auth/presentation/screen/widgets/social_login_btn.dart';
import 'package:in_app_bot/playground/presentation/screens/play_details_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class SocialAuthenticationScreen extends ConsumerStatefulWidget {
  const SocialAuthenticationScreen({Key? key}) : super(key: key);

  @override
  SocialAuthenticationScreenState createState() =>
      SocialAuthenticationScreenState();
}

class SocialAuthenticationScreenState
    extends ConsumerState<SocialAuthenticationScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/videos/background.mp4',
    )..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    ref.listen<AuthState>(
      authProvider,
      (previous, next) {
        if (next.isFailure) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.white),
                    SizedBox(width: 8.0),
                    Text('Login Error'),
                  ],
                ),
                content: const Text(
                    'Something went wrong. Please check your credentials and try again.'),
                backgroundColor: theme.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              );
            },
          );
        }
        if (next.isSuccess) {
          ref.read(userProvider.notifier).setUserId(next.user!.email).then(
            (value) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlayDetailsPage(),
                ),
              );
            },
          );
        }
      },
    );

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _controller.value.isInitialized
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                )
              : Container(color: Colors.black.withOpacity(0.8)),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.9),
                  Colors.black.withOpacity(1),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Image.asset(
                      "lib/playground/onboarding/assets/images/inappbot_logo_new.webp",
                      height: 80,
                      width: 80,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'inapp.bot',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Supercharge your apps with AI: Sign up',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.1),
                  SocialButton(
                    icon: FontAwesomeIcons.github,
                    label: 'Continue with GitHub',
                    color: Colors.black87,
                    onPressed: () =>
                        ref.read(authProvider.notifier).signInWithGithub(),
                  ),
                  const SizedBox(height: 16),
                  SocialButton(
                    icon: FontAwesomeIcons.google,
                    label: 'Continue with Google',
                    color: Colors.red,
                    onPressed: () =>
                        ref.read(authProvider.notifier).signInWithGoogle(),
                  ),
                  const SizedBox(height: 16),
                  SocialButton(
                    icon: FontAwesomeIcons.apple,
                    label: 'Continue with Apple',
                    color: Colors.black,
                    onPressed: () =>
                        ref.read(authProvider.notifier).signInApple(),
                  ),
                  const Spacer(),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'By joining, you agree to the ',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white70),
                      children: [
                        TextSpan(
                          text: 'Terms of Service',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final Uri url = Uri.parse(
                                  'https://inapp.bot/terms_of_service/');
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                        ),
                        const TextSpan(text: ' of InAppBot'),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
