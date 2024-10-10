import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

/// Names of collections and documents in Firestore
class FirestoreConstants {
  static const String chatbotsCollection = 'chatbots';
  static const String usersSubCollection = 'users';
  static const String cUsersDocument = 'c_users';
}

/// Service to handle operations in Firestore
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Gets the reference to the users collection
  CollectionReference get usersCollection => _firestore
      .collection(FirestoreConstants.chatbotsCollection)
      .doc(FirestoreConstants.cUsersDocument)
      .collection(FirestoreConstants.usersSubCollection);

  /// Saves or updates a user in Firestore
  ///
  /// [appUserId] is the user ID in the application
  Future<void> saveUserInFirestore(String appUserId) async {
    final String chatUserId = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      final docRef = usersCollection.doc(appUserId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        log('User with ID $appUserId already exists. Updating data...');
        await docRef.update({'last_login': DateTime.now()});
      } else {
        log('Creating new user with ID $appUserId');
        await docRef.set({
          'app_userId': appUserId,
          'chat_userId': chatUserId,
          'created_at': DateTime.now(),
          'last_login': DateTime.now(),
        });
      }
    } catch (e) {
      log('Error saving/updating user with ID $appUserId: $e');
      rethrow; // Propagates the error to handle it in upper layers
    }
  }
}
