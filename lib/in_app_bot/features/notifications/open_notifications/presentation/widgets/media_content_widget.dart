import 'package:flutter/material.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/domain/entities/notification_entity.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/open_notifications/presentation/widgets/image_widget.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/open_notifications/presentation/widgets/video_player_widget.dart';

class MediaContentWidget extends StatelessWidget {
  final NotificationEntity notification;

  const MediaContentWidget({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (notification.type == 'image') {
      return ImageWidget(url: notification.url);
    } else if (notification.type == 'video') {
      return VideoPlayerWidget(url: notification.url);
    }
    return const SizedBox.shrink();
  }
}
