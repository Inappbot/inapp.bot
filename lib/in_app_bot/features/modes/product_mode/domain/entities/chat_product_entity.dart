class ChatProductEntity {
  final String userId;
  final String chatId;
  final String productbotId;
  final List<Map<String, dynamic>> chat;
  final DateTime timestamp;

  ChatProductEntity({
    required this.userId,
    required this.chatId,
    required this.productbotId,
    required this.chat,
    required this.timestamp,
  });
}
