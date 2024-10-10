import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/usecases/get_config_use_case.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/presentation/utils/update_ui_before_sending.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/utils/focus_utils.dart';
import 'package:in_app_bot/in_app_bot/features/modes/product_mode/data/datasources/config_data_source.dart';
import 'package:in_app_bot/in_app_bot/features/text_to_speech/presentation/utils/bot_message_handler.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/providers.dart';

final getConfigUseCase = GetConfigUseCase(ConfigDataSource());

Future<void> performMessageSendingPinecone({
  required WidgetRef ref,
  required BuildContext context,
  required String appUserId,
  required String msg,
  required State state,
  required TextEditingController textEditingController,
  required FocusNode focusNode,
  required ScrollController listScrollController,
}) async {
  final chatNotifier = ref.read(chatProvider.notifier);
  final chatbotConfig = await getConfigUseCase.execute('chatbot_products');
  final currentModel = chatbotConfig.data["model"];

  _prepareUIForSending(
      ref, textEditingController, state, focusNode, listScrollController);

  await chatNotifier.sendMessageAndGetResponsePinecone(
    msg: msg,
    chosenModelId: currentModel,
    appUserId: appUserId,
    chatNotifier: chatNotifier,
    ref: ref,
  );

  _finalizeMessageSending(ref, state, focusNode, listScrollController);
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
}

void _finalizeMessageSending(
  WidgetRef ref,
  State state,
  FocusNode focusNode,
  ScrollController listScrollController,
) {
  handleBotMessage(ref);
  delayedScrollAndFocus(state, focusNode, ref, listScrollController);
}
