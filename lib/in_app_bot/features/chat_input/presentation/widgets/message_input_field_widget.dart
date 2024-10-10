import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/application/services/chatbot_service.dart';
import 'package:in_app_bot/in_app_bot/features/chat_bubble/domain/enums/chat_mode.dart';
import 'package:in_app_bot/in_app_bot/features/chat_bubble/presentation/widgets/chat_mode_provider.dart';
import 'package:in_app_bot/in_app_bot/features/chat_input/application/providers/hint_notifier.dart';
import 'package:in_app_bot/in_app_bot/features/chat_input/application/providers/knowledge_provider.dart';
import 'package:in_app_bot/in_app_bot/features/chat_input/application/providers/message_sent_recently_provider.dart';
import 'package:in_app_bot/in_app_bot/features/chat_input/application/providers/send_button_state_provider.dart';
import 'package:in_app_bot/in_app_bot/features/chat_input/application/use_cases/message_use_cases.dart';
import 'package:in_app_bot/in_app_bot/features/chat_input/presentation/widgets/knowledge_base_widget.dart';
import 'package:in_app_bot/in_app_bot/features/index_frequent_messages/application/notifiers/message_input_notifier.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/providers.dart';

class MessageInputFieldWidget extends ConsumerStatefulWidget {
  final TextEditingController textEditingController;
  final ScrollController listScrollController;
  final ChatbotService chatbotService;

  const MessageInputFieldWidget({
    Key? key,
    required this.textEditingController,
    required this.listScrollController,
    required this.chatbotService,
  }) : super(key: key);

  @override
  MessageInputFieldState createState() => MessageInputFieldState();
}

class MessageInputFieldState extends ConsumerState<MessageInputFieldWidget> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && ref.read(showKnowledgeBaseProvider)) {
      ref.read(showKnowledgeBaseProvider.notifier).state = false;
    }
    ref.read(hintProvider.notifier).setShowHint(!_focusNode.hasFocus);
  }

  Future<void> _sendMessage(String? text) async {
    final canSent = ref.read(sendButtonStateProvider);
    if (canSent) return;

    final messageToSend = text ?? widget.textEditingController.text;
    if (messageToSend.isEmpty) return;

    _updateButtonState(true);

    final chatState = ref.read(chatStateProvider);

    if (chatState.mode == ChatMode.dataplusMode) {
      await MessageUseCases.handlePineconeQuery(
        ref,
        widget.textEditingController,
        this,
        _focusNode,
        widget.listScrollController,
      );
    }

    await MessageUseCases.sendMessageBasedOnType(
      ref,
      chatState,
      widget.chatbotService,
      widget.textEditingController,
      this,
    );
    _resetButtonStateAfterDelay();
    _resetMessageSentFlagAfterDelay();
  }

  void _updateButtonState(bool newState) {
    ref.read(sendButtonStateProvider.notifier).updateState(newState);
    ref.read(sendButtonEnabledProvider.notifier).state = false;
  }

  void _resetButtonStateAfterDelay() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        ref.read(sendButtonStateProvider.notifier).updateState(false);
      }
    });
  }

  void _resetMessageSentFlagAfterDelay() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        ref.read(messageSentRecentlyProvider.notifier).updateState(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSendButtonEnabled = ref.watch(sendButtonEnabledProvider);
    final showHint = ref.watch(hintProvider);

    ref.listen<String>(messageInputProvider, (_, newMessage) {
      if (newMessage.isNotEmpty) {
        widget.textEditingController.text = newMessage;

        _sendMessage(newMessage);
      }
    });

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const KnowledgeBaseWidget(),
            AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: showHint ? 100 : 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: const Color.fromARGB(255, 231, 230, 230),
                    width: 1,
                  ),
                ),
                child: (showHint)
                    ? AnimatedOpacity(
                        opacity: showHint ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: GestureDetector(
                          onTap: () {
                            ref.read(hintProvider.notifier).setShowHint(false);
                            _focusNode.requestFocus();
                          },
                          child: Consumer(
                            builder: (context, ref, _) {
                              final chatList = ref.watch(chatProvider);
                              final isChatActive = chatList.isNotEmpty;

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isChatActive
                                        ? "I'm here to help you."
                                        : "Hello, I'm here to help you.",
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 58, 58, 58),
                                      fontSize: 18,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    isChatActive
                                        ? "Type here to continue the conversation."
                                        : "Type here",
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 68, 68, 68),
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      )
                    : AnimatedOpacity(
                        opacity: showHint ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                focusNode: _focusNode,
                                style: const TextStyle(color: Colors.black87),
                                controller: widget.textEditingController,
                                onChanged: (text) {
                                  ref
                                      .read(sendButtonEnabledProvider.notifier)
                                      .state = text.trim().isNotEmpty;
                                },
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 5,
                                textInputAction: TextInputAction.newline,
                                onSubmitted: (text) async {
                                  await _sendMessage(text);
                                },
                                decoration: InputDecoration(
                                  hintText: "Type your question here...",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                ),
                              ),
                            ),
                            AnimatedOpacity(
                              opacity: isSendButtonEnabled ? 1.0 : 0.5,
                              duration: const Duration(milliseconds: 200),
                              child: GestureDetector(
                                onTap: isSendButtonEnabled
                                    ? () async {
                                        await _sendMessage(
                                            widget.textEditingController.text);
                                      }
                                    : null,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSendButtonEnabled
                                        ? Colors.blue
                                        : Colors.grey[300],
                                  ),
                                  child: const Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
          ],
        ),
      ),
    );
  }
}
