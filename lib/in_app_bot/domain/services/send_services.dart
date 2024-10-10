import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/data/repositories/chatbot_config_repository_impl.dart';
import 'package:in_app_bot/in_app_bot/features/keyword_index/data/repositories/keyword_index_repository_impl.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/entities/chat_model.dart';
import 'package:in_app_bot/in_app_bot/features/modes/index_mode/data/repositories/chat_repository_impl.dart';
import 'package:in_app_bot/in_app_bot/features/modes/infrastructure/network/dataplus/gemini/send_dataplus_gemini_service.dart';
import 'package:in_app_bot/in_app_bot/features/modes/infrastructure/network/index/GPT/send_first_gpt_service.dart';
import 'package:in_app_bot/in_app_bot/features/modes/infrastructure/network/index/GPT/send_second_gpt_service.dart';
import 'package:in_app_bot/in_app_bot/features/modes/infrastructure/network/pinecone/pinecone_query_service.dart';
import 'package:in_app_bot/in_app_bot/features/modes/infrastructure/network/product/gemini/send_product_llm_service.dart';
import 'package:in_app_bot/in_app_bot/features/modes/product_mode/data/datasources/previous_product_data_source.dart';
import 'package:in_app_bot/in_app_bot/features/modes/product_mode/domain/usecases/check_previous_product_use_case.dart';
import 'package:in_app_bot/in_app_bot/features/response_index/data/repositories/chat_response_repository_impl.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/chat_notifier.dart';

class SendServices {
  static Future<List<String>> sendFirstMessageAndGetResponse({
    required String msg,
    required String firstModelId,
    required Function(String) addBotMessageCallback,
    required String appUserId,
    required ChatNotifier chatNotifier,
    required WidgetRef ref,
  }) async {
    final chatbotConfigRepository = ChatbotConfigRepositoryImpl();
    final chatRepository = ChatRepositoryImpl(
      addBotMessageCallback: addBotMessageCallback,
      chatNotifier: chatNotifier,
      appUserId: appUserId,
    );
    final keywordIndexRepository = KeywordIndexRepositoryImpl();

    final sendFirstGptService = SendFirstGptService(
      chatbotConfigRepository: chatbotConfigRepository,
      chatRepository: chatRepository,
      keywordIndexRepository: keywordIndexRepository,
    );

    return await sendFirstGptService.sendFirstMessageAndGetResponse(
      msg: msg,
      firstModelId: firstModelId,
      ref: ref,
    );
  }

  static Future<void> sendSecondMessageAndGetResponse({
    required String msg,
    required List<String> documentNumbers,
    required String chosenModelId,
    required String appUserId,
    required ChatNotifier chatNotifier,
    required Function(List<ChatModel>) addBotMessagesCallback,
  }) async {
    final chatbotConfigRepository = ChatbotConfigRepositoryImpl();
    final chatRepository = ChatRepositoryImpl(
      chatNotifier: chatNotifier,
      appUserId: appUserId,
    );
    final chatResponseRepository = ChatResponseRepositoryImpl();

    final sendSecondGptService = SendSecondGptService(
      chatbotConfigRepository: chatbotConfigRepository,
      chatRepository: chatRepository,
      chatResponseRepository: chatResponseRepository,
    );

    await sendSecondGptService.sendSecondMessageAndGetResponse(
      msg: msg,
      documentNumbers: documentNumbers,
      chosenModelId: chosenModelId,
      addBotMessagesCallback: addBotMessagesCallback,
    );
  }

  static Future<List<ChatModel>> sendMessageAndGetProductResponse({
    required String message,
    required String modelId,
    required String productbotId,
    required String productbotName,
    required String productbotImageUrl,
    required String productbotDescription,
    required String appUserId,
    required ChatNotifier chatNotifier,
    required WidgetRef ref,
  }) async {
    final chatbotConfigRepository = ChatbotConfigRepositoryImpl();

    final previousProductDataSource = PreviousProductDataSource();
    final checkPreviousProductUseCase =
        CheckPreviousProductUseCase(previousProductDataSource);

    final sendProductGptService = SendProductLlmService(
      chatbotConfigRepository: chatbotConfigRepository,
      checkPreviousProductUseCase: checkPreviousProductUseCase,
      ref: ref,
    );

    return await sendProductGptService.sendMessageAndGetProductResponse(
      message: message,
      modelId: modelId,
      productbotId: productbotId,
      productbotName: productbotName,
      productbotImageUrl: productbotImageUrl,
      productbotDescription: productbotDescription,
      appUserId: appUserId,
      chatNotifier: chatNotifier,
    );
  }

  static Future<List<ChatModel>> sendMessageAndGetPineconeResponse({
    required String message,
    required String modelId,
    required String appUserId,
    required ChatNotifier chatNotifier,
    required WidgetRef ref,
  }) async {
    // Do not erase this comment, it is used for the implementation of other models.
    // final chatbotConfigRepository = ChatbotConfigRepositoryImpl();
    final chatRepository =
        ChatRepositoryImpl(chatNotifier: chatNotifier, appUserId: appUserId);

    final pineconeQueryService = ref.read(pineconeQueryServiceProvider);

    final sendMessageUseCase = SendMessageDataPlus(
      chatRepository: chatRepository,
      // Do not erase this comment, it is used for the implementation of other models.
      // chatbotConfigRepository: chatbotConfigRepository,
      pineconeQueryService: pineconeQueryService,
      ref: ref,
    );

    return await sendMessageUseCase.sendMessage(
      message: message,
      modelId: modelId,
      appUserId: appUserId,
      chatNotifier: chatNotifier,
    );
  }
}
