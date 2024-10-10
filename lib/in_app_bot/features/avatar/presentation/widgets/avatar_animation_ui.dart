import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/core/themes/default_theme.dart';
import 'package:in_app_bot/in_app_bot/features/avatar/presentation/state/avatar_animation_provider.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/providers.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

class AvatarAnimationUI {
  static Widget buildAnimatedContainer(
      double avatarSize,
      BuildContext context,
      VideoPlayerController? currentController,
      WidgetRef ref,
      bool isTtsMuted) {
    return AnimatedContainer(
      key: const ValueKey('container'),
      duration: const Duration(milliseconds: 500),
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: Theme.of(context).customTheme.customGradient,
        boxShadow: List<BoxShadow>.generate(
          3,
          (index) => BoxShadow(
            color: const Color.fromARGB(255, 211, 211, 211).withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child:
            buildCircleAvatar(avatarSize, currentController, ref, isTtsMuted),
      ),
    );
  }

  static Widget buildCircleAvatar(
      double avatarSize,
      VideoPlayerController? currentController,
      WidgetRef ref,
      bool isTtsMuted) {
    return CircleAvatar(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      radius: 60,
      child:
          buildVideoPlayerChild(avatarSize, currentController, ref, isTtsMuted),
    );
  }

  static Widget buildVideoPlayerChild(
      double avatarSize,
      VideoPlayerController? currentController,
      WidgetRef ref,
      bool isTtsMuted) {
    final avatarState = ref.watch(avatarAnimationProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: avatarSize,
      height: avatarSize,
      child: CircleAvatar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        radius: ref.watch(chatUIState).shouldShrinkAppBar
            ? (avatarSize - 4) / 2
            : (avatarSize - 9) / 2,
        child: ClipOval(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: avatarState.showImage
                ? Opacity(
                    opacity: 0.2,
                    child: Image.asset(
                      'assets/images/avatar_eneia.PNG',
                      fit: BoxFit.cover,
                      key: const ValueKey('avatar_image'),
                    ),
                  )
                : currentController != null &&
                        currentController.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: currentController.value.aspectRatio,
                        key: const ValueKey('video_player'),
                        child: VideoPlayer(currentController),
                      )
                    : avatarState.isAvatarLoadingDownloaded &&
                            avatarState.avatarLoadingPath != null
                        ? Image.file(
                            File(avatarState.avatarLoadingPath!),
                            fit: BoxFit.cover,
                            key: const ValueKey('loading_image'),
                          )
                        : Container(),
          ),
        ),
      ),
    );
  }

  static Widget buildMuteIconOverlay(
      WidgetRef ref, bool isMuted, double avatarSize) {
    final chatUI = ref.watch(chatUIState);
    bool showMuteIcon = isMuted && chatUI.showMuteIcon;
    bool showVolumeIcon = !isMuted && chatUI.showUnMuteIcon;

    double iconSize = avatarSize * 5;

    return Positioned(
      top: 0,
      right: 0,
      child: SizedBox(
        width: avatarSize,
        height: avatarSize,
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: showMuteIcon
                  ? buildLottieIcon(
                      'assets/animations/mute.json',
                      iconSize,
                      avatarSize,
                      key: const ValueKey('mute_icon'),
                    )
                  : showVolumeIcon
                      ? buildLottieIcon(
                          'assets/animations/mute_unmute.json',
                          iconSize,
                          avatarSize,
                          key: const ValueKey('volume_icon'),
                        )
                      : Container(),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildLottieIcon(
      String assetPath, double size, double avatarSize,
      {required Key key}) {
    return Center(
      child: Container(
        key: key,
        width: avatarSize,
        height: avatarSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(125, 255, 255, 255),
        ),
        child: Center(
          child: Lottie.asset(
            assetPath,
            width: size * 0.5,
            height: size * 0.5,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
