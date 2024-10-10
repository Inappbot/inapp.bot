import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_bot/in_app_bot/features/keyword_index/data/services/keyword_index_repository.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/entities/chat_model.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/repositories/chat_repository.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/repositories/chatbot_config_repository.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/utils/parsing_helpers.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/providers.dart';

part 'send_first_gpt_service.g.dart';

class SendFirstGptService {
  final ChatbotConfigRepository _chatbotConfigRepository;
  final ChatRepository _chatRepository;
  final KeywordIndexRepository _keywordIndexRepository;

  SendFirstGptService({
    required ChatbotConfigRepository chatbotConfigRepository,
    required ChatRepository chatRepository,
    required KeywordIndexRepository keywordIndexRepository,
  })  : _chatbotConfigRepository = chatbotConfigRepository,
        _chatRepository = chatRepository,
        _keywordIndexRepository = keywordIndexRepository;

  Future<List<ChatModel>> sendMessageGPTFirstPart({
    required String message,
    required String modelId,
  }) async {
    return await _sendMessageGPTFirstPart(message: message, modelId: modelId);
  }

  Future<List<String>> sendFirstMessageAndGetResponse({
    required String msg,
    required String firstModelId,
    required WidgetRef ref,
  }) async {
    String? previousAnswer = await _chatRepository.checkPreviousQuestion(msg);

    if (previousAnswer != null) {
      await _chatRepository.processPreviousAnswer(msg, previousAnswer);

      ref
          .read(chatUIState.notifier)
          .update((state) => state.copyWith(isTyping: false));

      return [];
    }

    return await _prepareAndSendMessageGPT(msg, firstModelId);
  }

  Future<List<String>> _prepareAndSendMessageGPT(
      String msg, String modelId) async {
    List<Map<String, dynamic>> documents =
        await _keywordIndexRepository.fetchAllDocuments();

    String documentList = documents
        .map((doc) => ' ${doc['k_id']}: ${doc['keyword'] ?? 'No keyword'}')
        .join('\n');

    String gptMessage =
        'do not make up information that does not exist in these numbers, choose the number: $documentList\n\n, message: $msg';

    List<ChatModel> firstResponse =
        await sendMessageGPTFirstPart(message: gptMessage, modelId: modelId);

    return firstResponse[0].msg.split(',');
  }
}
