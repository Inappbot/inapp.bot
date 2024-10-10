import 'dart:async';
import 'dart:developer';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:in_app_bot/in_app_bot/features/text_to_speech/domain/repositories/tts_repository.dart';

class TtsRepositoryImpl implements TtsRepository {
  final FlutterTts flutterTts = FlutterTts();
  final StreamController<bool> _playingStateController =
      StreamController<bool>.broadcast();

  List<String> sentences = [];
  List<String> fragments = [];
  bool isActive = false;

  @override
  Stream<bool> get playingStateStream => _playingStateController.stream;

  @override
  Future<void> initializeTts() async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setPitch(1.0);

    final voices = await flutterTts.getVoices;
    log("$voices");

    flutterTts.setStartHandler(() => _updatePlayingState(true));
    flutterTts.setCompletionHandler(() => _updatePlayingState(false));
    flutterTts.setCancelHandler(() => _updatePlayingState(false));
    flutterTts.setErrorHandler((error) {
      _updatePlayingState(false);
      log("error: $error");
    });
  }

  @override
  Future<void> setVolume(double volume) async {
    await flutterTts.setVolume(volume);
  }

  void _updatePlayingState(bool isPlaying) {
    _playingStateController.add(isPlaying);
  }

  @override
  Future<void> speak(String message) async {
    isActive = true;
    await setVolume(1);
    await stop();
    String cleanedMessage = _cleanMessage(message);
    sentences = cleanedMessage.split(RegExp(r'(?<=[.!?])\s+'));

    for (String sentence in sentences) {
      if (sentence.trim().isNotEmpty) {
        await _speakSentence(sentence);
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }
  }

  Future<void> _speakSentence(String sentence) async {
    fragments = sentence.split(',');
    for (int i = 0; i < fragments.length; i++) {
      if (!isActive) break;
      String fragment = fragments[i].trim();
      if (fragment.isNotEmpty) {
        await flutterTts.speak(fragment);
        if (i < fragments.length - 1) {
          await Future.delayed(const Duration(milliseconds: 200));
        }
      }
    }
  }

  String _cleanMessage(String message) {
    String noBrackets = message.replaceAll(RegExp(r'\[.*?\]'), '');
    return _removeEmojis(noBrackets);
  }

  String _removeEmojis(String message) {
    return message.replaceAll(
        RegExp(
            r'[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{FE00}-\u{FE0F}\u{1F700}-\u{1F77F}\u{1F780}-\u{1F7FF}\u{1F800}-\u{1F8FF}\u{1F900}-\u{1F9FF}\u{1FA00}-\u{1FA6F}\u{1F1E6}-\u{1F1FF}]',
            unicode: true),
        '');
  }

  @override
  Future<void> stop() async {
    await flutterTts.stop();
  }

  void dispose() {
    _playingStateController.close();
  }

  @override
  Future<void> reset() async {
    await flutterTts.setVolume(0);
    isActive = false;
    sentences = [];
    fragments = [];
  }
}
