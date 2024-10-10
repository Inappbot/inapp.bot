import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/third_page/widgets/form/form_onboarding_widget.dart';

Widget buildForm(
    BuildContext context, GlobalKey<FormState> formKey, WidgetRef ref) {
  return FormOnboardingWidget(formKey: formKey);
}
