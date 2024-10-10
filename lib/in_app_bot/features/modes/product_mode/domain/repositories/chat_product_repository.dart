import 'package:in_app_bot/in_app_bot/features/modes/product_mode/domain/entities/chat_product_entity.dart';

abstract class ChatProductRepository {
  Future<void> saveChatProduct(ChatProductEntity chatProductEntity);
}
