import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class KeywordIndexService {
  static Future<List<Map<String, dynamic>>> fetchAllDocuments() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final CollectionReference keywordIndexRef = firestore
        .collection('chatbots')
        .doc('k_index')
        .collection('keyword_index');

    try {
      final QuerySnapshot querySnapshot = await keywordIndexRef.get();

      final List<Map<String, dynamic>> documents = [];
      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        if (data.containsKey('k_id') &&
            data['k_id'] != null &&
            data.containsKey('keyword') &&
            data['keyword'] != null) {
          documents.add({'k_id': data['k_id'], 'keyword': data['keyword']});
        }
      }

      return documents;
    } on FirebaseException catch (e) {
      log('Error getting documents from Firestore: $e');
      rethrow;
    }
  }
}
