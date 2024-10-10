import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/widgets/advanced_continue_button.dart';
import 'package:in_app_bot/playground/onboarding/presentation/widgets/bottom_container.dart';
import 'package:in_app_bot/playground/onboarding/presentation/widgets/page_indicator.dart';

class ContinueButtonWidget extends ConsumerWidget {
  final int currentPage;
  final PageController pageController;
  final GlobalKey<FormState> formKey;

  const ContinueButtonWidget({
    Key? key,
    required this.currentPage,
    required this.pageController,
    required this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: BottomContainer(
          currentPage: currentPage,
          pageController: pageController,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PageIndicator(currentPage: currentPage),
              ContinueButton(
                currentPage: currentPage,
                pageController: pageController,
                formKey: formKey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
