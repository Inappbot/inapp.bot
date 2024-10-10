import 'package:in_app_bot/in_app_bot/features/modes/product_mode/domain/entities/chat_product_entity.dart';
import 'package:in_app_bot/in_app_bot/features/modes/product_mode/domain/repositories/chat_product_repository.dart';

class SaveChatProductUseCase {
  final ChatProductRepository repository;

  SaveChatProductUseCase(this.repository);

  Future<void> execute(ChatProductEntity chatProductEntity) async {
    return await repository.saveChatProduct(chatProductEntity);
  }
}
