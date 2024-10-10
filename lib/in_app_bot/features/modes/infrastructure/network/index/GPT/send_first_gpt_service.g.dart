part of 'send_first_gpt_service.dart';

extension _SendFirstGptService on SendFirstGptService {
  Future<List<ChatModel>> _sendMessageGPTFirstPart({
    required String message,
    required String modelId,
  }) async {
    try {
      Map<String, dynamic> config =
          await _chatbotConfigRepository.getChatbotConfig(
        collection: 'chatbots',
        doc: 'config',
        subCollection: 'list_chatbot',
        subDoc: 'conf_list_chatbot',
      );

      List<Map<String, String>> messages = [
        {"role": "system", "content": config["system"]},
        {"role": "user", "content": message}
      ];

      var response = await http.post(
        Uri.parse("${config['baseUrl']}/chat/completions"),
        headers: {
          'Authorization': 'Bearer ${config['apiKey']}',
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "model": config["list_model"],
          "max_tokens": parseInt(config["max_tokens"]),
          "temperature": parseDouble(config["temperature"]),
          "top_p": parseDouble(config["top_p"]),
          "frequency_penalty": parseDouble(config["frequency_penalty"]),
          "presence_penalty": parseDouble(config["presence_penalty"]),
          "messages": messages,
        }),
      );

      Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }

      if (jsonResponse.containsKey('usage')) {
        log("Tokens used in first call: ${jsonResponse['usage']}");
      }

      return _parseChatModels(jsonResponse);
    } catch (error) {
      log("Error $error");
      rethrow;
    }
  }

  List<ChatModel> _parseChatModels(Map jsonResponse) {
    List<ChatModel> responseChatList = [];
    if (jsonResponse["choices"].length > 0) {
      responseChatList = List.generate(
        jsonResponse["choices"].length,
        (index) => ChatModel(
          msg: jsonResponse["choices"][index]["message"]["content"],
          chatIndex: 1,
        ),
      );
    }
    return responseChatList;
  }
}
