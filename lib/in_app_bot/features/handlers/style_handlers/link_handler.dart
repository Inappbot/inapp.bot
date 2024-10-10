import 'package:flutter/material.dart';
import 'package:in_app_bot/in_app_bot/features/handlers/domain/interfaces/marker_handler.dart';
import 'package:lottie/lottie.dart';

class LinkButton extends StatelessWidget {
  final String route;
  const LinkButton({Key? key, required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () => Navigator.of(context).pushNamed('/$route'),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            LottieWidget(),
          ],
        ),
      ),
    );
  }
}

class LottieWidget extends StatelessWidget {
  const LottieWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/animations/animation_link_white.json',
      width: 40.0,
      fit: BoxFit.cover,
    );
  }
}

class LinkHandler implements MarkerHandler {
  @override
  List<Widget> handle(String marker, BuildContext context, dynamic ref) {
    final route = _extractRoute(marker);
    return [LinkButton(route: route)];
  }

  String _extractRoute(String marker) {
    return marker.substring(6);
  }
}
