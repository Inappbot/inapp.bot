import 'dart:developer';

import 'package:in_app_bot/in_app_bot/features/modes/product_mode/data/datasources/chat_product_data_source.dart';
import 'package:in_app_bot/in_app_bot/features/modes/product_mode/domain/entities/chat_product_entity.dart';
import 'package:in_app_bot/in_app_bot/features/modes/product_mode/domain/usecases/save_chat_product_use_case.dart';

class SaveChatProductService {
  final SaveChatProductUseCase _saveChatProductUseCase =
      SaveChatProductUseCase(ChatProductDataSource());

  Future<void> saveChatProduct(
      String appUserId, String chatId, String productbotId) async {
    try {
      final chatData = ChatProductFormatter.formatChatData();
      final chatProductEntity = ChatProductEntity(
        userId: appUserId,
        chatId: chatId,
        productbotId: productbotId,
        chat: chatData,
        timestamp: DateTime.now(),
      );
      await _saveChatProductUseCase.execute(chatProductEntity);
    } catch (e) {
      log('Error saving chat in Firestore: $e');
      rethrow;
    }
  }
}
