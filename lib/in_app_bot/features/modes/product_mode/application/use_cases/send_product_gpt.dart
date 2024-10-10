import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/presentation/providers/modes_providers.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/presentation/utils/validate_and_prepare_input.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/utils/message_error_handler.dart';
import 'package:in_app_bot/in_app_bot/features/modes/product_mode/application/use_cases/perform_message_sending.dart';

Future<void> sendProductGPTImpl({
  required String productbotId,
  required String productbotName,
  required String productbotImageUrl,
  required String productbotDescription,
  required WidgetRef ref,
  required BuildContext context,
  required String appUserId,
  required TextEditingController textEditingController,
  required State state,
  required FocusNode focusNode,
  required ScrollController listScrollController,
}) async {
  if (!_validateInput(textEditingController)) return;

  bool contextIsValid = true;

  try {
    await _performMessageSending(
      ref,
      context,
      productbotId,
      productbotName,
      productbotImageUrl,
      productbotDescription,
      appUserId,
      textEditingController,
      state,
      focusNode,
      listScrollController,
    );
  } catch (e) {
    if (state.mounted && contextIsValid) {
      handleSendMessageError(e as Exception, context);
    }
  } finally {
    resetUIState(ref, state);
    contextIsValid = false;
  }
}

bool _validateInput(TextEditingController textEditingController) {
  return validateAndPrepareInput(textEditingController);
}

Future<void> _performMessageSending(
  WidgetRef ref,
  BuildContext context,
  String productbotId,
  String productbotName,
  String productbotImageUrl,
  String productbotDescription,
  String appUserId,
  TextEditingController textEditingController,
  State state,
  FocusNode focusNode,
  ScrollController listScrollController,
) async {
  await performMessageSending(
    ref: ref,
    context: context,
    productbotId: productbotId,
    productbotName: productbotName,
    productbotImageUrl: productbotImageUrl,
    productbotDescription: productbotDescription,
    appUserId: appUserId,
    msg: textEditingController.text.trim(),
    state: state,
    textEditingController: textEditingController,
    focusNode: focusNode,
    listScrollController: listScrollController,
  );
}
