import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:in_app_bot/in_app_bot/application/services/chat_operations.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/entities/chat_model.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/repositories/chatbot_config_repository.dart';
import 'package:in_app_bot/in_app_bot/features/modes/infrastructure/data/services/gemini_api_service.dart';
import 'package:in_app_bot/in_app_bot/features/modes/product_mode/application/services/product_save_chat_service.dart';
import 'package:in_app_bot/in_app_bot/features/modes/product_mode/application/services/save_chat_notification_service.dart';
import 'package:in_app_bot/in_app_bot/features/modes/product_mode/domain/usecases/check_previous_product_use_case.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/presentation/state/notification_providers.dart';
import 'package:in_app_bot/in_app_bot/features/qr_assistant_scanner/presentation/providers/qr_ai_providers.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/chat_notifier.dart';

part 'send_product_llm_service.g.dart';

class SendProductLlmService {
  final ChatbotConfigRepository _chatbotConfigRepository;
  final CheckPreviousProductUseCase _checkPreviousProductUseCase;
  late GenerativeModel _model;
  final WidgetRef _ref;
  final Completer<void> _initializationCompleter = Completer<void>();

  SendProductLlmService({
    required ChatbotConfigRepository chatbotConfigRepository,
    required CheckPreviousProductUseCase checkPreviousProductUseCase,
    required WidgetRef ref,
  })  : _chatbotConfigRepository = chatbotConfigRepository,
        _checkPreviousProductUseCase = checkPreviousProductUseCase,
        _ref = ref {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _initializeGeminiModel();
      _initializationCompleter.complete();
    } catch (error) {
      _initializationCompleter.completeError(error);
    }
  }

  Future<void> _initializeGeminiModel() async {
    final geminiApiService = GeminiApiService(_ref);
    final String? apiKey = await geminiApiService.getGeminiApiKey();

    if (apiKey != null) {
      _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );
      log('Gemini API Key obtained: $apiKey');
    } else {
      log('Could not get Gemini API Key');
      throw Exception(
          'Failed to initialize Gemini model due to missing API Key');
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_initializationCompleter.isCompleted) {
      await _initializationCompleter.future;
    }
  }

  Future<List<ChatModel>> sendMessageAndGetProductResponse({
    required String message,
    required String modelId,
    required String productbotId,
    required String productbotName,
    required String productbotImageUrl,
    required String productbotDescription,
    required String appUserId,
    required ChatNotifier chatNotifier,
  }) async {
    await _ensureInitialized();
    log("sendMessageAndGetResponse called with message: $message and model: $modelId");

    final selectedNotification = _ref.read(selectedNotificationProvider);
    final context = selectedNotification?.context;
    final productData = _ref.watch(productDataProvider);

    String? previousProductAnswer =
        (await _checkPreviousProductUseCase.execute(message, productbotId))
            .response;

    if (previousProductAnswer != null) {
      return _handlePreviousProductAnswer(message, previousProductAnswer,
          appUserId, chatNotifier, productbotId);
    }

    try {
      Map<String, dynamic> config =
          await _chatbotConfigRepository.getChatbotConfig(
        collection: 'chatbots',
        doc: 'config',
        subCollection: 'chatbot_products',
        subDoc: 'conf_chatbot_products',
      );
      ChatOperationService.chatList.add(ChatModel(msg: message, chatIndex: 0));

      final chatSession = _model.startChat(history: _buildChatHistory());

      String fullMessage;

      if (productData != null) {
        fullMessage = """
Contexto del producto escaneado: ${productData['context']}

${config["system"]}

User query: $message

Respond accurately and in a slightly friendly tone while maintaining professionalism. Be concise but not excessively dry. You may use short courteous phrases at the beginning or end when appropriate. Do not mention the source of the information or offer additional explanations unless absolutely necessary. Ensure the requested information is clear and easy to identify. Always respond in the same language as the user's query.
""";
      } else if (context != null) {
        fullMessage = """
Contexto de la notificación abierta: $context

${config["system"]}

User query: $message

Respond accurately and in a slightly friendly tone while maintaining professionalism. Be concise but not excessively dry. You may use short courteous phrases at the beginning or end when appropriate. Do not mention the source of the information or offer additional explanations unless absolutely necessary. Ensure the requested information is clear and easy to identify. Always respond in the same language as the user's query.
""";
      } else {
        fullMessage = """
Detalles del producto: 
id = [promo]$productbotId
name = $productbotName
url = $productbotImageUrl
description = $productbotDescription

${config["system"]}

User query: $message

Respond accurately and in a slightly friendly tone while maintaining professionalism. Be concise but not excessively dry. You may use short courteous phrases at the beginning or end when appropriate. Do not mention the source of the information or offer additional explanations unless absolutely necessary. Ensure the requested information is clear and easy to identify. Always respond in the same language as the user's query.
""";
      }

      final response = await chatSession.sendMessage(Content.text(fullMessage));

      List<ChatModel> responseChatList = _buildResponseChatList(response);

      ChatOperationService.chatList.addAll(responseChatList);

      _logChatList();
      await _saveChatIfValid(
          chatNotifier.currentChatId, appUserId, productbotId);

      return responseChatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}
