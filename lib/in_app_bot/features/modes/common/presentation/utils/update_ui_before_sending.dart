import 'package:flutter_riverpod/flutter_riverpod.dart' show WidgetRef;
import 'package:in_app_bot/in_app_bot/presentation/providers/providers.dart';

void updateUIBeforeSending(WidgetRef ref) {
  final currentState = ref.read(chatUIState);
  ref.read(chatUIState.notifier).state = currentState.copyWith(
    isTyping: true,
    isSendButtonEnabled: false,
  );
}
