enum Language { en, es, hi }

extension LanguageExtension on Language {
  String get name => toString().split('.').last;
}
