import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/controllers/language_change_actions_controllers.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/localization/language.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';
import 'package:in_app_bot/playground/onboarding/presentation/widgets/language_dropdown.dart';

Widget buildLanguageSelector(
  WidgetRef ref,
  AnimationController progressAnimationController,
  AnimationController progressAnimationController3,
  bool mounted,
  int currentPage,
  BuildContext context,
) {
  final selectedLanguage =
      Language.values.byName(ref.watch(AppConfig.language));
  final isDropdownButtonEnabled = ref.watch(UIConfig.dropdownButtonEnabled);

  return LanguageDropdown(
    selectedLanguage: selectedLanguage,
    isEnabled: isDropdownButtonEnabled,
    onChanged: (Language? newLanguage) {
      if (newLanguage == null) return;

      performLanguageChangeActions(
        ref,
        newLanguage.name,
        currentPage,
        mounted,
        progressAnimationController,
        progressAnimationController3,
        context,
      );
    },
  );
}
