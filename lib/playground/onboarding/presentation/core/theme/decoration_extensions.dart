import 'package:flutter/material.dart';

extension DecorationExtensions on Decoration {
  static BoxDecoration get gradientChildContainer => BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
        ),
      );
}
