import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/application/services/chatbot_service.dart';
import 'package:in_app_bot/in_app_bot/features/chat_screen/presentation/pages/chat_screen.dart';
import 'package:in_app_bot/in_app_bot/features/chat_screen/presentation/widgets/chat_screen_view.dart';
import 'package:in_app_bot/in_app_bot/features/modes/index_mode/application/services/sendmessagegpt.dart';
import 'package:in_app_bot/in_app_bot/features/user/presentation/providers/user_providers.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/providers.dart';

class ChatScreenState extends ConsumerState<ChatScreen> {
  final GlobalKey columnKey = GlobalKey();
  final GlobalKey chatBodyKey = GlobalKey();
  final GlobalKey messageInputFieldKey = GlobalKey();
  final ChatbotService chatbotService = ChatbotService();
  final SendMessageGptService sendmessagegptService = SendMessageGptService();

  bool isActivecurrentChatState = false;

  ChatScreenState();

  @override
  void initState() {
    super.initState();
    isActivecurrentChatState = true;
    log("appUserId value: ${widget.appUserId}");

    if (widget.appUserId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _saveUser();
      });
    }

    chatbotService.initializeControllers();
  }

  void _saveUser() {
    final userPresenter = ref.read(userPresenterProvider);

    userPresenter.saveUser(widget.appUserId).then((_) {});
  }

  @override
  void dispose() {
    isActivecurrentChatState = false;
    chatbotService.disposeControllers();
    super.dispose();
  }

  void updateSendButtonState(bool isEnabled) {
    final currentState = ref.read(chatUIState);
    ref.read(chatUIState.notifier).state =
        currentState.copyWith(isSendButtonEnabled: isEnabled);
  }

  @override
  Widget build(BuildContext context) {
    log('build de ChatScreen');
    return ChatScreenView(state: this);
  }
}
