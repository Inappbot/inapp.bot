import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/avatar/presentation/widgets/avatar_animation.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/providers.dart';

class VideoAvatar extends ConsumerWidget {
  const VideoAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isTalking = ref.watch(chatUIState).isTtsPlaying;
    final bool shouldShrink = ref.watch(chatUIState).shouldShrinkAppBar;

    return AvatarAnimation(
      isTalking: isTalking,
      shouldShrink: shouldShrink,
    );
  }
}
