import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color _primaryLightColor = Color.fromRGBO(105, 105, 105, 1);

  static const Color _lightIconColor = Color.fromARGB(255, 51, 51, 51);

  // Gradients
  static const LinearGradient _lightCustomGradient = LinearGradient(
    colors: [Color.fromARGB(55, 105, 105, 105), Colors.white],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    stops: [0.5, 0.9],
  );

  static const LinearGradient _darkNotificationGradient = LinearGradient(
    colors: [Color.fromARGB(255, 60, 60, 60), Color.fromARGB(255, 60, 60, 60)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient _lightNotificationGradient = LinearGradient(
    colors: [Colors.white, Colors.white],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text Styles
  static const TextStyle _messageStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    fontStyle: FontStyle.normal,
    fontSize: 16,
  );

  // Light Theme
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      iconTheme: const IconThemeData(color: _lightIconColor),
      colorScheme: const ColorScheme.light(
        primary: Colors.white,
        onPrimary: _lightIconColor,
        secondary: Colors.blueAccent,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        surface: Colors.white,
        onSurface: _primaryLightColor,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: _primaryLightColor,
        selectionColor: Colors.blue.withOpacity(0.5),
        selectionHandleColor: Colors.blue,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
      ),
      extensions: const [
        CustomThemeExtension(
          customGradient: _lightCustomGradient,
          notificationGradient: _lightNotificationGradient,
          messageStyle: _messageStyle,
        ),
      ],
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      iconTheme: const IconThemeData(color: _lightIconColor),
      colorScheme: const ColorScheme.light(
        primary: Colors.white,
        onPrimary: _lightIconColor,
        secondary: Colors.blueAccent,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        surface: Colors.white,
        onSurface: _primaryLightColor,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: _primaryLightColor,
        selectionColor: Colors.blue.withOpacity(0.5),
        selectionHandleColor: Colors.blue,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
      ),
      extensions: const [
        CustomThemeExtension(
          customGradient: _lightCustomGradient,
          notificationGradient: _lightNotificationGradient,
          messageStyle: _messageStyle,
        ),
      ],
    );
  }

  static BoxDecoration getFrequentMessageDecoration(bool isDarkMode) {
    return BoxDecoration(
      gradient:
          isDarkMode ? _darkNotificationGradient : _lightNotificationGradient,
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      boxShadow: [
        BoxShadow(
          color: (isDarkMode
                  ? const Color.fromARGB(255, 30, 30, 30)
                  : const Color.fromARGB(255, 120, 120, 120))
              .withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 2,
          offset: const Offset(0, 2),
        )
      ],
    );
  }
}

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final LinearGradient customGradient;
  final LinearGradient notificationGradient;
  final TextStyle messageStyle;

  const CustomThemeExtension({
    required this.customGradient,
    required this.notificationGradient,
    required this.messageStyle,
  });

  @override
  CustomThemeExtension copyWith({
    LinearGradient? customGradient,
    LinearGradient? notificationGradient,
    TextStyle? messageStyle,
  }) {
    return CustomThemeExtension(
      customGradient: customGradient ?? this.customGradient,
      notificationGradient: notificationGradient ?? this.notificationGradient,
      messageStyle: messageStyle ?? this.messageStyle,
    );
  }

  @override
  ThemeExtension<CustomThemeExtension> lerp(
    ThemeExtension<CustomThemeExtension>? other,
    double t,
  ) {
    if (other is! CustomThemeExtension) {
      return this;
    }
    return CustomThemeExtension(
      customGradient:
          LinearGradient.lerp(customGradient, other.customGradient, t)!,
      notificationGradient: LinearGradient.lerp(
          notificationGradient, other.notificationGradient, t)!,
      messageStyle: TextStyle.lerp(messageStyle, other.messageStyle, t)!,
    );
  }
}

extension CustomThemeDataExtension on ThemeData {
  CustomThemeExtension get customTheme => extension<CustomThemeExtension>()!;
}
