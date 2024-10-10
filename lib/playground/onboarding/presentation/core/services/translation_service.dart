class TranslationService {
  final String language;
  final Map<String, Map<String, String>> translations;

  TranslationService({required this.language, required this.translations});

  String getTranslation(String textKey) {
    return translations[language]?[textKey] ?? "Translation not found";
  }
}
