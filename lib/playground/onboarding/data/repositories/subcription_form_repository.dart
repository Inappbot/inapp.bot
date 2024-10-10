import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionFormRepository {
  final FirebaseFirestore firestore;

  SubscriptionFormRepository({required this.firestore});

  Future<void> saveSubscription(
    String email,
    String description,
  ) async {
    final data = {
      'email': email,
      'name': description,
      'timestamp': DateTime.now(),
    };

    // Generate an ID based on the email (you can use any unique field)
    String documentId = email;

    // Reference the document with the customized ID
    DocumentReference userRef = FirebaseFirestore.instance
        .collection('chatbots')
        .doc('onboarding')
        .collection('subspcriptions')
        .doc(documentId);

    // Check if the document already exists
    DocumentSnapshot docSnapshot = await userRef.get();

    if (docSnapshot.exists) {
      log('Error: A user with this email already exists.');
    } else {
      // Create a new document with the customized ID
      await userRef.set(data);

      log('User created successfully.');
    }
  }
}

final subcriptionFormRepositoryProvider =
    Provider<SubscriptionFormRepository>((ref) {
  return SubscriptionFormRepository(firestore: FirebaseFirestore.instance);
});
