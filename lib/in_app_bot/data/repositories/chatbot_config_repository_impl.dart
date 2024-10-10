import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/repositories/chatbot_config_repository.dart';

class ChatbotConfigRepositoryImpl implements ChatbotConfigRepository {
  final FirebaseFirestore _firestore;

  ChatbotConfigRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Map<String, dynamic>> getChatbotConfig({
    required String collection,
    required String doc,
    String? subCollection,
    String? subDoc,
  }) async {
    DocumentReference configRef = _firestore.collection(collection).doc(doc);

    if (subCollection != null && subDoc != null) {
      configRef = configRef.collection(subCollection).doc(subDoc);
    }

    final DocumentSnapshot configSnapshot = await configRef.get();

    if (!configSnapshot.exists || configSnapshot.data() == null) {
      throw Exception('Config not found in Firestore');
    }

    return configSnapshot.data() as Map<String, dynamic>;
  }
}
