import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_bot/in_app_bot/features/avatar/data/db/avatar_db.dart';
import 'package:in_app_bot/in_app_bot/features/avatar/data/services/video_downloader.dart';
import 'package:in_app_bot/in_app_bot/features/avatar/domain/usecases/get_selected_avatar_usecase.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import 'avatar_animation_state.dart';

class AvatarAnimationNotifier extends StateNotifier<AvatarAnimationState> {
  final GetSelectedAvatarUseCase getSelectedAvatarUseCase;
  AvatarAnimationNotifier({
    required this.getSelectedAvatarUseCase,
  }) : super(AvatarAnimationState());

  bool _isInitializing = false;

  Future<void> initializeVideos() async {
    if (state.isVideoInitialized || _isInitializing) return;

    _isInitializing = true;

    try {
      String avatarId = await getSelectedAvatarId();
      String? storedAvatarId = await _getStoredAvatarId();

      if (storedAvatarId == null || storedAvatarId != avatarId) {
        await _deleteStoredAvatar(storedAvatarId);
        await _downloadAndCacheAvatarVideos(avatarId);
        await _storeAvatarId(avatarId);
      } else {
        await _loadCachedVideos(avatarId);
      }

      await state.controllerIdle?.initialize();
      await state.controllerTalking?.initialize();

      state = state.copyWith(
        isAvatarLoadingDownloaded: true,
        isVideoInitialized: true,
      );

      Future.delayed(const Duration(milliseconds: 200), () {
        state = state.copyWith(showImage: false);
      });

      state.controllerIdle?.play();
      state.controllerTalking?.play();
    } catch (e) {
      log('Error initializing videos: $e');

      state = state.copyWith(
        isAvatarLoadingDownloaded: false,
        isVideoInitialized: false,
      );
    } finally {
      _isInitializing = false;
    }
  }

  void pauseVideos() {
    state.controllerIdle?.pause();
    state.controllerTalking?.pause();
  }

  void playVideos() {
    state.controllerIdle?.play();
    state.controllerTalking?.play();
  }

  @override
  void dispose() {
    state.controllerIdle?.dispose();
    state.controllerTalking?.dispose();

    super.dispose();
  }

  void resetState() {
    state = AvatarAnimationState(
      controllerIdle: state.controllerIdle,
      controllerTalking: state.controllerTalking,
      isAvatarLoadingDownloaded: state.isAvatarLoadingDownloaded,
      isVideoInitialized: state.isVideoInitialized,
    );
  }

  Future<void> _deleteStoredAvatar(String? avatarId) async {
    if (avatarId == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final avatarDirectory =
        Directory('${directory.path}/assets/avatars/$avatarId');

    if (await avatarDirectory.exists()) {
      await avatarDirectory.delete(recursive: true);
      log('Avatar directory $avatarId has been deleted.');
    } else {
      log('Avatar directory $avatarId does not exist.');
    }
  }

  Future<void> _downloadAndCacheAvatarVideos(String avatarId) async {
    state = state.copyWith(isLoadingAvatar: true);
    try {
      Map<String, String> videoUrls = await getAvatarVideoUrls(avatarId);

      String idlePath = await downloadAndCacheVideo(
          videoUrls['idle']!, 'video_chat.mp4', avatarId);
      String talkingPath = await downloadAndCacheVideo(
          videoUrls['talking']!, 'video_talking.mp4', avatarId);

      state = state.copyWith(
        controllerIdle: await _setupVideoPlayerController(idlePath),
        controllerTalking: await _setupVideoPlayerController(talkingPath),
        isLoadingAvatar: false,
        errorMessage: null,
      );
    } catch (e) {
      log('Error downloading and caching avatar videos: $e');
      state = state.copyWith(
        isAvatarLoadingDownloaded: false,
        isLoadingAvatar: false,
        errorMessage: 'Failed to download and cache avatar videos',
      );
    }
  }

  Future<void> _loadCachedVideos(String avatarId) async {
    state = state.copyWith(isLoadingAvatar: true);
    try {
      final directory = await getApplicationDocumentsDirectory();
      String idlePath =
          '${directory.path}/assets/avatars/$avatarId/video_chat.mp4';
      String talkingPath =
          '${directory.path}/assets/avatars/$avatarId/video_talking.mp4';

      state = state.copyWith(
        controllerIdle: await _setupVideoPlayerController(idlePath),
        controllerTalking: await _setupVideoPlayerController(talkingPath),
        isLoadingAvatar: false,
        errorMessage: null,
      );
    } catch (e) {
      log('Error loading cached videos: $e');
      state = state.copyWith(
        isAvatarLoadingDownloaded: false,
        isLoadingAvatar: false,
        errorMessage: 'Failed to load cached videos',
      );
    }
  }

  Future<void> _storeAvatarId(String avatarId) async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/selected_avatar.txt');

    await file.writeAsString(avatarId);
  }

  Future<String?> _getStoredAvatarId() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/selected_avatar.txt');
      final fileExist = await file.exists();
      if (fileExist) {
        return await file.readAsString();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<VideoPlayerController> _setupVideoPlayerController(String path) async {
    VideoPlayerController controller = VideoPlayerController.file(
      File(path),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    await controller.setLooping(true);

    return controller;
  }

  Future<String?> downloadAndCacheImage(
      String url, String fileName, String avatarId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final avatarDirectory =
          Directory('${directory.path}/assets/avatars/$avatarId');

      if (!await avatarDirectory.exists()) {
        await avatarDirectory.create(recursive: true);
      }

      final file = File('${avatarDirectory.path}/$fileName');

      if (await file.exists()) {
        return file.path;
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return file.path;
      } else {
        throw Exception('Failed to download image');
      }
    } catch (e) {
      log('Error downloading and caching image: $e');

      return null;
    }
  }

  void updateState({required bool isTalking, required bool shouldShrink}) {
    state = state.copyWith(isTalking: isTalking, shouldShrink: shouldShrink);
  }
}
