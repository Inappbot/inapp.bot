import 'package:in_app_bot/in_app_bot/data/datasources/local/local_datasource.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/domain/entities/notification_entity.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/domain/repositories/notification_repository.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/infrastructure/datasources/remote/remote_notification_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final LocalDatasource _localDataSource;
  final RemoteNotificationDataSource _remoteDataSource;

  NotificationRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<List<NotificationEntity>> getNotifications() =>
      _localDataSource.getNotifications();

  @override
  Future<int> getUnreadNotificationsCount() =>
      _localDataSource.getUnreadNotificationsCount();

  @override
  Future<void> insertNotifications(List<NotificationEntity> notifications) =>
      _localDataSource.insertNotifications(notifications);

  @override
  Future<void> deleteNotifications(List<String> notificationIds) =>
      _localDataSource.deleteNotifications(notificationIds);

  @override
  Future<void> markNotificationAsViewed(String userId, String notificationId) =>
      _remoteDataSource.markNotificationAsViewed(userId, notificationId);

  Future<void> syncNotifications() async {
    final remoteNotifications = await _remoteDataSource.getNotifications();
    final localNotifications = await _localDataSource.getNotifications();

    final newNotifications = remoteNotifications.where((notification) {
      return !localNotifications.any((local) => local.id == notification.id);
    }).toList();

    final notificationsToDelete = localNotifications.where((local) {
      return !remoteNotifications.any((remote) => remote.id == local.id);
    }).toList();

    if (newNotifications.isNotEmpty) {
      await _localDataSource.insertNotifications(newNotifications);
    }

    if (notificationsToDelete.isNotEmpty) {
      await _localDataSource
          .deleteNotifications(notificationsToDelete.map((n) => n.id).toList());
    }
  }
}
