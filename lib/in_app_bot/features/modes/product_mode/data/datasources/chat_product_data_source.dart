import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_bot/in_app_bot/application/services/chat_operations.dart';
import 'package:in_app_bot/in_app_bot/features/modes/product_mode/domain/entities/chat_product_entity.dart';
import 'package:in_app_bot/in_app_bot/features/modes/product_mode/domain/repositories/chat_product_repository.dart';

class ChatProductDataSource implements ChatProductRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> saveChatProduct(ChatProductEntity chatProductEntity) async {
    try {
      await _firestore
          .collection('chatbots')
          .doc('history')
          .collection('product_history')
          .doc(chatProductEntity.chatId)
          .set({
        'userId': chatProductEntity.userId,
        'chatId': chatProductEntity.chatId,
        'productbotId': chatProductEntity.productbotId,
        'chat': chatProductEntity.chat,
        'timestamp': Timestamp.fromDate(chatProductEntity.timestamp),
      });
    } catch (e) {
      log('Error saving chat in Firestore: $e');
      rethrow;
    }
  }
}

class ChatProductFormatter {
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
