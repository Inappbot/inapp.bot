import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_bot/in_app_bot/features/modes/product_mode/domain/entities/previous_product_entity.dart';
import 'package:in_app_bot/in_app_bot/features/modes/product_mode/domain/repositories/previous_product_repository.dart';

class PreviousProductDataSource implements PreviousProductRepository {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<PreviousProductEntity> checkPreviousProductQuestion(
      String question, String productbotId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('chatbots')
          .doc('p_p_resp')
          .collection('product_previous_responses')
          .where('question', isEqualTo: question)
          .where('productbotId', isEqualTo: productbotId)
          .get();

      String? response = querySnapshot.docs.isNotEmpty
          ? querySnapshot.docs.first['response']
          : null;

      return PreviousProductEntity(response);
    } catch (e) {
      log('Error checking previous product question: $e');
      rethrow;
    }
  }
}
