import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/application/services/chatbot_service.dart';
import 'package:in_app_bot/in_app_bot/features/index_frequent_messages/application/notifiers/search_notifier.dart';
import 'package:in_app_bot/in_app_bot/features/index_frequent_messages/presentation/states/frequent_messages_state.dart';
import 'package:in_app_bot/in_app_bot/features/modes/index_mode/application/services/sendmessagegpt.dart';

class FrequentMessagesWidget extends ConsumerStatefulWidget {
  final TextEditingController textEditingController;
  final ChatbotService chatbotService;
  final WidgetRef ref;
  final SendMessageGptService sendmessagegptService;
  final String appUserId;
  final BuildContext context;

  const FrequentMessagesWidget({
    super.key,
    required this.textEditingController,
    required this.appUserId,
    required this.sendmessagegptService,
    required this.chatbotService,
    required this.ref,
    required this.context,
  });

  @override
  FrequentMessagesWidgetState createState() => FrequentMessagesWidgetState();
}

void showFrequentMessagesBottomSheet(
    BuildContext context,
    TextEditingController textEditingController,
    String appUserId,
    ChatbotService chatbotService,
    WidgetRef ref,
    SendMessageGptService sendmessagegptService) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.2),
    builder: (context) {
      return PopScope(
        onPopInvoked: (didPop) {
          ref.read(searchProvider.notifier).updateSearch('');
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: FrequentMessagesWidget(
              textEditingController: textEditingController,
              appUserId: appUserId,
              ref: ref,
              context: context,
              sendmessagegptService: sendmessagegptService,
              chatbotService: chatbotService,
            ),
          ),
        ),
      );
    },
  ).whenComplete(() {
    // Reset search state when modal is closed
    ref.read(searchProvider.notifier).updateSearch('');
  });
}
