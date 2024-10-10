import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/domain/entities/notification_entity.dart';

class RemoteNotificationDataSource {
  final FirebaseFirestore _firestore;

  RemoteNotificationDataSource(this._firestore);

  Future<List<NotificationEntity>> getNotifications() async {
    final firestoreNotifications = await _firestore
        .collection('chatbots')
        .doc('alert')
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();

    return firestoreNotifications.docs.map((doc) {
      final data = doc.data();
      return NotificationEntity(
        id: doc.id,
        type: data['type'],
        url: data['url'],
        title: data['title'],
        description: data['description'],
        timestamp: (data['timestamp'] as Timestamp).millisecondsSinceEpoch,
        linkToGo: data['link_to_go'],
        textButton: data['text_button'],
        context: data['context'],
      );
    }).toList();
  }

  Future<void> markNotificationAsViewed(
      String userId, String notificationId) async {
    final userNotificationsRef = _firestore
        .collection('chatbots')
        .doc('alert')
        .collection('viewed_notifications')
        .doc(userId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userNotificationsRef);

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()!;
        Map<String, dynamic> readNotifications =
            data['readNotifications'] ?? {};

        if (!readNotifications.containsKey(notificationId)) {
          readNotifications[notificationId] = Timestamp.now();

          transaction.update(userNotificationsRef, {
            'readNotifications': readNotifications,
            'lastReadTimestamp': Timestamp.now(),
          });
        }
      } else {
        transaction.set(userNotificationsRef, {
          'readNotifications': {notificationId: Timestamp.now()},
          'lastReadTimestamp': Timestamp.now(),
        });
      }
    });
  }
}
