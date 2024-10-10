import 'package:in_app_bot/in_app_bot/features/modes/product_mode/domain/entities/chat_notification_entity.dart';
import 'package:in_app_bot/in_app_bot/features/modes/product_mode/domain/repositories/chat_notification_repository.dart';

class SaveChatNotificationUseCase {
  final ChatNotificationRepository repository;

  SaveChatNotificationUseCase(this.repository);

  Future<void> execute(ChatNotificationEntity chatNotificationEntity) async {
    return await repository.saveChatNotification(chatNotificationEntity);
  }
}
