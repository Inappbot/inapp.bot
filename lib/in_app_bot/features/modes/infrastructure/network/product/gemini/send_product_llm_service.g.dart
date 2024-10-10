part of 'send_product_llm_service.dart';

extension _SendProductLlmServiceExtension on SendProductLlmService {
  Future<List<ChatModel>> _handlePreviousProductAnswer(
      String message,
      String previousProductAnswer,
      String appUserId,
      ChatNotifier chatNotifier,
      String productbotId) async {
    ChatOperationService.chatList.add(ChatModel(msg: message, chatIndex: 0));
    ChatOperationService.chatList
        .add(ChatModel(msg: previousProductAnswer, chatIndex: 1));

    await _saveChatIfValid(chatNotifier.currentChatId, appUserId, productbotId);

    return [ChatModel(msg: previousProductAnswer, chatIndex: 1)];
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

  void _logChatList() {
    log("==== Content of chatList ====");
    for (ChatModel chat in ChatOperationService.chatList) {
      log("${chat.chatIndex == 0 ? "user" : "assistant"}: ${chat.msg}");
    }
    log("==== End of chatList ====");
  }

  Future<void> _saveChatIfValid(
      String? currentChatId, String appUserId, String productbotId) async {
    if (currentChatId != null) {
      final selectedNotification = _ref.read(selectedNotificationProvider);

      if (selectedNotification != null) {
        final notificationId = selectedNotification.id;
        await SaveChatNotificationService().saveChatNotification(
          appUserId,
          currentChatId,
          notificationId,
        );
      } else {
        await SaveChatProductService()
            .saveChatProduct(appUserId, currentChatId, productbotId);
      }
    }
  }
}
