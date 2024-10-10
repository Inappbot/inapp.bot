import 'package:flutter/material.dart';
import 'package:in_app_bot/playground/onboarding/presentation/core/theme/indicator_config.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const PageIndicator({
    Key? key,
    required this.currentPage,
    this.pageCount = IndicatorConfig.defaultPageCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(pageCount, (index) => _buildDot(index)),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: IndicatorConfig.animationDuration,
      curve: IndicatorConfig.animationCurve,
      margin: IndicatorConfig.dotMargin,
      height: IndicatorConfig.dotHeight,
      width: currentPage == index
          ? IndicatorConfig.selectedWidth
          : IndicatorConfig.normalWidth,
      decoration: BoxDecoration(
        color: currentPage == index
            ? IndicatorConfig.selectedColor
            : IndicatorConfig.normalColor,
        borderRadius: IndicatorConfig.dotBorderRadius,
      ),
    );
  }
}
