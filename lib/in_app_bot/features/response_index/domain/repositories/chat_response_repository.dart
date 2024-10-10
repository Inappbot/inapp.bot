abstract class ChatResponseRepository {
  Future<String> fetchResponseFromFirestore(dynamic documentNumber);
}
