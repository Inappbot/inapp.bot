import 'package:cloud_firestore/cloud_firestore.dart';

class ChatResponseService {
  static Future<String> fetchResponseFromFirestore(num kId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final QuerySnapshot querySnapshot = await firestore
        .collection('chatbots')
        .doc('k_index')
        .collection('keyword_index')
        .where('k_id', isEqualTo: kId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final DocumentSnapshot document = querySnapshot.docs.first;
      return document['response'];
    } else {
      throw Exception('Document with k_id: $kId not found');
    }
  }
}
