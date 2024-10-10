// part of 'send_product_gpt_service.dart';

// extension _SendProductGptService on SendProductLlmService {
//   List<Map<String, String>> _buildMessagesList(
//       String message,
//       String productbotId,
//       String productbotName,
//       String productbotImageUrl,
//       String productbotDescription,
//       Map<String, dynamic> config) {
//     return [
//       {
//         "role": "system",
//         "content":
//             "Detalles del producto: id = [promo]$productbotId, name = $productbotName, url = $productbotImageUrl, description = $productbotDescription. " +
//                 config["system"]
//       },
//       ...ChatOperationService.chatList
//           .map((chat) => {
//                 "role": chat.chatIndex == 0 ? "user" : "assistant",
//                 "content": chat.msg,
//               })
//           .toList(),
//       {"role": "user", "content": message}
//     ];
//   }

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
//               msg: jsonResponse["choices"][index]["message"]["content"],
//               chatIndex: 1,
//             ),
//           );
//   }

//   void _logChatList() {
//     print("==== Contenido de chatList ====");
//     for (ChatModel chat in ChatOperationService.chatList) {
//       print("${chat.chatIndex == 0 ? "user" : "assistant"}: ${chat.msg}");
//     }
//     print("==== Fin de chatList ====");
//   }

//   Future<void> _saveChatIfValid(
//       String? currentChatId, String appUserId, String productbotId) async {
//     if (currentChatId != null) {
//       await SaveChatProductService()
//           .saveChatProduct(appUserId, currentChatId, productbotId);
//     }
//   }
// }
