import 'package:in_app_bot/in_app_bot/features/modes/common/domain/entities/chat_entity.dart';

abstract class ChatSaveRepository {
  Future<void> saveChat(ChatEntity chatEntity);
}
