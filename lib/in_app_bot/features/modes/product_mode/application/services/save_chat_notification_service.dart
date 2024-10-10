import 'dart:developer';

import 'package:in_app_bot/in_app_bot/application/services/chat_operations.dart';
import 'package:in_app_bot/in_app_bot/features/modes/product_mode/data/datasources/chat_notification_data_source.dart';
import 'package:in_app_bot/in_app_bot/features/modes/product_mode/domain/entities/chat_notification_entity.dart';
import 'package:in_app_bot/in_app_bot/features/modes/product_mode/domain/usecases/save_chat_notification_use_case.dart';

class SaveChatNotificationService {
  final SaveChatNotificationUseCase _saveChatNotificationUseCase =
      SaveChatNotificationUseCase(ChatNotificationDataSource());

  Future<void> saveChatNotification(
      String appUserId, String chatId, String notificationId) async {
    try {
      final chatData = ChatNotificationFormatter.formatChatData();
      final chatNotificationEntity = ChatNotificationEntity(
        userId: appUserId,
        chatId: chatId,
        notificationId: notificationId,
        chat: chatData,
        timestamp: DateTime.now(),
      );
      await _saveChatNotificationUseCase.execute(chatNotificationEntity);
    } catch (e) {
      log('Error saving notification chat in Firestore: $e');
      rethrow;
    }
  }
}

class ChatNotificationFormatter {
  static List<Map<String, dynamic>> formatChatData() {
    return ChatOperationService.chatList.map((chat) {
      Map<String, dynamic> chatData = {
        'role': chat.chatIndex == 0 ? 'user' : 'assistant',
        'content': chat.msg,
      };

      if (chat.chatIndex == 0) {
        chatData['isPreviousResponse'] = chat.isPreviousResponse;
      }

      return chatData;
    }).toList();
  }
}
