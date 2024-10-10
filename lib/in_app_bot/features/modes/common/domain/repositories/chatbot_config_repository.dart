abstract class ChatbotConfigRepository {
  Future<Map<String, dynamic>> getChatbotConfig({
    required String collection,
    required String doc,
    String? subCollection,
    String? subDoc,
  });
}
