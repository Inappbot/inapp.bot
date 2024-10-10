import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_bot/in_app_bot/features/modes/index_mode/domain/repositories/index_previous_question_repository.dart';

class PreviousQuestionDataSource implements PreviousQuestionRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<String?> checkPreviousQuestion(String question) async {
    try {
      var querySnapshot = await _firestore
          .collection('chatbots')
          .doc('f_p_resp')
          .collection('faq_previous_responses')
          .where('question', isEqualTo: question)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty
          ? querySnapshot.docs.first.get('response')
          : null;
    } catch (e) {
      log('Error checking previous question: $e');
      rethrow;
    }
  }
}
