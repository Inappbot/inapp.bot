// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:http/http.dart' as http;

// import 'package:in_app_bot/in_app_bot/application/services/chat_operations.dart';
// import 'package:in_app_bot/in_app_bot/features/modes/common/domain/entities/chat_model.dart';
// import 'package:in_app_bot/in_app_bot/features/modes/common/domain/repositories/chatbot_config_repository.dart';
// import 'package:in_app_bot/in_app_bot/features/modes/common/utils/parsing_helpers.dart';
// import 'package:in_app_bot/in_app_bot/features/modes/product_mode/application/services/product_save_chat_service.dart';
// import 'package:in_app_bot/in_app_bot/features/modes/product_mode/domain/usecases/check_previous_product_use_case.dart';
// import 'package:in_app_bot/in_app_bot/presentation/providers/chat_notifier.dart';

// part 'send_product_gpt_service.g.dart';

// class SendProductLlmService {
//   final ChatbotConfigRepository _chatbotConfigRepository;
//   final CheckPreviousProductUseCase _checkPreviousProductUseCase;

//   SendProductLlmService({
//     required ChatbotConfigRepository chatbotConfigRepository,
//     required CheckPreviousProductUseCase checkPreviousProductUseCase,
//   })  : _chatbotConfigRepository = chatbotConfigRepository,
//         _checkPreviousProductUseCase = checkPreviousProductUseCase;

//   Future<List<ChatModel>> sendMessageAndGetProductResponse({
//     required String message,
//     required String modelId,
//     required String productbotId,
//     required String productbotName,
//     required String productbotImageUrl,
//     required String productbotDescription,
//     required String appUserId,
//     required ChatNotifier chatNotifier,
//   }) async {
//     print(
//         "sendMessageAndGetResponse called with message: $message and model: $modelId");

//     String? previousProductAnswer =
//         (await _checkPreviousProductUseCase.execute(message, productbotId))
//             .response;

//     if (previousProductAnswer != null) {
//       return _handlePreviousProductAnswer(message, previousProductAnswer,
//           appUserId, chatNotifier, productbotId);
//     }

//     try {
//       Map<String, dynamic> config =
//           await _chatbotConfigRepository.getChatbotConfig(
//         collection: 'chatbots',
//         doc: 'config',
//         subCollection: 'chatbot_products',
//         subDoc: 'conf_chatbot_products',
//       );
//       ChatOperationService.chatList.add(ChatModel(msg: message, chatIndex: 0));
//       List<Map<String, String>> messages = _buildMessagesList(
//           message,
//           productbotId,
//           productbotName,
//           productbotImageUrl,
//           productbotDescription,
//           config);

//       var response = await _postChatbotRequest(config, messages);

//       Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
//       _validateJsonResponse(jsonResponse);

//       List<ChatModel> responseChatList = _buildResponseChatList(jsonResponse);

//       ChatOperationService.chatList.addAll(responseChatList);

//       _logChatList();
//       await _saveChatIfValid(
//           chatNotifier.currentChatId, appUserId, productbotId);

//       return responseChatList;
//     } catch (error) {
//       log("error $error");
//       rethrow;
//     }
//   }

//   Future<List<ChatModel>> _handlePreviousProductAnswer(
//       String message,
//       String previousProductAnswer,
//       String appUserId,
//       ChatNotifier chatNotifier,
//       String productbotId) async {
//     ChatOperationService.chatList.add(ChatModel(msg: message, chatIndex: 0));
//     ChatOperationService.chatList
//         .add(ChatModel(msg: previousProductAnswer, chatIndex: 1));

//     await _saveChatIfValid(chatNotifier.currentChatId, appUserId, productbotId);

//     return [ChatModel(msg: previousProductAnswer, chatIndex: 1)];
//   }
// }
