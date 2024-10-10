import 'package:flutter/material.dart';

class IndicatorConfig {
  static const int defaultPageCount = 3;
  static const double selectedWidth = 30;
  static const double normalWidth = 10;
  static const double dotHeight = 10;
  static const EdgeInsets dotMargin = EdgeInsets.symmetric(horizontal: 5);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Curve animationCurve = Curves.bounceOut;
  static const Color selectedColor = Colors.white;
  static const Color normalColor = Color.fromARGB(255, 196, 196, 196);
  static final BorderRadius dotBorderRadius = BorderRadius.circular(5);
}
