import 'package:in_app_bot/in_app_bot/features/modes/common/domain/entities/chat_model.dart';
import 'package:uuid/uuid.dart';

class ChatOperationService {
  static List<ChatModel> chatList = [];

  static void clearChatList() {
    chatList.clear();
  }

  static String generateChatId() {
    var uuid = const Uuid();
    String randomPart = uuid.v4();
    return randomPart;
  }
}
