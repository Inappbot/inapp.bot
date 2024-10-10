import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:in_app_bot/in_app_bot/application/services/chat_operations.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/entities/chat_model.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/repositories/chat_repository.dart';
import 'package:in_app_bot/in_app_bot/features/modes/infrastructure/network/pinecone/pinecone_query_service.dart';
import 'package:in_app_bot/in_app_bot/features/modes/infrastructure/network/pinecone/pinecone_service_config.dart';
import 'package:in_app_bot/in_app_bot/features/modes/infrastructure/data/services/gemini_api_service.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/chat_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'send_message_data_plus_gemini.g.dart';

class StopwordsHandler {
  // This has 1298 words for cleaning the query sent to Pinecone
  Set<String> stopwords = {};

  Future<void> loadStopwords() async {
    final String jsonString =
        await rootBundle.loadString('assets/stopwords/stopwords-en.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    stopwords = Set<String>.from(jsonList.cast<String>());
  }

  String removeStopwords(String text) {
    List<String> words = text.split(' ');
    words =
        words.where((word) => !stopwords.contains(word.toLowerCase())).toList();
    return words.join(' ');
  }
}

class SendMessageDataPlus {
  final ChatRepository _chatRepository;
  final PineconeQueryService _pineconeQueryService;
  final WidgetRef _ref;
  late GenerativeModel _model;
  final StopwordsHandler _stopwordsHandler = StopwordsHandler();
  final Completer<void> _initializationCompleter = Completer<void>();

