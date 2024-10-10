import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/data/datasources/local/local_datasource.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/domain/entities/notification_entity.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/infrastructure/datasources/local/local_datasource_notification_imp.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/infrastructure/datasources/remote/remote_notification_datasource.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/infrastructure/repositories/notification_repository_impl.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/presentation/state/cached_notifications_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final databaseProvider = Provider<LocalDatasource>((ref) {
  return LocalDatasourceImp();
});

final notificationRepositoryProvider =
    Provider<NotificationRepositoryImpl>((ref) {
  final localDataSource = ref.read(databaseProvider);
  final remoteDataSource =
      RemoteNotificationDataSource(FirebaseFirestore.instance);
  return NotificationRepositoryImpl(localDataSource, remoteDataSource);
});

final unreadNotificationsCountProvider =
    StateNotifierProvider<UnreadNotificationsCountNotifier, int>((ref) {
  return UnreadNotificationsCountNotifier(ref);
});

class UnreadNotificationsCountNotifier extends StateNotifier<int> {
  final Ref _ref;

  UnreadNotificationsCountNotifier(this._ref) : super(0) {
    _loadUnreadCount();

    _ref.listen<AsyncValue<List<NotificationEntity>>>(
        cachedNotificationsProvider, (previous, next) {
      next.whenData((notifications) {
        _updateUnreadCount(notifications);
      });
    });
  }

  Future<void> _loadUnreadCount() async {
    final repository = _ref.read(notificationRepositoryProvider);
    final unreadCount = await repository.getUnreadNotificationsCount();

    state = unreadCount;
  }

  void _updateUnreadCount(List<NotificationEntity> notifications) {
    final unreadCount = notifications.where((notification) {
      final isRead = notification.isRead ?? false;
      return !isRead;
    }).length;
    state = unreadCount;
  }
}

final lastSyncProvider =
    StateNotifierProvider<LastSyncNotifier, DateTime?>((ref) {
  return LastSyncNotifier();
});

class LastSyncNotifier extends StateNotifier<DateTime?> {
  LastSyncNotifier() : super(null) {
    _loadLastSync();
  }

  Future<void> _loadLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncTimestamp = prefs.getInt('lastSync');
    if (lastSyncTimestamp != null) {
      state = DateTime.fromMillisecondsSinceEpoch(lastSyncTimestamp);
    } else {
      await updateLastSync(DateTime.now());
    }
  }

  Future<void> updateLastSync(DateTime newLastSync) async {
    state = newLastSync;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastSync', newLastSync.millisecondsSinceEpoch);
    log('LastSyncNotifier updated to: $newLastSync');
  }
}

final shouldSyncProvider = Provider<bool>((ref) {
  final lastSync = ref.watch(lastSyncProvider);
  if (lastSync == null) {
    return true;
  }
  final difference = DateTime.now().difference(lastSync);
  return difference > const Duration(minutes: 1);
});

final notificationSyncProvider = FutureProvider<void>((ref) async {
  final repository = ref.read(notificationRepositoryProvider);
  final shouldSync = ref.read(shouldSyncProvider);

  if (shouldSync) {
    log('Performing full synchronization...');
    await repository.syncNotifications();

    final updatedNotifications = await repository.getNotifications();
    ref
        .read(cachedNotificationsProvider.notifier)
        .updateNotifications(updatedNotifications);

    await ref.read(lastSyncProvider.notifier).updateLastSync(DateTime.now());
  }
});

final initSyncProvider = Provider<void>((ref) {
  ref.watch(notificationSyncProvider);
});

final selectedNotificationProvider =
    StateProvider<NotificationEntity?>((ref) => null);
