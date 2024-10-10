import 'dart:developer';

import 'package:in_app_bot/in_app_bot/features/modes/common/domain/entities/chat_entity.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/usecases/save_chat_use_case.dart';
import 'package:in_app_bot/in_app_bot/features/modes/index_mode/data/datasources/index_chat_data_source.dart';

class SaveChatService {
  final SaveChatUseCase _saveChatUseCase = SaveChatUseCase(ChatDataSource());

  Future<void> saveChat(String appUserId, String chatId) async {
    try {
      final chatData = ChatFormatter.formatChatData();
      final chatEntity = ChatEntity(
        userId: appUserId,
        chatId: chatId,
        chat: chatData,
        timestamp: DateTime.now(),
      );
      await _saveChatUseCase.execute(chatEntity);
    } catch (e) {
      log('Error saving chat to Firestore: $e');
      rethrow;
    }
  }
}
