import 'dart:developer';

import 'package:in_app_bot/in_app_bot/features/modes/common/domain/entities/chat_entity.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/usecases/save_chat_use_case.dart';
import 'package:in_app_bot/in_app_bot/features/modes/data_plus_mode/data/datasources/dataplus_chat_data_source.dart';

class SaveChatServiceDataPlus {
  final SaveChatUseCase _saveChatUseCase = SaveChatUseCase(ChatDataSource());

  Future<void> saveChatDataplus(String appUserId, String chatId) async {
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
      log('Error saving in Firestore: $e');
      rethrow;
    }
  }
}