  SendMessageDataPlus({
    required ChatRepository chatRepository,
    required PineconeQueryService pineconeQueryService,
    required WidgetRef ref,
  })  : _chatRepository = chatRepository,
        _pineconeQueryService = pineconeQueryService,
        _ref = ref {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _stopwordsHandler.loadStopwords();
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

  void _addUserMessageToChatList(String message) {
    ChatOperationService.chatList.add(ChatModel(msg: message, chatIndex: 0));
  }

  Future<String> _processMessageWithLLM(String message) async {
    await _ensureInitialized();

    if (ChatOperationService.chatList.length <= 1) {
      return _stopwordsHandler.removeStopwords(message);
    }

    final context = _buildContextForLLM(message);
    final chatSession = _model.startChat(history: context);

    final response = await chatSession.sendMessage(Content.model([
      TextPart('''
CRITICAL INSTRUCTIONS - FOLLOW THESE RULES WITHOUT EXCEPTION:
1. DO NOT provide explanations, comments, or reasoning about the process.
2. DO NOT substantially modify the user's original message.
3. If the message requires context, add ONLY the minimum necessary information, preferably at the beginning of the message.
4. If the message does not require context, return it exactly as is.
5. DO NOT use placeholders like "[entity name]". If you don't have the specific information, don't add it.
6. Respond ONLY with the final message, without additional prefixes, suffixes, or tags.
7. ALWAYS provide the response in English, regardless of the input language.
''')
    ]));

    String processedMessage = response.text ?? message;
    processedMessage = _stopwordsHandler.removeStopwords(processedMessage);

    _logMessage("Pregunta limpia enviada a Pinecone", processedMessage);

    return processedMessage;
  }

  Future<void> _ensureInitialized() async {
    if (!_initializationCompleter.isCompleted) {
      await _initializationCompleter.future;
    }
  }

  List<Content> _buildContextForLLM(String currentMessage) {
    List<Content> context = [];
    List<ChatModel> chatList = ChatOperationService.chatList;

    String conversationHistory =
        "CONVERSATION HISTORY (INTERNAL REFERENCE, DO NOT PRINT, ONLY USE THE REFERENCE TO CREATE THE CONTEXT):\n\n";

    for (int i = 0; i < chatList.length; i++) {
      conversationHistory +=
          "${chatList[i].chatIndex == 0 ? 'U' : 'A'}: ${chatList[i].msg}\n";
    }

    conversationHistory += "\nCURRENT MESSAGE: $currentMessage\n";

    context.add(Content.text(conversationHistory));

    context.add(Content.text('''
CONTEXT PROCESSING INSTRUCTIONS:

1. OBJECTIVE: Provide the minimum necessary context for an effective database search, based on the current message and conversation history.

2. GENERAL RULES:
   - DO NOT include the full history in the response.
   - DO NOT use tags or prefixes in the response.
   - DO NOT repeat the user's message verbatim.
   - DO NOT provide explanations about the process.
   - ALWAYS formulate the response in English, regardless of the input language.

3. MESSAGE PROCESSING:
   a) If the message is a simple social interaction (greeting, thanks, farewell):
      - Return the message without modifications, translated to English if necessary.
   b) If the message requires information from the previous context:
      - Extract and synthesize only the relevant information from the history.
      - Combine this information with the current message concisely, in English.
   c) If the message introduces a new topic or question:
      - Provide only the minimum context necessary to understand the query, in English.
   d) If the message is ambiguous or unclear:
      - Try to clarify based on the previous context, if relevant.
      - If there is no relevant context, return the message with an indication of ambiguity, in English.

4. RESPONSE FORMAT:
   - Respond with a brief sentence or paragraph in English that captures the essence of the query with the necessary context.
   - Keep the response concise and direct.

IMPORTANT: The response should be useful for a database search, without being a direct answer to the user. Ensure all responses are in English.

RESPOND ONLY WITH THE PROCESSED CONTEXT OR THE ORIGINAL MESSAGE MODIFIED ACCORDING TO THE ABOVE INSTRUCTIONS, ALWAYS IN ENGLISH.
'''));

    return context;
  }

  Future<String> _queryPinecone(String processedMessage) async {
    return await _pineconeQueryService.performPineconeVectorSearch(
        PineconeServiceConfig.indexName, processedMessage);
  }

  List<Content> _buildChatHistory() {
    List<Content> history = [];
    for (int i = 0; i < ChatOperationService.chatList.length; i++) {
      ChatModel chat = ChatOperationService.chatList[i];
      if (chat.chatIndex == 0) {
        history.add(Content.text(chat.msg));
      } else {
        history.add(Content.model([TextPart(chat.msg)]));
      }
    }
    return history;
  }

  List<ChatModel> _buildResponseChatList(GenerateContentResponse response) {
    return response.text != null
        ? [ChatModel(msg: response.text!, chatIndex: 1)]
        : [];
  }

  void _addResponseToChatList(List<ChatModel> responseChatList) {
    for (var chat in responseChatList) {
      if (_isMessageUnique(chat.msg, 1)) {
        ChatOperationService.chatList.add(chat);
      }
    }
  }

  bool _isMessageUnique(String message, int chatIndex) {
    return !ChatOperationService.chatList
        .any((chat) => chat.msg == message && chat.chatIndex == chatIndex);
  }

  Future<void> _saveChat(String appUserId, String currentChatId) async {
    await _chatRepository.saveChat(appUserId, currentChatId);
  }

  void _logMessage(String title, String message) {
    log("==== $title ====");
    log(message);
    log("===============================");
  }

  void _logChatList() {
    _logMessage("Contenido de chatList", "");
    for (ChatModel chat in ChatOperationService.chatList) {
      _logMessage(chat.chatIndex == 0 ? "user" : "model", chat.msg);
    }
    _logMessage("Fin de chatList", "");
  }

  Future<String?> _checkFrequentDataPlusQuestions(String message) async {
    final CollectionReference collection = FirebaseFirestore.instance
        .collection('chatbots')
        .doc('data_plus')
        .collection('data_plus_previous_responses');

    final QuerySnapshot snapshot = await collection.get();

    for (var doc in snapshot.docs) {
      try {
        if (doc.get('frequency_message') == true &&
            _isQuestionSimilar(doc.get('question'), message)) {
          return doc.get('response');
        }
      } catch (e) {
        log("Error obteniendo campos del documento: $e");
      }
    }

    return null;
  }

  bool _isQuestionSimilar(String dbQuestion, String userQuestion) {
    return dbQuestion.toLowerCase() == userQuestion.toLowerCase();
  }

  List<ChatModel> _handleFrequentQuestion(
      String response, String appUserId, ChatNotifier chatNotifier) {
    final responseChatList = [ChatModel(msg: response, chatIndex: 1)];
    _addResponseToChatList(responseChatList);
    _logChatList();
    _saveChat(appUserId, chatNotifier.currentChatId!);
    return responseChatList;
  }
}
