import 'package:in_app_bot/in_app_bot/features/notifications/domain/entities/notification_entity.dart';

abstract class LocalDatasource {
  Future<List<NotificationEntity>> getNotifications();
  Future<int> getUnreadNotificationsCount();
  Future<void> insertNotifications(List<NotificationEntity> notifications);
  Future<void> insertNotification(NotificationEntity notification);
  Future<void> deleteNotifications(List<String> notificationIds);
  Future<void> markAsRead(String id);
  Future<bool> isDatabaseEmpty();
}
