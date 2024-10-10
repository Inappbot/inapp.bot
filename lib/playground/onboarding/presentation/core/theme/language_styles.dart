import 'package:flutter/material.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/localization/language.dart';

class LanguageStyles {
  static TextStyle textStyle(Language language, Language selectedLanguage) {
    return TextStyle(
      color:
          language == selectedLanguage ? Colors.black : const Color(0xFF797979),
      fontWeight:
          language == selectedLanguage ? FontWeight.bold : FontWeight.w500,
      fontFamily: 'Poppins',
      fontSize: language == selectedLanguage ? 16 : 14,
    );
  }
}
