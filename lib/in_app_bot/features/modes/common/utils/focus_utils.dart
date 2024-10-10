import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/providers.dart';

void scrollListToEND(WidgetRef ref, ScrollController listScrollController) {
  if (listScrollController.hasClients) {
    final isFirstScrollToEnd =
        ref.read(isFirstScrollToEndProvider.notifier).state;
    final offset = isFirstScrollToEnd
        ? listScrollController.position.maxScrollExtent
        : listScrollController.position.maxScrollExtent;

    listScrollController.animateTo(offset,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

    ref.read(isFirstScrollToEndProvider.notifier).state = false;
  }
}

void delayedScrollAndFocus(State state, FocusNode focusNode, WidgetRef ref,
    ScrollController listScrollController) {
  if (state.mounted) {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (state.mounted) {
        scrollListToEND(ref, listScrollController);

        if (focusNode.hasFocus) {
          FocusScope.of(state.context).requestFocus(focusNode);
        }
      }
    });
  }
}
