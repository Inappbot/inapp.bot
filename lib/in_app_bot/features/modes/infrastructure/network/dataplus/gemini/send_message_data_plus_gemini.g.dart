part of 'send_dataplus_gemini_service.dart';

extension SendMessageDataPlusExtension on SendMessageDataPlus {
  Future<List<ChatModel>> sendMessage({
    required String message,
    required String modelId,
    required String appUserId,
    required ChatNotifier chatNotifier,
  }) async {
    try {
      _addUserMessageToChatList(message);

      final frequentQuestionResponse =
          await _checkFrequentDataPlusQuestions(message);
      if (frequentQuestionResponse != null) {
        return _handleFrequentQuestion(
            frequentQuestionResponse, appUserId, chatNotifier);
      }

      final processedMessage = await _processMessageWithLLM(message);
      _logMessage("Question with context sent to Pinecone", processedMessage);

      final pineconeResult = await _queryPinecone(processedMessage);
      final chatSession = _model.startChat(history: _buildChatHistory());

      final fullMessage = """
Based on the following contextual information, provide an accurate and slightly friendly response to the user's query. Maintain a professional yet cordial tone.
Rules:

Be concise but not excessively dry.
You may use short courteous phrases at the beginning or end of the response when appropriate.
Do not mention the source of the information.
Do not offer additional explanations unless absolutely necessary.
Ensure that the requested information is clear and easy to identify in the response.
Always respond in the same language as the user's query.

Context: $pineconeResult
User query: $message
Remember: Kindness is important, but accuracy and conciseness are priorities. Maintain linguistic consistency with the user's input.
""";

      final response = await chatSession.sendMessage(Content.text(fullMessage));
      final responseChatList = _buildResponseChatList(response);

      _addResponseToChatList(responseChatList);
      _logChatList();
      await _saveChat(appUserId, chatNotifier.currentChatId!);

      return responseChatList;
    } catch (error) {
      log("Error: $error");
      rethrow;
    }
  }
}
