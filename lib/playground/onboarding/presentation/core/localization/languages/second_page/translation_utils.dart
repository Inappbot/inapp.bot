import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/localization/languages/second_page/titles_translations_provider.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';

String getTranslatedText(WidgetRef ref, String textKey) {
  final language = ref.watch(AppConfig.language);
  final translations = ref.watch(textTranslationsProvider);

  return translations[language]?[textKey] ?? "Translation not found";
}
