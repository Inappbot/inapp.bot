import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/localization/languages/third_page/titles_translations_provider.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';

class GetUpdatedTitlesUseCase {
  Map<int, String> execute(WidgetRef ref) {
    final language = ref.watch(AppConfig.language);
    final titlesByLanguage = ref.watch(titlesByLanguageProvider);
    return {
      1: 'ENEIA',
      ...titlesByLanguage[language] ?? {},
    };
  }
}
