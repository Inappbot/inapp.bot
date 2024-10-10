import 'package:in_app_bot/in_app_bot/features/modes/common/domain/entities/chat_entity.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/repositories/chat_save_repository.dart';

class SaveChatUseCase {
  final ChatSaveRepository repository;

  SaveChatUseCase(this.repository);

  Future<void> execute(ChatEntity chatEntity) async {
    return await repository.saveChat(chatEntity);
  }
}
