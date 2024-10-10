import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_bot/in_app_bot/features/modes/product_mode/domain/entities/chat_notification_entity.dart';
import 'package:in_app_bot/in_app_bot/features/modes/product_mode/domain/repositories/chat_notification_repository.dart';

class ChatNotificationDataSource implements ChatNotificationRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> saveChatNotification(
      ChatNotificationEntity chatNotificationEntity) async {
    try {
      await _firestore
          .collection('chatbots')
          .doc('history')
          .collection('notifications_history')
          .doc(chatNotificationEntity.chatId)
          .set({
        'userId': chatNotificationEntity.userId,
        'chatId': chatNotificationEntity.chatId,
        'notificationId': chatNotificationEntity.notificationId,
        'chat': chatNotificationEntity.chat,
        'timestamp': Timestamp.fromDate(chatNotificationEntity.timestamp),
      });
    } catch (e) {
      log('Error saving notification chat in Firestore: $e');
      rethrow;
    }
  }
}
