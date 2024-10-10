import 'package:video_player/video_player.dart';

class AvatarAnimationState {
  final VideoPlayerController? controllerIdle;
  final VideoPlayerController? controllerTalking;
  final bool isAvatarLoadingDownloaded;
  final bool isVideoInitialized;
  final bool isTalking;
  final bool shouldShrink;
  final bool showImage;
  final String? avatarLoadingPath;
  final String? errorMessage;
  final bool isLoadingAvatar;

  AvatarAnimationState({
    this.controllerIdle,
    this.controllerTalking,
    this.isAvatarLoadingDownloaded = false,
    this.isVideoInitialized = false,
    this.isTalking = false,
    this.shouldShrink = false,
    this.showImage = true,
    this.avatarLoadingPath,
    this.errorMessage,
    this.isLoadingAvatar = false,
  });

  AvatarAnimationState copyWith({
    VideoPlayerController? controllerIdle,
    VideoPlayerController? controllerTalking,
    bool? isAvatarLoadingDownloaded,
    bool? isVideoInitialized,
    bool? isTalking,
    bool? shouldShrink,
    bool? showImage,
    String? avatarLoadingPath,
    String? errorMessage,
    bool? isLoadingAvatar,
  }) {
    return AvatarAnimationState(
      controllerIdle: controllerIdle ?? this.controllerIdle,
      controllerTalking: controllerTalking ?? this.controllerTalking,
      isAvatarLoadingDownloaded:
          isAvatarLoadingDownloaded ?? this.isAvatarLoadingDownloaded,
      isVideoInitialized: isVideoInitialized ?? this.isVideoInitialized,
      isTalking: isTalking ?? this.isTalking,
      shouldShrink: shouldShrink ?? this.shouldShrink,
      showImage: showImage ?? this.showImage,
      avatarLoadingPath: avatarLoadingPath ?? this.avatarLoadingPath,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoadingAvatar: isLoadingAvatar ?? this.isLoadingAvatar,
    );
  }
}
