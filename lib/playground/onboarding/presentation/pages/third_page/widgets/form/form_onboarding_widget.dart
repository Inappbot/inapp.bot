import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/localization/languages/third_page/form_languages.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/subscription_form_provider.dart';

class FormOnboardingWidget extends ConsumerWidget {
  final GlobalKey<FormState> formKey;

  const FormOnboardingWidget({Key? key, required this.formKey})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildTextFormField(
              labelKey: 'name',
              hintKey: 'nameHint',
              prefixIcon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return getValidationMessage('nameRequired', ref);
                }

                ref.read(subscriptionFormProvider).name = value;
                return null;
              },
              ref: ref,
            ),
            _buildTextFormField(
              labelKey: 'email',
              hintKey: 'emailHint',
              prefixIcon: Icons.email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return getValidationMessage('emailRequired', ref);
                } else if (!value.contains('@')) {
                  return getValidationMessage('emailInvalid', ref);
                }
                ref.read(subscriptionFormProvider).email = value;
                return null;
              },
              ref: ref,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String labelKey,
    required String hintKey,
    required IconData prefixIcon,
    required String? Function(String? value) validator,
    required WidgetRef ref,
    OutlineInputBorder? border,
  }) {
    final effectiveBorder = border ??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2.0),
        );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: const TextStyle(color: Color.fromARGB(255, 74, 167, 243)),
        decoration: InputDecoration(
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          filled: true,
          labelText: getLabelText(labelKey, ref),
          hintText: getTextFieldHint(hintKey, ref),
          prefixIcon: Icon(prefixIcon, color: const Color(0xFF2196F3)),
          border: effectiveBorder,
          focusedBorder: effectiveBorder.copyWith(
            borderSide: const BorderSide(color: Color(0xFF1361A0), width: 2.5),
          ),
          enabledBorder: effectiveBorder,
        ),
        validator: validator,
      ),
    );
  }
}
