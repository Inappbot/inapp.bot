import 'package:in_app_bot/in_app_bot/features/modes/common/domain/entities/chat_model.dart';

abstract class ChatRepository {
  Future<String?> checkPreviousQuestion(String msg);
  Future<void> processPreviousAnswer(String msg, String previousAnswer);
  List<ChatModel> getChatList();
  void addChat(ChatModel chat);
  void addChatList(List<ChatModel> chatList);
  Future<void> saveChat(String appUserId, String chatId);
  Future<void> saveChatIndex();
}
