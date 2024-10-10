import 'package:in_app_bot/in_app_bot/features/response_index/data/services/chatbot_response_fetch_service.dart';
import 'package:in_app_bot/in_app_bot/features/response_index/domain/repositories/chat_response_repository.dart';

class ChatResponseRepositoryImpl implements ChatResponseRepository {
  @override
  Future<String> fetchResponseFromFirestore(dynamic documentNumber) async {
    return await ChatResponseService.fetchResponseFromFirestore(documentNumber);
  }
}
