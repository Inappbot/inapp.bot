import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/domain/entities/notification_entity.dart';

final notificationContextProvider =
    StateNotifierProvider<NotificationContextNotifier, Map<String, String>>(
        (ref) {
  return NotificationContextNotifier();
});

class NotificationContextNotifier extends StateNotifier<Map<String, String>> {
  NotificationContextNotifier() : super({});

  void setContext(String notificationId, String context) {
    state = {...state, notificationId: context};
  }

  String? getContext(String notificationId) {
    return state[notificationId];
  }

  void removeContext(String notificationId) {
    state = {...state}..remove(notificationId);
  }

  void updateContextFromNotifications(List<NotificationEntity> notifications) {
    final newState = <String, String>{};
    for (var notification in notifications) {
      if (notification.context != null && notification.context!.isNotEmpty) {
        newState[notification.id] = notification.context!;
      }
    }
    state = newState;
  }
}
