// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:in_app_bot/in_app_bot/application/services/chat_operations.dart';
// import 'package:in_app_bot/in_app_bot/features/modes/common/domain/entities/chat_model.dart';
// import 'package:in_app_bot/in_app_bot/features/modes/common/domain/repositories/chat_repository.dart';
// import 'package:in_app_bot/in_app_bot/features/modes/common/domain/repositories/chatbot_config_repository.dart';
// import 'package:in_app_bot/in_app_bot/features/modes/common/utils/parsing_helpers.dart';
// import 'package:in_app_bot/in_app_bot/features/modes/infrastructure/network/pinecone/pinecone_service_config.dart';
// import 'package:in_app_bot/in_app_bot/presentation/providers/chat_notifier.dart';
// import 'package:in_app_bot/in_app_bot/features/modes/infrastructure/network/pinecone/pinecone_query_service.dart';

// part 'send_message_data_plus.g.dart';

// class SendMessageDataPlus {
//   final ChatRepository _chatRepository;
//   final ChatbotConfigRepository _chatbotConfigRepository;
//   final PineconeQueryService _pineconeQueryService;

//   SendMessageDataPlus({
//     required ChatRepository chatRepository,
//     required ChatbotConfigRepository chatbotConfigRepository,
//     required PineconeQueryService pineconeQueryService,
//   })  : _chatRepository = chatRepository,
//         _chatbotConfigRepository = chatbotConfigRepository,
//         _pineconeQueryService = pineconeQueryService;

//   Future<List<ChatModel>> sendMessage({
//     required String message,
//     required String modelId,
//     required String appUserId,
//     required ChatNotifier chatNotifier,
//   }) async {
//     try {
//       final config = await _getChatbotConfig();
//       _addUserMessageToChatList(message);

//       final frequentQuestionResponse =
//           await _checkFrequentDataPlusQuestions(message);

//       if (frequentQuestionResponse != null) {
//         final responseChatList = [
//           ChatModel(msg: frequentQuestionResponse, chatIndex: 1)
//         ];

//         await Future.delayed(const Duration(milliseconds: 200));

//         _addResponseToChatList(responseChatList);
//         _logChatList();
//         await _saveChat(appUserId, chatNotifier.currentChatId!);

//         return responseChatList;
//       }

//       final processedMessage = await _processMessageWithLLM(message, config);
//       _logMessage("Pregunta con contexto enviada a Pinecone", processedMessage);

//       final pineconeResult = await _queryPinecone(processedMessage);
//       final messages =
//           _buildMessagesList(message, processedMessage, pineconeResult, config);

//       final response = await _postChatbotRequest(config, messages);
//       final jsonResponse = _parseResponse(response);

//       final responseChatList = _buildResponseChatList(jsonResponse);
//       _addResponseToChatList(responseChatList);

//       _logChatList();
//       await _saveChat(appUserId, chatNotifier.currentChatId!);

//       return responseChatList;
//     } catch (error) {
//       log("Error: $error");
//       rethrow;
//     }
//   }

//   Future<Map<String, dynamic>> _getChatbotConfig() async {
//     return await _chatbotConfigRepository.getChatbotConfig(
//       collection: 'chatbots',
//       doc: 'data_plus',
//       subCollection: 'config',
//       subDoc: 'openai',
//     );
//   }

//   void _addUserMessageToChatList(String message) {
//     ChatOperationService.chatList.add(ChatModel(msg: message, chatIndex: 0));
//   }

//   Future<String> _processMessageWithLLM(
//       String message, Map<String, dynamic> config) async {
//     if (ChatOperationService.chatList.length <= 1) {
//       return message;
//     }

//     final context = _buildContextForLLM(message);
//     final response = await _postChatbotRequest(config, context);
//     final jsonResponse = _parseResponse(response);

//     return jsonResponse["choices"][0]["message"]["content"];
//   }

//   List<Map<String, String>> _buildContextForLLM(String message) {
//     final context = ChatOperationService.chatList
//         .map((chat) => {
//               "role": chat.chatIndex == 0 ? "user" : "assistant",
//               "content": chat.msg,
//             })
//         .toList();

//     context.add({
//       "role": "system",
//       "content":
//           "You are an AI assistant that helps to provide context and rephrase questions based on previous conversation. Your task is to take the user's latest question and the conversation history, and generate a more specific and contextualized question that can be used for searching in a knowledge base. The rephrased question should be concise and directly related to the information being sought."
//     });

//     context.add({
//       "role": "user",
//       "content":
//           "Basado en las preguntas y respuestas anteriores, proporciona más contexto a esta pregunta o frase del usuario siempre en base a los mensajes anteriores: \"$message\"."
//     });

//     context.add({
//       "role": "user",
//       "content":
//           "Si el último mensaje necesita contexto de acuerdo a los mensajes entre el usuario y el asistente, responde con solo una pregunta que tenga más contexto y nada más."
//     });

//     context.add({
//       "role": "user",
//       "content":
//           "Si el mensaje enviado por el usuario: \"$message\", no necesita contexto, devuélvelo tal cual."
//     });

//     return context;
//   }

//   Future<String> _queryPinecone(String processedMessage) async {
//     return await _pineconeQueryService.performPineconeVectorSearch(
//         PineconeServiceConfig.indexName, processedMessage);
//   }

//   List<Map<String, String>> _buildMessagesList(
//       String originalMessage,
//       String processedMessage,
//       String pineconeResult,
//       Map<String, dynamic> config) {
//     return [
//       {
//         "role": "system",
//         "content":
//             "Responde de este contenido : $pineconeResult. ${config['system']}"
//       },
//       ...ChatOperationService.chatList
//           .map((chat) => {
//                 "role": chat.chatIndex == 0 ? "user" : "assistant",
//                 "content": chat.msg,
//               })
//           .toList(),
//       {"role": "user", "content": "Ultima pregunta: $originalMessage"}
//     ];
//   }

//   bool _isMessageUnique(String message, int chatIndex) {
//     return !ChatOperationService.chatList
//         .any((chat) => chat.msg == message && chat.chatIndex == chatIndex);
//   }

//   Map<String, dynamic> _parseResponse(http.Response response) {
//     final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
//     _validateJsonResponse(jsonResponse);
//     return jsonResponse;
//   }

//   void _addResponseToChatList(List<ChatModel> responseChatList) {
//     for (var chat in responseChatList) {
//       if (_isMessageUnique(chat.msg, 1)) {
//         ChatOperationService.chatList.add(chat);
//       }
//     }
//   }

//   Future<void> _saveChat(String appUserId, String currentChatId) async {
//     await _chatRepository.saveChat(appUserId, currentChatId);
//   }

//   void _logMessage(String title, String message) {
//     print("==== $title ====");
//     print(message);
//     print("===============================");
//   }
// }
