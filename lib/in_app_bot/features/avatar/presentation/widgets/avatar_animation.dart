import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/avatar/presentation/controllers/avatar_animation_controller.dart';
import 'package:in_app_bot/in_app_bot/features/avatar/presentation/state/avatar_animation_provider.dart';
import 'package:in_app_bot/in_app_bot/features/avatar/presentation/state/avatar_animation_state_notifier.dart';
import 'package:in_app_bot/in_app_bot/features/avatar/presentation/widgets/avatar_animation_ui.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/providers.dart';
import 'package:video_player/video_player.dart';

class AvatarAnimation extends ConsumerStatefulWidget {
  final bool isTalking;
  final bool shouldShrink;

  const AvatarAnimation({
    Key? key,
    required this.isTalking,
    required this.shouldShrink,
  }) : super(key: key);

  @override
  ConsumerState<AvatarAnimation> createState() => _AvatarAnimationState();
}

class _AvatarAnimationState extends ConsumerState<AvatarAnimation>
    with AutomaticKeepAliveClientMixin<AvatarAnimation> {
  late AvatarAnimationNotifier avatarAnimationNotifier;

  @override
  void initState() {
    super.initState();
    avatarAnimationNotifier = ref.read(avatarAnimationProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      avatarAnimationNotifier.playVideos();
    });
  }

  @override
  void dispose() {
    avatarAnimationNotifier.pauseVideos();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AvatarAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isTalking != widget.isTalking ||
        oldWidget.shouldShrink != widget.shouldShrink) {
      Future.microtask(() {
        if (mounted) {
          avatarAnimationNotifier.updateState(
            isTalking: widget.isTalking,
            shouldShrink: widget.shouldShrink,
          );
        }
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final avatarState = ref.watch(avatarAnimationProvider);

    if (!avatarState.isVideoInitialized && !avatarState.isLoadingAvatar) {
      Future.microtask(() => avatarAnimationNotifier.initializeVideos());
    }

    final chatUI = ref.watch(chatUIState);
    bool isTtsMuted = chatUI.isTtsMuted;
    bool isTalking = chatUI.isTtsPlaying;

    VideoPlayerController? currentController = (isTalking && !isTtsMuted)
        ? avatarState.controllerTalking
        : avatarState.controllerIdle;

    double screenHeight = MediaQuery.of(context).size.height;
    double avatarSize = AvatarAnimationController.calculateAvatarSize(
        screenHeight, avatarState.shouldShrink);

    if (!avatarState.isLoadingAvatar && avatarState.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AvatarAnimationController.showErrorDialog(
            context, avatarState.errorMessage!);
      });
    }

    return Stack(
      children: [
        AvatarAnimationUI.buildAnimatedContainer(
            avatarSize, context, currentController, ref, isTtsMuted),
        AvatarAnimationUI.buildMuteIconOverlay(ref, isTtsMuted, avatarSize),
      ],
    );
  }
}
