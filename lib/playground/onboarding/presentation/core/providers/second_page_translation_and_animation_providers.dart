import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/data/repositories/second_page_lottie_animation_repository.dart';
import 'package:in_app_bot/playground/onboarding/domain/usecases/lottie_animation_use_case.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/localization/languages/second_page/titles_translations_provider.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/services/translation_service.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';

final translationServiceProvider = Provider<TranslationService>((ref) {
  final language = ref.watch(AppConfig.language);
  final translations = ref.watch(textTranslationsProvider);
  return TranslationService(language: language, translations: translations);
});

final lottieAnimationUseCaseProvider = Provider<LottieAnimationUseCase>((ref) {
  final translationService = ref.watch(translationServiceProvider);
  return SecondLottieAnimationRepository(translationService);
});
