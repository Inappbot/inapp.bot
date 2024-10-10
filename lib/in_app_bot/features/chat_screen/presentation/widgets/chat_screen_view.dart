import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/application/services/chat_operations.dart';
import 'package:in_app_bot/in_app_bot/core/themes/default_theme.dart';
import 'package:in_app_bot/in_app_bot/features/appbar/presentation/widgets/custom_app_bar.dart';
import 'package:in_app_bot/in_app_bot/features/chat_body/widgets/chat_body_widget.dart';
import 'package:in_app_bot/in_app_bot/features/chat_input/presentation/widgets/message_input_field_widget.dart';
import 'package:in_app_bot/in_app_bot/features/chat_screen/presentation/pages/chat_screen_state.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/providers.dart';
import 'package:in_app_bot/in_app_bot/presentation/utils/chat_helpers.dart';

class ChatScreenView extends StatelessWidget {
  final ChatScreenState state;

  const ChatScreenView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    final ThemeData themeData = isDarkMode ? AppTheme.dark() : AppTheme.light();

    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Theme(
          data: themeData,
          child: Scaffold(
            appBar: _BuildAppBar(state),
            body: Column(
              children: [
                Expanded(
                  child: _BuildChatBody(state),
                ),
                const SizedBox(height: 15),
                SafeArea(
                  child: _BuildMessageInpuField(state),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildMessageInpuField extends StatelessWidget {
  const _BuildMessageInpuField(this.state);
  final ChatScreenState state;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: state.messageInputFieldKey,
      child: MessageInputFieldWidget(
        textEditingController: state.chatbotService.textEditingController,
        chatbotService: state.chatbotService,
        listScrollController: state.chatbotService.listScrollController,
      ),
    );
  }
}

class _BuildChatBody extends StatelessWidget {
  const _BuildChatBody(this.state);
  final ChatScreenState state;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: state.chatBodyKey,
      child: ChatBodyWidget(
        productbotId: state.widget.productbotId,
        productbotName: state.widget.productbotName,
        productbotImageUrl: state.widget.productbotImageUrl,
        productbotDescription: state.widget.productbotDescription,
        appUserId: state.widget.appUserId,
        chatbotService: state.chatbotService,
        sendmessagegptService: state.sendmessagegptService,
        textEditingController: state.chatbotService.textEditingController,
        focusNode: state.chatbotService.focusNode,
        listScrollController: state.chatbotService.listScrollController,
        columnKey: state.columnKey,
      ),
    );
  }
}

class _BuildAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const _BuildAppBar(this.state);
  final ChatScreenState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProvider);
    final chatUIStateValue = ref.watch(chatUIState);
    final isTyping = chatUIStateValue.isTyping;
    final shouldShrinkAppBar = chatUIStateValue.shouldShrinkAppBar;
    return CustomAppBar(
      chatState: chatState,
      shouldShrinkAppBar: shouldShrinkAppBar,
      productbotName: state.widget.productbotName,
      productbotId: state.widget.productbotId,
      isTyping: isTyping,
      appUserId: state.widget.appUserId,
      clearChat: () {
        clearChatAndMessageParts(ref);
        ChatOperationService.clearChatList();
      },
      isTtsActive: state.ref.watch(chatUIState).isTtsActive,
      handlePauseInSpeech: state.widget.handlePauseInSpeech ?? () {},
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(200);
}
