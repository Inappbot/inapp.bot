import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/presentation/providers/modes_providers.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/presentation/utils/update_ui_before_sending.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/utils/focus_utils.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/utils/message_error_handler.dart';
import 'package:in_app_bot/in_app_bot/features/modes/index_mode/application/services/sendmessagegpt.dart';
import 'package:in_app_bot/in_app_bot/features/text_to_speech/presentation/utils/bot_message_handler.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/providers.dart';

Future<void> sendMessageGPTImpl({
  required WidgetRef ref,
  required BuildContext context,
  required String appUserId,
  required State state,
  required TextEditingController textEditingController,
  required FocusNode focusNode,
  required ScrollController listScrollController,
  required SendMessageGptService sendmessagegptService,
}) async {
  final isTyping = ref.watch(chatUIState).isTyping;
  final chatNotifier = ref.read(chatProvider.notifier);

  if (await _preSendMessageCheck(
    sendmessagegptService,
    isTyping,
    textEditingController.text,
    context,
  )) {
    return;
  }

  try {
    final msg = _prepareMessage(textEditingController);
    final models = await _fetchModels(sendmessagegptService);

    if (models['listModel'] == null || models['currentModel'] == null) {
      throw Exception('Model configuration is missing');
    }

    _prepareUIForSending(
        ref, textEditingController, state, focusNode, listScrollController);

    final documentNumbers = await _sendFirstMessage(
      chatNotifier,
      msg,
      models['listModel']!,
      appUserId,
      ref,
    );

    await _sendSecondMessage(
      chatNotifier,
      msg,
      documentNumbers,
      models['currentModel']!,
      appUserId,
      ref,
    );

    _finalizeSending(ref, state, focusNode, listScrollController);
  } catch (e) {
    if (state.mounted) {
      handleSendMessageError(e as Exception, context);
    }
  } finally {
    resetUIState(ref, state);
  }
}

Future<bool> _preSendMessageCheck(
  SendMessageGptService service,
  bool isTyping,
  String text,
  BuildContext context,
) async {
  log("sendMessageGPT has been called with the message: ${text.trim()}");
  return await service.preSendMessageCheck(isTyping, text, context);
}

String _prepareMessage(TextEditingController textEditingController) {
  return textEditingController.text.trim();
}

Future<Map<String, String?>> _fetchModels(SendMessageGptService service) async {
  final chatbotConfig = await service.getConfig('chatbot');
  final listChatbotConfig = await service.getConfig('list_chatbot');

  return {
    'currentModel': chatbotConfig["model"],
    'listModel': listChatbotConfig["list_model"],
  };
}

void _prepareUIForSending(
  WidgetRef ref,
  TextEditingController textEditingController,
  State state,
  FocusNode focusNode,
  ScrollController listScrollController,
) {
  updateUIBeforeSending(ref);
  textEditingController.clear();
  delayedScrollAndFocus(state, focusNode, ref, listScrollController);
}

Future<List<String>> _sendFirstMessage(
  dynamic chatNotifier,
  String msg,
  String listModel,
  String appUserId,
  WidgetRef ref,
) async {
  return await chatNotifier.sendFirstMessageAndGetResponse(
    msg: msg,
    firstModelId: listModel,
    appUserId: appUserId,
    chatNotifier: chatNotifier,
    ref: ref,
  );
}

Future<void> _sendSecondMessage(
  dynamic chatNotifier,
  String msg,
  List<String> documentNumbers,
  String currentModel,
  String appUserId,
  WidgetRef ref,
) async {
  await chatNotifier.sendSecondMessageAndGetResponse(
    msg: msg,
    documentNumbers: documentNumbers,
    chosenModelId: currentModel,
    appUserId: appUserId,
    chatNotifier: chatNotifier,
  );
}

void _finalizeSending(
  WidgetRef ref,
  State state,
  FocusNode focusNode,
  ScrollController listScrollController,
) {
  handleBotMessage(ref);
  delayedScrollAndFocus(state, focusNode, ref, listScrollController);
}
