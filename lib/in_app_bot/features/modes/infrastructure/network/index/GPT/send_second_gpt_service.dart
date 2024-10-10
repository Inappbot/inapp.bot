import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:in_app_bot/in_app_bot/application/services/chat_operations.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/entities/chat_model.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/repositories/chat_repository.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/repositories/chatbot_config_repository.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/utils/parsing_helpers.dart';
import 'package:in_app_bot/in_app_bot/features/response_index/domain/repositories/chat_response_repository.dart';

part 'send_second_gpt_service.g.dart';

class SendSecondGptService {
  final ChatbotConfigRepository _chatbotConfigRepository;
  final ChatRepository _chatRepository;
  final ChatResponseRepository _chatResponseRepository;

  SendSecondGptService({
    required ChatbotConfigRepository chatbotConfigRepository,
    required ChatRepository chatRepository,
    required ChatResponseRepository chatResponseRepository,
  })  : _chatbotConfigRepository = chatbotConfigRepository,
        _chatRepository = chatRepository,
        _chatResponseRepository = chatResponseRepository;

  Future<List<ChatModel>> sendMessageGPTSecondPart({
    required String message,
    required String systemMessage,
    required String modelId,
  }) async {
    return await _sendMessageGPTSecondPart(
        message: message, systemMessage: systemMessage, modelId: modelId);
  }

  Future<void> sendSecondMessageAndGetResponse({
    required String msg,
    required List<String> documentNumbers,
    required String chosenModelId,
    required Function(List<ChatModel>) addBotMessagesCallback,
  }) async {
    if (documentNumbers.isEmpty) return;

    // Add the user's message to ChatOperationService.chatList
    ChatOperationService.chatList.add(ChatModel(msg: msg, chatIndex: 0));
    log("User message added to chatList: $msg");

    // Check the contents of chatList after adding the user's message
    log("==== Contents of chatList after adding user message ====");
    for (var chat in ChatOperationService.chatList) {
      log("${chat.chatIndex == 0 ? "user" : "assistant"}: ${chat.msg}");
    }
    log("==== End of chatList after adding user message ====");

    List<String> responses =
        await Future.wait(documentNumbers.map(_fetchResponse));

    String systemMessage =
        'RESPOND FROM THIS CONTENT: ${responses.join(' ')} , respond but do not assume anything or base your response on assumptions';

    List<ChatModel> secondResponse = await sendMessageGPTSecondPart(
      message: msg,
      systemMessage: systemMessage,
      modelId: chosenModelId,
    );

// Add the bot's responses to ChatOperationService.chatList
//ChatOperationService.chatList.addAll(secondResponse);

// Verify the content of chatList after adding the bot's responses
    log("==== Content of chatList after adding the bot's responses ====");
    for (var chat in ChatOperationService.chatList) {
      log("${chat.chatIndex == 0 ? "user" : "assistant"}: ${chat.msg}");
    }
    log("==== End of chatList after adding the bot's responses ====");

// Call the callback to add the bot's messages
    addBotMessagesCallback(secondResponse);

// Save the chat
    await _chatRepository.saveChatIndex();
  }

  Future<String> _fetchResponse(String documentNumber) async {
    double? documentNumberDouble = double.tryParse(documentNumber.trim());
    int? documentNumberInt = int.tryParse(documentNumber.trim());

    if (documentNumberDouble != null && documentNumberInt == null) {
      return await _chatResponseRepository
          .fetchResponseFromFirestore(documentNumberDouble);
    } else if (documentNumberInt != null) {
      return await _chatResponseRepository
          .fetchResponseFromFirestore(documentNumberInt);
    } else {
      log('Error: Document number is not a valid integer or double. Converting to 5.');
      return await _chatResponseRepository.fetchResponseFromFirestore(5);
    }
  }
}
