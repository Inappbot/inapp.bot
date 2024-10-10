import 'package:in_app_bot/in_app_bot/features/modes/product_mode/domain/entities/chat_notification_entity.dart';

abstract class ChatNotificationRepository {
  Future<void> saveChatNotification(
      ChatNotificationEntity chatNotificationEntity);
}
