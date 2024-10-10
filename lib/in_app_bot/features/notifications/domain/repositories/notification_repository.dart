import 'package:in_app_bot/in_app_bot/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications();
  Future<int> getUnreadNotificationsCount();
  Future<void> insertNotifications(List<NotificationEntity> notifications);
  Future<void> deleteNotifications(List<String> notificationIds);
  Future<void> markNotificationAsViewed(String userId, String notificationId);
}
