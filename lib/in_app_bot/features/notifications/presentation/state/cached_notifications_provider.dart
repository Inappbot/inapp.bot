import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/data/datasources/local/local_datasource.dart';
import 'package:in_app_bot/in_app_bot/features/auth/presentation/providers/user_provider.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/domain/entities/notification_entity.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/presentation/state/notification_context_provider.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/presentation/state/notification_providers.dart';

final cachedNotificationsProvider = StateNotifierProvider<
    CachedNotificationsNotifier, AsyncValue<List<NotificationEntity>>>((ref) {
  return CachedNotificationsNotifier(ref);
});

class CachedNotificationsNotifier
    extends StateNotifier<AsyncValue<List<NotificationEntity>>> {
  final Ref _ref;

  CachedNotificationsNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final dbHelper = _ref.read(databaseProvider);
      final userState = _ref.read(userProvider);
      final userId = userState.user!.id;

      final isEmpty = await dbHelper.isDatabaseEmpty();
      if (isEmpty) {
        log('Local database is empty. Fetching data from Firestore...');
        await _fetchAndStoreFirestoreData();
      }

      final readNotifications = await _fetchReadNotifications(userId);
      await _updateLocalReadStatus(dbHelper, readNotifications);

      final notifications = await dbHelper.getNotifications();
      state = AsyncValue.data(notifications);

      _ref
          .read(notificationContextProvider.notifier)
          .updateContextFromNotifications(notifications);

      await _ref.read(notificationSyncProvider.future);
    } catch (e) {
      log('Error loading initial data: $e');
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<Map<String, dynamic>> _fetchReadNotifications(String userId) async {
    final firestore = FirebaseFirestore.instance;
    final docSnapshot = await firestore
        .collection('chatbots')
        .doc('alert')
        .collection('viewed_notifications')
        .doc(userId)
        .get();

    if (docSnapshot.exists) {
      return docSnapshot.data()?['readNotifications'] ?? {};
    }
    return {};
  }

  Future<void> _updateLocalReadStatus(
      LocalDatasource dbHelper, Map<String, dynamic> readNotifications) async {
    final notifications = await dbHelper.getNotifications();
    for (var notification in notifications) {
      if (readNotifications.containsKey(notification.id)) {
        await dbHelper.markAsRead(notification.id);
      }
    }
  }

  void updateNotifications(List<NotificationEntity> updatedNotifications) {
    state = AsyncValue.data(updatedNotifications);
    _ref
        .read(notificationContextProvider.notifier)
        .updateContextFromNotifications(updatedNotifications);
  }

  Future<void> _fetchAndStoreFirestoreData() async {
    final firestore = FirebaseFirestore.instance;
    final dbHelper = _ref.read(databaseProvider);

    try {
      final notifications = await firestore
          .collection('chatbots')
          .doc('alert')
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();

      final notificationList = notifications.docs.map((doc) {
        final data = doc.data();
        return NotificationEntity(
          id: doc.id,
          type: data['type'],
          url: data['url'],
          title: data['title'],
          description: data['description'],
          timestamp: (data['timestamp'] as Timestamp).millisecondsSinceEpoch,
          linkToGo: data['link_to_go'],
          textButton: data['text_button'],
          context: data['context'],
        );
      }).toList();

      await dbHelper.insertNotifications(notificationList);
      log('Firestore data fetched and stored in local database.');
    } catch (e) {
      log('Error fetching and storing Firestore data: $e');
      rethrow;
    }
  }

  Future<void> refresh() async {
    final shouldSync = _ref.read(shouldSyncProvider);
    log('Refreshing notifications, should sync: $shouldSync');
    if (shouldSync) {
      try {
        await _ref.read(notificationSyncProvider.future);
        final dbHelper = _ref.read(databaseProvider);
        final notifications = await dbHelper.getNotifications();
        state = AsyncValue.data(notifications);
        _ref
            .read(notificationContextProvider.notifier)
            .updateContextFromNotifications(notifications);
      } catch (e) {
        state = AsyncValue.error(e, StackTrace.current);
      }
    }
  }
}
