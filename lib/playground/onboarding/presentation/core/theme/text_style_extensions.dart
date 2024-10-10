import 'package:flutter/material.dart';

extension TextStyleExtensions on TextStyle {
  static TextStyle get skipButton => const TextStyle(
        decoration: TextDecoration.underline,
        color: Color.fromARGB(255, 177, 177, 177),
        fontSize: 16,
      );
}
