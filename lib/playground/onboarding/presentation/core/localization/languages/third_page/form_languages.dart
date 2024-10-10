import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';

String getLabelText(String key, WidgetRef ref) {
  final language = ref.watch(AppConfig.language);

  switch (key) {
    case 'name':
      switch (language) {
        case 'en':
          return 'Name';
        case 'es':
          return 'Nombre';
        case 'hi':
          return 'नाम';
        default:
          return 'Name';
      }
    case 'email':
      switch (language) {
        case 'en':
          return 'Email';
        case 'es':
          return 'Correo';
        case 'hi':
          return 'ईमेल';
        default:
          return 'Name';
      }

    default:
      return key;
  }
}

String getTextFieldHint(String key, WidgetRef ref) {
  final language = ref.watch(AppConfig.language);

  switch (key) {
    case 'nameHint':
      switch (language) {
        case 'en':
          return 'Enter your name';
        case 'es':
          return 'Introduce tu nombre';
        case 'hi':
          return 'अपना नाम दर्ज करें';
        default:
          return 'Enter your name';
      }
    case 'emailHint':
      switch (language) {
        case 'en':
          return 'Enter your email';
        case 'es':
          return 'Introduce tu correo electrónico';
        case 'hi':
          return 'अपना ईमेल दर्ज करें';
        default:
          return 'Enter your email';
      }

    default:
      return key;
  }
}

String getValidationMessage(String key, WidgetRef ref) {
  final language = ref.watch(AppConfig.language);
  switch (key) {
    case 'nameRequired':
      switch (language) {
        case 'en':
          return 'Please enter your name';
        case 'es':
          return 'Por favor ingresa tu nombre';
        case 'hi':
          return 'कृपया अपना नाम दर्ज करें';
        default:
          return 'Please enter your name';
      }
    case 'emailRequired':
      switch (language) {
        case 'en':
          return 'Please enter your email';
        case 'es':
          return 'Por favor ingresa tu correo';
        case 'hi':
          return 'कृपया अपना ईमेल दर्ज करें';
        default:
          return 'Please enter your email';
      }
    case 'emailInvalid':
      switch (language) {
        case 'en':
          return 'Please enter a valid email';
        case 'es':
          return 'Por favor ingresa un correo válido';
        case 'hi':
          return 'कृपया मान्य ईमेल दर्ज करें';
        default:
          return 'Please enter a valid email';
      }

    default:
      return key;
  }
}
