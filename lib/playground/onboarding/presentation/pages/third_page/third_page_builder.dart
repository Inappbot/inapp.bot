import 'package:flutter/material.dart';
import 'package:in_app_bot/playground/onboarding/domain/entities/third_page_params.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/third_page/third_page.dart';
import 'package:in_app_bot/playground/onboarding/presentation/widgets/language_selector_widget.dart';

class ThirdPageBuilder {
  static Widget buildThirdPage(ThirdPageParams params) {
    return GestureDetector(
      onTap: () => FocusScope.of(params.context).unfocus(),
      child: Stack(
        children: [
          ThirdPageContent(params: params),
          Positioned(
            top: 10,
            right: 10,
            child: buildLanguageSelector(
              params.ref,
              params.progressAnimationController,
              params.progressAnimationController3,
              true,
              params.currentPage,
              params.context,
            ),
          ),
        ],
      ),
    );
  }
}
