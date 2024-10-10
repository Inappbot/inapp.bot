import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/entities/config_entity.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/repositories/config_repository.dart';

class ConfigDataSource implements ConfigRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const _docMapping = {
    'chatbot': 'conf_chatbot',
    'chatbot_products': 'conf_chatbot_products',
    'list_chatbot': 'conf_list_chatbot',
  };

  @override
  Future<ConfigEntity> getConfig(String docName) async {
    try {
      final configSnapshot = await _getConfigSnapshot(docName);
      _validateSnapshotExists(configSnapshot);
      return _extractDataFromSnapshot(configSnapshot);
    } catch (e) {
      log('Error retrieving chatbot configuration: $e');
      rethrow;
    }
  }

  Future<DocumentSnapshot> _getConfigSnapshot(String docName) {
    final configRef = _firestore
        .collection('chatbots')
        .doc('config')
        .collection(docName)
        .doc(_docMapping[docName]);
    return configRef.get();
  }

  void _validateSnapshotExists(DocumentSnapshot snapshot) {
    if (!snapshot.exists) {
      throw Exception('Chatbot configuration not found');
    }
  }

  ConfigEntity _extractDataFromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ConfigEntity(data);
  }
}
