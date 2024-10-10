part of 'send_second_gpt_service.dart';

extension _SendSecondGptService on SendSecondGptService {
  Future<List<ChatModel>> _sendMessageGPTSecondPart({
    required String message,
    required String systemMessage,
    required String modelId,
  }) async {
    log("sendMessageGPTSecondPart has been called with the message: $message, the system message: $systemMessage, and the model: $modelId");
    try {
      Map<String, dynamic> config =
          await _chatbotConfigRepository.getChatbotConfig(
        collection: 'chatbots',
        doc: 'config',
        subCollection: 'chatbot',
        subDoc: 'conf_chatbot',
      );

      List<Map<String, String>> messages = [
        {
          "role": "system",
          "content":
              "si el (user) no especifica que quiere tienes que decirle que de más información, no supongas cosas que no tienes información, " +
                  config["system"] +
                  ", " +
                  systemMessage,
        },
        ...ChatOperationService.chatList
            .map((chat) => {
                  "role": chat.chatIndex == 0 ? "user" : "assistant",
                  "content": chat.msg,
                })
            .toList(),
        {"role": "user", "content": message}
      ];

      log("==== Content of the map ====");
      for (var messageMap in messages) {
        log("$messageMap");
      }
      log("==== End of the map ====");

      var response = await http.post(
        Uri.parse("${config['baseUrl']}/chat/completions"),
        headers: {
          'Authorization': 'Bearer ${config['apiKey']}',
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "model": config["model"],
          "temperature": parseDouble(config["temperature"]),
          "top_p": parseDouble(config["top_p"]),
          "frequency_penalty": parseDouble(config["frequency_penalty"]),
          "presence_penalty": parseDouble(config["presence_penalty"]),
          "messages": messages,
        }),
      );

      Map jsonResponse2 = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse2['error'] != null) {
        throw HttpException(jsonResponse2['error']["message"]);
      }

      if (jsonResponse2.containsKey('usage')) {
        log("Tokens used in the second call: ${jsonResponse2['usage']['total_tokens']}");
      }

      List<ChatModel> responseChatList = [];
      if (jsonResponse2["choices"].isNotEmpty) {
        responseChatList = jsonResponse2["choices"]
            .map<ChatModel>((choice) => ChatModel(
                  msg: choice["message"]["content"],
                  chatIndex: 1,
                ))
            .toList();
      }

      ChatOperationService.chatList.addAll(responseChatList);

      log("==== Content of chatList 1 ====");
      for (var chat in ChatOperationService.chatList) {
        log("${chat.chatIndex == 0 ? "user" : "assistant"}: ${chat.msg}");
      }
      log("==== End of chatList 1 ====");

      return responseChatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}
