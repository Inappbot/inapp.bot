// part of 'send_dataplus_gpt_service.dart';

// extension _SendMessageDataPlus on SendMessageDataPlus {
//   Future<http.Response> _postChatbotRequest(
//       Map<String, dynamic> config, List<Map<String, String>> messages) async {
//     return await http.post(
//       Uri.parse("${config['baseUrl']}/chat/completions"),
//       headers: {
//         'Authorization': 'Bearer ${config['apiKey']}',
//         "Content-Type": "application/json"
//       },
//       body: jsonEncode({
//         "model": config["model"],
//         "temperature": parseDouble(config["temperature"]),
//         "top_p": parseDouble(config["top_p"]),
//         "frequency_penalty": parseDouble(config["frequency_penalty"]),
//         "presence_penalty": parseDouble(config["presence_penalty"]),
//         "messages": messages,
//       }),
//     );
//   }

//   void _validateJsonResponse(Map jsonResponse) {
//     if (jsonResponse['error'] != null) {
//       throw HttpException(jsonResponse['error']["message"]);
//     }
//   }

//   List<ChatModel> _buildResponseChatList(Map jsonResponse) {
//     return jsonResponse["choices"].isEmpty
//         ? []
//         : List.generate(
//             jsonResponse["choices"].length,
//             (index) => ChatModel(
//                   msg: jsonResponse["choices"][index]["message"]["content"],
//                   chatIndex: 1,
//                 ));
//   }

//   void _logChatList() {
//     _logMessage("Contenido de chatList", "");
//     for (ChatModel chat in ChatOperationService.chatList) {
//       _logMessage(chat.chatIndex == 0 ? "user" : "assistant", chat.msg);
//     }
//     _logMessage("Fin de chatList", "");
//   }

//   Future<String?> _checkFrequentDataPlusQuestions(String message) async {
//     final CollectionReference collection = FirebaseFirestore.instance
//         .collection('chatbots')
//         .doc('data_plus')
//         .collection('data_plus_previous_responses');

//     final QuerySnapshot snapshot = await collection.get();

//     for (var doc in snapshot.docs) {
//       try {
//         if (doc.get('frequency_message') == true &&
//             _isQuestionSimilar(doc.get('question'), message)) {
//           return doc.get('response');
//         }
//       } catch (e) {
//         print("Error obteniendo campos del documento: $e");
//       }
//     }

//     return null;
//   }

//   bool _isQuestionSimilar(String dbQuestion, String userQuestion) {
//     // Implementa aquí la lógica para comparar las preguntas
//     // Por ahora, usaremos una comparación simple de strings en minúsculas

//     return dbQuestion.toLowerCase() == userQuestion.toLowerCase();
//   }
// }
