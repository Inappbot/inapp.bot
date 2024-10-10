import 'package:flutter/material.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/second_page/widgets/animated/animated_appearance.dart';
import 'package:in_app_bot/playground/presentation/theme/app_colors.dart';
import 'package:in_app_bot/playground/presentation/theme/app_text_styles.dart';

class AnimatedTitleWidget extends StatefulWidget {
  final List<String> titles;
  final Function(String) onTitleTap;

  const AnimatedTitleWidget({
    Key? key,
    required this.titles,
    required this.onTitleTap,
  }) : super(key: key);

  @override
  AnimatedTitleWidgetState createState() => AnimatedTitleWidgetState();
}

class AnimatedTitleWidgetState extends State<AnimatedTitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 6.0),
        child: _buildTitleList(),
      ),
    );
  }

  Widget _buildTitleList() {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 6.0,
      runSpacing: 4.0,
      children: widget.titles
          .asMap()
          .entries
          .map((entry) => _buildTitle(entry.key, entry.value))
          .toList(),
    );
  }

  Widget _buildTitle(int index, String title) {
    return AnimatedAppearance(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      delay: const Duration(milliseconds: 100),
      child: GestureDetector(
        onTap: () => widget.onTitleTap(title),
        child: _buildTitleContainer(index, title),
      ),
    );
  }

  Widget _buildTitleContainer(int index, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: _buildTitleContent(index, title),
    );
  }

  Widget _buildTitleContent(int index, String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(Icons.check_circle, color: AppColors.iconColor, size: 14),
        const SizedBox(width: 4),
        Text(
          title,
          style: index == 8
              ? AppTextStyles.titleTextStyle
                  .copyWith(decoration: TextDecoration.lineThrough)
              : AppTextStyles.titleTextStyle,
        ),
      ],
    );
  }
}
