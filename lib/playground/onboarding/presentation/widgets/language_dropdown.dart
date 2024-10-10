import 'package:flutter/material.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/localization/language.dart';
import 'package:in_app_bot/playground/onboarding/presentation/widgets/language_dropdown_selector.dart';

class LanguageDropdown extends StatelessWidget {
  final Language selectedLanguage;
  final bool isEnabled;
  final ValueChanged<Language?> onChanged;

  const LanguageDropdown({
    Key? key,
    required this.selectedLanguage,
    required this.isEnabled,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: LanguageSelector(
          selectedLanguage: selectedLanguage,
          isEnabled: isEnabled,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
