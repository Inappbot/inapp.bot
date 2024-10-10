import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/application/services/chatbot_service.dart';
import 'package:in_app_bot/in_app_bot/features/chat_body/presentation/utils/message_processor.dart';
import 'package:in_app_bot/in_app_bot/features/chat_body/providers/parts_notifier_provider.dart';
import 'package:in_app_bot/in_app_bot/features/chat_body/widgets/assistant_response_widget.dart';
import 'package:in_app_bot/in_app_bot/features/chat_body/widgets/user_message_widget.dart';
import 'package:in_app_bot/in_app_bot/features/chat_bubble/domain/enums/chat_mode.dart';
import 'package:in_app_bot/in_app_bot/features/chat_bubble/presentation/widgets/chat_mode_provider.dart';
import 'package:in_app_bot/in_app_bot/features/index_frequent_messages/presentation/pages/frequent_messages_widget.dart';
import 'package:in_app_bot/in_app_bot/features/modes/index_mode/application/services/sendmessagegpt.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/open_notifications/presentation/widgets/i_notification_widget.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/presentation/state/notification_providers.dart';

List<Widget> buildChatContent(
  dynamic chatMessages,
  String productbotName,
  bool shouldShrinkAppBar,
  WidgetRef ref,
  BuildContext context,
  bool isLoading,
  ScrollController listScrollController,
  String productbotImageUrl,
  String productbotDescription,
  TextEditingController textEditingController,
  String appUserId,
  ChatbotService chatbotService,
  SendMessageGptService sendmessagegptService,
  String productbotId,
) {
  final widgets = <Widget>[];
  final chatState = ref.watch(chatStateProvider);
  final selectedNotification = ref.watch(selectedNotificationProvider);

  WidgetsBinding.instance.addPostFrameCallback(
    (_) {
      if (selectedNotification != null &&
          chatState.mode != ChatMode.productMode) {
        ref.read(chatStateProvider.notifier).setMode(
              ChatMode.productMode,
              ProductModeParams(
                appUserId: appUserId,
                productbotId: '',
                productbotName: '',
                productbotImageUrl: '',
                productbotDescription: '',
              ),
            );
      }
    },
  );

  if (selectedNotification != null) {
    widgets.add(INotificationWidget(notification: selectedNotification));
    widgets.add(const SizedBox(height: 16));
  } else {
    switch (chatState.mode) {
      case ChatMode.productMode:
        if (productbotName.isNotEmpty) {
          widgets.addAll(buildProductbotSection(
              productbotName,
              productbotImageUrl,
              productbotDescription,
              context,
              textEditingController,
              appUserId,
              chatbotService,
              sendmessagegptService,
              ref));
        }
        break;
      case ChatMode.indexMode:
      case ChatMode.dataplusMode:
      case ChatMode.scanaimode:
      case null:
        if (chatMessages.isEmpty) {
          widgets.addAll(buildEmptyStateSection(context, textEditingController,
              appUserId, chatbotService, ref, sendmessagegptService));
        }
        break;
    }
  }

  widgets.add(buildMessagesListView(
      chatMessages, ref, context, isLoading, listScrollController));

  return widgets;
}

List<Widget> buildProductbotSection(
  String productbotName,
  String productbotImageUrl,
  String productbotDescription,
  BuildContext context,
  TextEditingController textEditingController,
  String appUserId,
  ChatbotService chatbotService,
  SendMessageGptService sendmessagegptService,
  WidgetRef ref,
) {
  return [
    const SizedBox(height: 18),
    buildProductbotMessage(
        productbotName,
        productbotImageUrl,
        productbotDescription,
        context,
        textEditingController,
        appUserId,
        chatbotService,
        ref,
        sendmessagegptService),
    const SizedBox(height: 5),
  ];
}

Widget buildProductbotMessage(
    String productbotName,
    String productbotImageUrl,
    String productbotDescription,
    BuildContext context,
    TextEditingController textEditingController,
    String appUserId,
    ChatbotService chatbotService,
    WidgetRef ref,
    SendMessageGptService sendmessagegptService) {
  return GestureDetector(
    onTap: () {
      showFrequentMessagesBottomSheet(context, textEditingController, appUserId,
          chatbotService, ref, sendmessagegptService);
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 66, 66, 66).withOpacity(0.3),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: const Color.fromARGB(0, 162, 162, 162),
                          width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.network(
                        productbotImageUrl,
                        fit: BoxFit.scaleDown,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.grey[400]!),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color.fromARGB(255, 67, 67, 67)
                              .withOpacity(0.3),
                          child: const Icon(Icons.error,
                              color: Color.fromARGB(255, 62, 62, 62)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          productbotName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 58, 58, 58),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'What would you like to know about this product ?',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 68, 68, 68),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

List<Widget> buildEmptyStateSection(
  BuildContext context,
  TextEditingController textEditingController,
  String appUserId,
  ChatbotService chatbotService,
  WidgetRef ref,
  SendMessageGptService sendmessagegptService,
) {
  return [
    const SizedBox(height: 25),
    buildFrequentMessagesButton(context, textEditingController, appUserId,
        chatbotService, ref, sendmessagegptService),
    const SizedBox(height: 15),
  ];
}

Widget buildFrequentMessagesButton(
  BuildContext context,
  TextEditingController textEditingController,
  String appUserId,
  ChatbotService chatbotService,
  WidgetRef ref,
  SendMessageGptService sendmessagegptService,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    child: GestureDetector(
      onTap: () {
        showFrequentMessagesBottomSheet(context, textEditingController,
            appUserId, chatbotService, ref, sendmessagegptService);
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 47, 47, 47),
              Color.fromARGB(255, 46, 46, 46)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Stack(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Frequent Messages',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildMessagesListView(
    dynamic chatMessages,
    WidgetRef ref,
    BuildContext context,
    bool isLoading,
    ScrollController listScrollController) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: chatMessages.length,
    itemBuilder: (context, index) {
      return buildMessageItem(chatMessages[index], index, ref, context,
          isLoading, listScrollController);
    },
  );
}

Widget buildMessageItem(
    dynamic chatMessage,
    int index,
    WidgetRef ref,
    BuildContext context,
    bool isLoading,
    ScrollController listScrollController) {
  List<Widget> messageParts = ref.watch(messagePartsProvider)[index] ?? [];
  int chatIndex = chatMessage.chatIndex;
  String msg = chatMessage.msg;

  if (messageParts.isEmpty) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      processMessage(msg, context, ref, isLoading, index);
    });
    return const SizedBox.shrink();
  }

  return chatIndex == 1 && messageParts.isNotEmpty
      ? AssitantResponseWidget(
          messageParts: messageParts,
          index: index,
        )
      : UserMessageWidget(
          scrollController: listScrollController,
          msg: msg,
          chatIndex: chatIndex,
        );
}
