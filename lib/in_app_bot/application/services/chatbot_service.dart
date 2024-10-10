import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:in_app_bot/in_app_bot/features/modes/data_plus_mode/application/usecases/send_pinecone_gpt.dart';
import 'package:in_app_bot/in_app_bot/features/modes/index_mode/application/services/sendmessagegpt.dart';
import 'package:in_app_bot/in_app_bot/features/modes/index_mode/application/use_cases/send_message_gpt.dart';
import 'package:in_app_bot/in_app_bot/features/modes/product_mode/application/use_cases/send_product_gpt.dart';

class ChatbotService {
  final SendMessageGptService sendmessagegptService = SendMessageGptService();

  late TextEditingController textEditingController;
  bool isActivecurrentChatState = false;
  late ScrollController listScrollController;
  late FocusNode focusNode;

  ChatbotService() {
    initializeControllers();
  }

  void initializeControllers() {
    listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
  }

  void disposeControllers() {
    listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
  }

  Future<void> sendMessageGPT(
    WidgetRef ref,
    BuildContext context,
    String appUserId,
    State state,
    TextEditingController textEditingController,
  ) async {
    await sendMessageGPTImpl(
      ref: ref,
      context: context,
      appUserId: appUserId,
      state: state,
      textEditingController: textEditingController,
      focusNode: focusNode,
      listScrollController: listScrollController,
      sendmessagegptService: sendmessagegptService,
    );
  }

  Future<void> sendProductGPT({
    required String productbotId,
    required String productbotName,
    required String productbotImageUrl,
    required String productbotDescription,
    required WidgetRef ref,
    required BuildContext context,
    required String appUserId,
    required TextEditingController textEditingController,
    required State state,
  }) async {
    await sendProductGPTImpl(
      productbotId: productbotId,
      productbotName: productbotName,
      productbotImageUrl: productbotImageUrl,
      productbotDescription: productbotDescription,
      ref: ref,
      context: context,
      appUserId: appUserId,
      textEditingController: textEditingController,
      state: state,
      focusNode: focusNode,
      listScrollController: listScrollController,
    );
  }

  Future<void> sendPineconeGPT({
    required WidgetRef ref,
    required BuildContext context,
    required String appUserId,
    required TextEditingController textEditingController,
    required State state,
  }) async {
    await sendPineconeGPTImpl(
      ref: ref,
      context: context,
      appUserId: appUserId,
      textEditingController: textEditingController,
      state: state,
      focusNode: focusNode,
      listScrollController: listScrollController,
    );
  }
}
