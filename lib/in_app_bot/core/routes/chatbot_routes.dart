import 'package:flutter/material.dart';

import 'package:in_app_bot/playground/features/splash/presentation/pages/splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';

  static final Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final WidgetBuilder? builder = routes[settings.name];
    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    }

    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('Route not found: ${settings.name}'),
        ),
      ),
    );
  }
}
