import 'package:flutter/material.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/localization/language.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/theme/language_styles.dart';

class LanguageSelector extends StatelessWidget {
  final Language selectedLanguage;
  final bool isEnabled;
  final ValueChanged<Language?> onChanged;

  const LanguageSelector({
    Key? key,
    required this.selectedLanguage,
    required this.isEnabled,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<Language>(
        isExpanded: true,
        value: selectedLanguage,
        icon: const Icon(Icons.language, color: Color(0xFF797979), size: 24.0),
        onChanged: isEnabled ? _handleLanguageChange(context) : null,
        items: Language.values.map(_buildDropdownMenuItem).toList(),
        dropdownColor: Colors.white,
        elevation: 1,
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }

  DropdownMenuItem<Language> _buildDropdownMenuItem(Language language) {
    return DropdownMenuItem<Language>(
      value: language,
      child: Text(
        language.name.toUpperCase(),
        style: LanguageStyles.textStyle(selectedLanguage, language),
      ),
    );
  }

  ValueChanged<Language?> _handleLanguageChange(BuildContext context) {
    return (newLanguage) {
      if (newLanguage != selectedLanguage) {
        onChanged(newLanguage);
      } else {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    };
  }
}
