import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/auth/presentation/providers/user_provider.dart';
import 'package:in_app_bot/playground/auth/domain/entities/status.dart';
import 'package:in_app_bot/playground/auth/presentation/providers/auth_provider.dart';
import 'package:in_app_bot/playground/auth/presentation/providers/auth_state.dart';
import 'package:in_app_bot/playground/auth/presentation/screen/widgets/custom_user_avatar.dart';
import 'package:video_player/video_player.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
                height: 250,
                width: size.width,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    SizedBox(
                      height: 210,
                      width: size.width,
                      child: const _BackroundVideo(),
                    ),
                    Positioned(
                      top: 42.0,
                      left: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 16.0, bottom: 16.0, right: 16.0),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: colorScheme.surface,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      child: CustomUserAvatar(
                        photoURL: auth.user!.photoURL,
                        maxRadius: 50,
                        backgroundColor: colorScheme.onSurface,
                      ),
                    ),
                  ],
                )),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16.0),
                  Text(
                    auth.user?.displayName ?? 'user',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 32.0,
                    ),
                    textAlign: TextAlign.center,
                    semanticsLabel: 'user name',
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    auth.user?.email ?? 'Not available',
                    style: textTheme.titleMedium,
                    textAlign: TextAlign.center,
                    semanticsLabel: 'User email',
                  ),
                  const SizedBox(height: 16.0),
                  const _LogOutBtn()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _BackroundVideo extends StatefulWidget {
  const _BackroundVideo();

  @override
  State<_BackroundVideo> createState() => __BackroundVideoState();
}

class __BackroundVideoState extends State<_BackroundVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initVideo() async {
    try {
      _controller = VideoPlayerController.asset(
        'assets/videos/background.mp4',
      );
      await _controller.initialize();
      if (kIsWeb) {
        await _controller.setVolume(0.0);
      }
      await _controller.play();
      await _controller.setLooping(true);
    } catch (e) {
      log("_initVideo: $e");
    } finally {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
            fit: StackFit.expand,
            children: [
              AspectRatio(aspectRatio: 16 / 9, child: VideoPlayer(_controller)),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(1),
                    ],
                  ),
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}

class _LogOutBtn extends ConsumerWidget {
  const _LogOutBtn();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authProvider, (p, n) {
      if (n.status != AuthStatus.authenticated) {
        Navigator.pop(context);
      }
    });
    return ElevatedButton(
      onPressed: () async {
        Future.wait([
          ref.read(userProvider.notifier).clearUserId(),
          ref.read(authProvider.notifier).logOut()
        ]);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4c44e1),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: const Text(
        "Log out",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
