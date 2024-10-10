import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/text_to_speech/data/repositories/tts_repository_impl.dart';
import 'package:in_app_bot/in_app_bot/features/text_to_speech/domain/repositories/tts_repository.dart';
import 'package:in_app_bot/in_app_bot/features/text_to_speech/presentation/helpers/tts_helper.dart';
import 'package:in_app_bot/in_app_bot/features/text_to_speech/presentation/state/tts_state.dart';

final ttsRepositoryProvider =
    Provider<TtsRepository>((ref) => TtsRepositoryImpl());

final ttsHelperProvider = StateNotifierProvider<TtsHelper, TtsState>((ref) {
  final ttsRepository = ref.watch(ttsRepositoryProvider);
  return TtsHelper(ref, ttsRepository);
});
