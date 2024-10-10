import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/application/services/chat_operations.dart';
import 'package:in_app_bot/in_app_bot/domain/services/send_services.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/entities/chat_model.dart';

class ChatNotifier extends StateNotifier<List<ChatModel>> {
  String? currentChatId;
  String? appUserId;
  List<ChatModel> userBotMessages = [];

  ChatNotifier() : super([]) {
    _generateNewChatId();
  }

  void _generateNewChatId() {
    currentChatId = ChatOperationService.generateChatId();
  }

  List<ChatModel> get chatList => state;

  void _addMessageToStateAndUserBotMessages(ChatModel chatModel) {
    state = [...state, chatModel];
    userBotMessages = [...userBotMessages, chatModel];
  }

  void addUserMessage({required String msg}) {
    _addMessageToStateAndUserBotMessages(ChatModel(msg: msg, chatIndex: 0));
  }

  void addChat(ChatModel chat) {
    _addMessageToStateAndUserBotMessages(chat);
  }

  void addChatList(List<ChatModel> chatList) {
    for (var chat in chatList) {
      _addMessageToStateAndUserBotMessages(chat);
    }
  }

  Future<void> _addBotMessageToStateAndUserBotMessages(String msg) async {
    await Future.delayed(const Duration(milliseconds: 600));
    ChatModel chatModel = ChatModel(msg: msg, chatIndex: 1);
    _addMessageToStateAndUserBotMessages(chatModel);
  }

  Future<List<String>> sendFirstMessageAndGetResponse({
    required String msg,
    required String firstModelId,
    required String appUserId,
    required ChatNotifier chatNotifier,
    required WidgetRef ref,
  }) async {
    addUserMessage(msg: msg);

    return SendServices.sendFirstMessageAndGetResponse(
      msg: msg,
      firstModelId: firstModelId,
      addBotMessageCallback: _addBotMessageToStateAndUserBotMessages,
      appUserId: appUserId,
      chatNotifier: chatNotifier,
      ref: ref,
    );
  }

  Future<void> sendSecondMessageAndGetResponse({
    required String msg,
    required List<String> documentNumbers,
    required String chosenModelId,
    required String appUserId,
    required ChatNotifier chatNotifier,
  }) async {
    await SendServices.sendSecondMessageAndGetResponse(
      msg: msg,
      documentNumbers: documentNumbers,
      chosenModelId: chosenModelId,
      appUserId: appUserId,
      chatNotifier: chatNotifier,
      addBotMessagesCallback: (messages) {
        for (var message in messages) {
          _addMessageToStateAndUserBotMessages(message);
        }
      },
    );
  }

  Future<List<ChatModel>> sendMessageAndGetResponse({
    required String msg,
    required String chosenModelId,
    required String productbotId,
    required String productbotName,
    required String productbotImageUrl,
    required String productbotDescription,
    required String appUserId,
    required ChatNotifier chatNotifier,
    required WidgetRef ref,
  }) async {
    addUserMessage(msg: msg);
    List<ChatModel> responseMessages =
        await SendServices.sendMessageAndGetProductResponse(
      message: msg,
      modelId: chosenModelId,
      productbotId: productbotId,
      productbotName: productbotName,
      productbotImageUrl: productbotImageUrl,
      productbotDescription: productbotDescription,
      appUserId: appUserId,
      chatNotifier: chatNotifier,
      ref: ref,
    );
    for (var message in responseMessages) {
      _addMessageToStateAndUserBotMessages(message);
    }
    return responseMessages;
  }

  Future<List<ChatModel>> sendMessageAndGetResponsePinecone({
    required String msg,
    required String chosenModelId,
    required String appUserId,
    required ChatNotifier chatNotifier,
    required WidgetRef ref,
  }) async {
    List<ChatModel> responseMessages =
        await SendServices.sendMessageAndGetPineconeResponse(
      message: msg,
      modelId: chosenModelId,
      appUserId: appUserId,
      chatNotifier: chatNotifier,
      ref: ref,
    );
    for (var message in responseMessages) {
      _addMessageToStateAndUserBotMessages(message);
    }
    return responseMessages;
  }

  void clearChatList() {
    _generateNewChatId();
    state = [];
    userBotMessages = [];
  }
}
