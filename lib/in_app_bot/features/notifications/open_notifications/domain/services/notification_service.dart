import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/domain/entities/notification_entity.dart';
import 'package:share_plus/share_plus.dart';

final notificationServiceProvider =
    Provider<NotificationService>((ref) => NotificationService());

class NotificationService {
  void shareNotification(NotificationEntity notification) {
    if (notification.type == 'image' || notification.type == 'video') {
      Share.share(notification.url);
    } else {
      Share.share(notification.description);
    }
  }
}
