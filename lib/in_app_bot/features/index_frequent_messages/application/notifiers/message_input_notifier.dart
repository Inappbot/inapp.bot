import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageInputNotifier extends StateNotifier<String> {
  MessageInputNotifier() : super('');

  void setMessage(String message) {
    state = message;
  }
}

final messageInputProvider =
    StateNotifierProvider<MessageInputNotifier, String>((ref) {
  return MessageInputNotifier();
});
