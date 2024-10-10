class ChatEntity {
  final String userId;
  final String chatId;
  final List<Map<String, dynamic>> chat;
  final DateTime timestamp;

  ChatEntity({
    required this.userId,
    required this.chatId,
    required this.chat,
    required this.timestamp,
  });
}
