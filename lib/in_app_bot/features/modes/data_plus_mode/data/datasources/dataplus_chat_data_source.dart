import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_bot/in_app_bot/application/services/chat_operations.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/entities/chat_entity.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/repositories/chat_save_repository.dart';

class ChatDataSource implements ChatSaveRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> saveChat(ChatEntity chatEntity) async {
    try {
      await _firestore
          .collection('chatbots')
          .doc('history')
          .collection('dataplus_history')
          .doc(chatEntity.chatId)
          .set({
        'userId': chatEntity.userId,
        'chatId': chatEntity.chatId,
        'chat': chatEntity.chat,
        'timestamp': Timestamp.fromDate(chatEntity.timestamp),
      });
    } catch (e) {
      log('Error saving chat in Firestore: $e');
      rethrow;
    }
  }
}

class ChatFormatter {
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
