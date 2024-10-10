import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/chat_body/providers/parts_notifier_provider.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/providers.dart';

void clearChatAndMessageParts(WidgetRef ref) async {
  ref.read(chatProvider.notifier).clearChatList();
  ref.read(messagePartsProvider.notifier).clearMessageParts();
}
