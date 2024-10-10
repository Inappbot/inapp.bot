import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';

class FormUIStateValues {
  final bool showForm;
  final double formOpacity;
  final bool isKeyboardVisible;

  FormUIStateValues(
      {required this.showForm,
      required this.formOpacity,
      required this.isKeyboardVisible});
}

FormUIStateValues getUIState(WidgetRef ref) {
  final showForm = ref.watch(UIState.showForm);
  final formOpacity = ref.watch(UIState.formOpacity);
  final isKeyboardVisible = ref.watch(UIState.keyboardVisibility);

  return FormUIStateValues(
      showForm: showForm,
      formOpacity: formOpacity,
      isKeyboardVisible: isKeyboardVisible);
}
