import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/domain/entities/notification_entity.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/domain/entities/notification_item_state.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/presentation/widgets/notification_list_item.dart';

final notificationItemProvider = StateNotifierProvider.family<
    NotificationItemNotifier, NotificationItemState, NotificationEntity>(
  (ref, notification) => NotificationItemNotifier(notification),
);
