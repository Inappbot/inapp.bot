import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/application/services/chatbot_service.dart';
import 'package:in_app_bot/in_app_bot/features/chat_bubble/domain/enums/chat_mode.dart';
import 'package:in_app_bot/in_app_bot/features/chat_bubble/presentation/widgets/chat_mode_provider.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/presentation/utils/update_ui_before_sending.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/utils/focus_utils.dart';
import 'package:in_app_bot/in_app_bot/features/modes/data_plus_mode/pinecone_query/presentation/state/pinecone_query_notifier.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/providers.dart';

class MessageUseCases {
  static Future<void> handlePineconeQuery(
    WidgetRef ref,
    TextEditingController textEditingController,
    State state,
    FocusNode focusNode,
    ScrollController listScrollController,
  ) async {
    final Completer<void> pineconeResponseCompleter = Completer();

    updateUIBeforeSending(ref);
    ref
        .read(chatProvider.notifier)
        .addUserMessage(msg: textEditingController.text);
    delayedScrollAndFocus(state, focusNode, ref, listScrollController);

    ref.read(searchQueryProvider.notifier).fetchPineconeIndexResults(
        textEditingController.text, () => pineconeResponseCompleter.complete());

    textEditingController.clear();
    await pineconeResponseCompleter.future;
  }

  static Future<void> sendMessageBasedOnType(
    WidgetRef ref,
    ChatState chatState,
    ChatbotService chatbotService,
    TextEditingController textEditingController,
    State state,
  ) async {
    switch (chatState.mode) {
      case ChatMode.productMode:
        final params = chatState.params as ProductModeParams;
        await _sendProductGPT(
            params, chatbotService, ref, textEditingController, state);
        break;
      case ChatMode.dataplusMode:
        await _sendPineconeGPT(
            chatbotService, ref, textEditingController, state);
        break;
      case ChatMode.indexMode:
      default:
        final params = chatState.params as IndexModeParams;
        await _sendDefaultGPT(
            params, chatbotService, ref, textEditingController, state);
        break;
    }
  }

  static Future<void> _sendProductGPT(
    ProductModeParams params,
    ChatbotService chatbotService,
    WidgetRef ref,
    TextEditingController textEditingController,
    State state,
  ) async {
    if (!state.mounted) return;
    await chatbotService.sendProductGPT(
      productbotId: params.productbotId,
      productbotName: params.productbotName,
      productbotImageUrl: params.productbotImageUrl,
      productbotDescription: params.productbotDescription,
      ref: ref,
      context: state.context,
      appUserId: params.appUserId,
      textEditingController: textEditingController,
      state: state,
    );
  }

  static Future<void> _sendDefaultGPT(
    IndexModeParams params,
    ChatbotService chatbotService,
    WidgetRef ref,
    TextEditingController textEditingController,
    State state,
  ) async {
    if (!state.mounted) return;
    await chatbotService.sendMessageGPT(
      ref,
      state.context,
      params.appUserId,
      state,
      textEditingController,
    );
  }

  static Future<void> _sendPineconeGPT(
    ChatbotService chatbotService,
    WidgetRef ref,
    TextEditingController textEditingController,
    State state,
  ) async {
    if (!state.mounted) return;
    String lastUserBotMessage =
        ref.read(chatProvider.notifier).userBotMessages.last.msg;
    TextEditingController controller =
        TextEditingController(text: lastUserBotMessage);

    final params = ref.read(chatStateProvider).params as DataplusModeParams;

    await chatbotService.sendPineconeGPT(
      ref: ref,
      context: state.context,
      appUserId: params.appUserId,
      textEditingController: controller,
      state: state,
    );
  }
}
