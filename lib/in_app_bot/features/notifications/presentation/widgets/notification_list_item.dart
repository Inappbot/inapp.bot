import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/application/services/chat_operations.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/application/services/notification_service.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/domain/entities/notification_entity.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/domain/entities/notification_item_state.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/presentation/state/notification_item_provider.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/presentation/state/notification_providers.dart';
import 'package:in_app_bot/in_app_bot/presentation/utils/chat_helpers.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class NotificationItemNotifier extends StateNotifier<NotificationItemState> {
  NotificationItemNotifier(this.notification)
      : super(NotificationItemState(isRead: notification.isRead ?? false)) {
    if (notification.type == 'video') {
      _initializeVideoController(notification.url);
    } else if (notification.type == 'image') {
      _preloadImage(notification.url);
    }
  }

  final NotificationEntity notification;
  VideoPlayerController? _videoController;

  Future<void> _initializeVideoController(String url) async {
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(url),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    await _videoController!.initialize();
    state = state.copyWith(isInitialized: true, isLoaded: true);
  }

  Future<void> _preloadImage(String url) async {
    final ImageProvider imageProvider = CachedNetworkImageProvider(url);
    final ImageStream stream = imageProvider.resolve(ImageConfiguration.empty);
    final Completer<void> completer = Completer<void>();

    late ImageStreamListener listener;
    listener = ImageStreamListener(
      (ImageInfo image, bool synchronousCall) {
        if (!completer.isCompleted) {
          completer.complete();
          state = state.copyWith(isLoaded: true);
        }
        stream.removeListener(listener);
      },
      onError: (dynamic exception, StackTrace? stackTrace) {
        if (!completer.isCompleted) {
          completer.completeError(exception, stackTrace);
        }
        stream.removeListener(listener);
      },
    );

    stream.addListener(listener);
    try {
      await completer.future;
    } catch (e) {
      log('Error preloading image: $e');
    }
  }

  void togglePlayPause() {
    if (_videoController != null) {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
        state = state.copyWith(isPlaying: false);
      } else {
        _videoController!.play();
        state = state.copyWith(isPlaying: true);
      }
    }
  }

  void markAsRead() {
    state = state.copyWith(isRead: true);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
}

class NotificationListItem extends ConsumerWidget {
  final NotificationEntity notification;
  final String appUserId;

  const NotificationListItem({
    Key? key,
    required this.notification,
    required this.appUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationItemState =
        ref.watch(notificationItemProvider(notification));
    final notificationItemNotifier =
        ref.watch(notificationItemProvider(notification).notifier);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () async {
          _handleNotificationTap(context, ref);
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMediaChip(
                      notificationItemState, notificationItemNotifier),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Color(0xFF333333),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                            fontFamily: 'Poppins',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatTimestamp(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      notification.timestamp)),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Icon(Icons.fullscreen,
                                size: 20, color: Colors.grey[600]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!notificationItemState.isRead)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2196F3),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaChip(
      NotificationItemState state, NotificationItemNotifier notifier) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color.fromARGB(255, 247, 247, 247),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (!state.isLoaded) _buildPlaceholder(),
                notification.type == 'video'
                    ? _buildVideoThumbnail(state, notifier)
                    : _buildImage(state),
                if (notification.type == 'video' && state.isInitialized)
                  Positioned.fill(
                    child: Center(
                      child: IconButton(
                        icon: Icon(
                          state.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: notifier.togglePlayPause,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -7,
          right: -7,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: notification.type == 'video' ? Colors.blue : Colors.green,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              notification.type == 'video' ? Icons.videocam : Icons.image,
              color: Colors.white,
              size: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.withOpacity(0.3),
    );
  }

  Widget _buildVideoThumbnail(
      NotificationItemState state, NotificationItemNotifier notifier) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (state.isInitialized && notifier._videoController != null)
          VideoPlayer(notifier._videoController!),
      ],
    );
  }

  Widget _buildImage(NotificationItemState state) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (!state.isLoaded) _buildPlaceholder(),
        CachedNetworkImage(
          imageUrl: notification.url,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return DateFormat('MMM d, y').format(timestamp);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _handleNotificationTap(BuildContext context, WidgetRef ref) {
    clearChatAndMessageParts(ref);
    ChatOperationService.clearChatList();
    ref.read(selectedNotificationProvider.notifier).state = notification;

    Navigator.of(context).pop();

    ref.read(notificationServiceProvider).handleNotification(notification);
  }
}
