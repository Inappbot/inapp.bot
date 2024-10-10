import 'package:flutter_riverpod/flutter_riverpod.dart';

class BubbleState extends StateNotifier<bool> {
  BubbleState() : super(false);

  void show() => state = true;
  void hide() => state = false;
}

final bubbleStateProvider = StateNotifierProvider<BubbleState, bool>((ref) {
  return BubbleState();
});
