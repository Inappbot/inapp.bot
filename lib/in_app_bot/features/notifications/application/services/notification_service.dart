import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/auth/presentation/providers/user_provider.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/domain/entities/notification_entity.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/presentation/state/notification_context_provider.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/presentation/state/notification_item_provider.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/presentation/state/notification_providers.dart';
import 'package:in_app_bot/in_app_bot/features/qr_assistant_scanner/presentation/providers/qr_ai_providers.dart';
import 'package:in_app_bot/in_app_bot/features/text_to_speech/presentation/providers/tts_provider.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/providers.dart';

class NotificationService {
  final ProviderRef ref;

  NotificationService(this.ref);

  Future<void> handleNotification(NotificationEntity notification) async {
    ref.read(productDataProvider.notifier).state = null;
    await _readNotificationDescription(notification);
    await _markAsRead(notification);
    await ref.read(databaseProvider).markAsRead(notification.id);
    ref.read(notificationItemProvider(notification).notifier).markAsRead();

    if (notification.context != null && notification.context!.isNotEmpty) {
      ref
          .read(notificationContextProvider.notifier)
          .setContext(notification.id, notification.context!);
    }

    try {
      await ref.read(notificationSyncProvider.future);
    } catch (e) {
      log('Error during synchronization: $e');
    }
  }

  Future<void> _readNotificationDescription(
      NotificationEntity notification) async {
    var isTtsActive = ref.read(chatUIState).isTtsActive;

    if (isTtsActive) {
      final ttsHelper = ref.read(ttsHelperProvider.notifier);

      await Future.delayed(const Duration(milliseconds: 200));

      String welcomeMessage = "you have selected a notification";
      String description = notification.description;
      String finalMessage =
          "If you have any questions about this, don't hesitate to ask me.";

      String message = '''
        $welcomeMessage
        $description
        $finalMessage
      ''';

      await ttsHelper.speak(message);
    }
  }

  Future<void> _markAsRead(NotificationEntity notification) async {
    final userState = ref.read(userProvider);
    final userId = userState.user!.id;
    final repository = ref.read(notificationRepositoryProvider);

    await repository.markNotificationAsViewed(userId, notification.id);
  }
}

final notificationServiceProvider = Provider((ref) => NotificationService(ref));
