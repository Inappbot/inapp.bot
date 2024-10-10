import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageSentRecentlyProvider =
    StateNotifierProvider<MessageSentRecentlyNotifier, bool>(
        (ref) => MessageSentRecentlyNotifier());

class MessageSentRecentlyNotifier extends StateNotifier<bool> {
  MessageSentRecentlyNotifier() : super(false);
  void updateState(bool newState) => state = newState;
}
