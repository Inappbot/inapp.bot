import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/application/services/chatbot_service.dart';
import 'package:in_app_bot/in_app_bot/features/chat_body/widgets/chat_body_widgets.dart';
import 'package:in_app_bot/in_app_bot/features/modes/index_mode/application/services/sendmessagegpt.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/providers.dart';

class ChatBodyWidget extends ConsumerWidget {
  final String productbotId;
  final String productbotName;
  final String productbotImageUrl;
  final String productbotDescription;
  final String appUserId;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final SendMessageGptService sendmessagegptService;
  final ChatbotService chatbotService;
  final ScrollController listScrollController;
  final GlobalKey columnKey;

  const ChatBodyWidget({
    Key? key,
    required this.productbotId,
    required this.productbotName,
    required this.productbotImageUrl,
    required this.productbotDescription,
    required this.appUserId,
    required this.textEditingController,
    required this.focusNode,
    required this.sendmessagegptService,
    required this.chatbotService,
    required this.listScrollController,
    required this.columnKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('build de ChatBodyWidget');
    final chatMessages = ref.watch(chatProvider);
    final isLoading = ref.watch(chatLoadingProvider);
    final shouldShrinkAppBar = ref.watch(chatUIState).shouldShrinkAppBar;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: listScrollController,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  updateUIStateIfNeeded(ref, columnKey);
                });
                return Column(
                  key: columnKey,
                  children: buildChatContent(
                      chatMessages,
                      productbotName,
                      shouldShrinkAppBar,
                      ref,
                      context,
                      isLoading,
                      listScrollController,
                      productbotImageUrl,
                      productbotDescription,
                      textEditingController,
                      appUserId,
                      chatbotService,
                      sendmessagegptService,
                      productbotId),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void updateUIStateIfNeeded(WidgetRef ref, GlobalKey columnKey) {
    final RenderBox? columnBox =
        columnKey.currentContext?.findRenderObject() as RenderBox?;
    if (columnBox != null) {
      final double columnHeight = columnBox.size.height;
      final currentState = ref.read(chatUIState);
      if ((columnHeight > 400 && !currentState.shouldShrinkAppBar) ||
          (columnHeight <= 400 && currentState.shouldShrinkAppBar)) {
        ref.read(chatUIState.notifier).state =
            currentState.copyWith(shouldShrinkAppBar: columnHeight > 400);
      }
    }
  }
}
