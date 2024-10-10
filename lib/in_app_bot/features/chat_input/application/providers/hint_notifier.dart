import 'package:flutter_riverpod/flutter_riverpod.dart';

class HintNotifier extends StateNotifier<bool> {
  HintNotifier() : super(true);

  void setShowHint(bool showHint) {
    state = showHint;
  }
}

final hintProvider = StateNotifierProvider<HintNotifier, bool>((ref) {
  return HintNotifier();
});
