import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/text_to_speech/presentation/providers/tts_provider.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/providers.dart';

void handleBotMessage(WidgetRef ref) {
  var currentChatState = ref.watch(chatProvider);
  var isTtsActive = ref.watch(chatUIState).isTtsActive;

  if (isTtsActive && currentChatState.isNotEmpty) {
    final ttsHelper = ref.read(ttsHelperProvider.notifier);

    String lastMessage = currentChatState.last.msg;
    log("Last message from the bot: $lastMessage");

    ttsHelper.speak(lastMessage);
  }
}
