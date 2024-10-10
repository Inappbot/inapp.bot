class ChatNotificationEntity {
  final String userId;
  final String chatId;
  final String notificationId;
  final List<Map<String, dynamic>> chat;
  final DateTime timestamp;

  ChatNotificationEntity({
    required this.userId,
    required this.chatId,
    required this.notificationId,
    required this.chat,
    required this.timestamp,
  });
}
