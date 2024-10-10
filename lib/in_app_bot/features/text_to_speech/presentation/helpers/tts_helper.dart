import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/text_to_speech/domain/repositories/tts_repository.dart';
import 'package:in_app_bot/in_app_bot/features/text_to_speech/presentation/state/tts_state.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/providers.dart';

class TtsHelper extends StateNotifier<TtsState> {
  final StateNotifierProviderRef<TtsHelper, TtsState> ref;
  final TtsRepository ttsRepository;

  TtsHelper(this.ref, this.ttsRepository) : super(const TtsState(false)) {
    _initialize();
  }

  void _initialize() {
    ttsRepository.initializeTts();
    ttsRepository.playingStateStream.listen(_updateState);
  }

  void _updateState(bool isPlaying) {
    log('ChatUIState saved: TTS is playing: $isPlaying');
    state = TtsState(isPlaying);
    final currentState = ref.read(chatUIState);
    ref.read(chatUIState.notifier).state =
        currentState.copyWith(isTtsPlaying: isPlaying);
  }

  Future<void> speak(String message) async {
    await ttsRepository.speak(message);
  }

  Future<void> stop() async {
    await ttsRepository.stop();
  }

  Future<void> reset() async {
    await ttsRepository.reset();
  }
}
