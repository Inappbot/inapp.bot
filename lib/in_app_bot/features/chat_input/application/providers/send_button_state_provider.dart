import 'package:flutter_riverpod/flutter_riverpod.dart';

final sendButtonStateProvider =
    StateNotifierProvider<SendButtonStateNotifier, bool>(
        (ref) => SendButtonStateNotifier());

class SendButtonStateNotifier extends StateNotifier<bool> {
  SendButtonStateNotifier() : super(false);
  void updateState(bool newState) => state = newState;
}
