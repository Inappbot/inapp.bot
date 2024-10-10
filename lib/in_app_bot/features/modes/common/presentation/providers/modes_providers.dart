import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/providers.dart';

void resetUIState(WidgetRef ref, State state) {
  if (state.mounted) {
    ref
        .read(chatUIState.notifier)
        .update((state) => state.copyWith(isTyping: false));
  }
}
