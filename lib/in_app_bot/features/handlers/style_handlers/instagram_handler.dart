import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:in_app_bot/in_app_bot/features/handlers/domain/interfaces/marker_handler.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class InstagramHandler implements MarkerHandler {
  static const instagramButtonColor = Color(0xFFE1306C);
  static final instagramButtonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  );
  static const buttonPadding =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
  static const textStyle =
      TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold);

  @override
  List<Widget> handle(String marker, BuildContext context, dynamic ref) {
    String instagramUser = marker.substring(6);
    return [buildInstagramRow(instagramUser)];
  }

  Widget buildInstagramRow(String user) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildAnimationWidget(),
        const SizedBox(width: 10.0),
        buildInstagramButton(user),
      ],
    );
  }

  Widget buildAnimationWidget() {
    return SizedBox(
      width: 44.0,
      height: 44.0,
      child: Lottie.asset('assets/animations/animation_instagram.json',
          fit: BoxFit.cover),
    );
  }

  Widget buildInstagramButton(String user) {
    return SizedBox(
      width: 200.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: instagramButtonColor,
          shape: instagramButtonShape,
          padding: buttonPadding,
        ),
        onPressed: () => launchInstagram(user),
        child: Column(
          children: [
            Text('@$user', style: textStyle),
            const SizedBox(height: 4.0),
            const Text('Open in Instagram'),
          ],
        ),
      ),
    );
  }

  Future<void> launchInstagram(String user) async {
    var nativeUrl = Uri.parse("instagram://user?username=$user");
    var webUrl = Uri.parse("https://instagram.com/$user");

    if (await canLaunchUrl(nativeUrl)) {
      await launchUrl(nativeUrl);
    } else if (await canLaunchUrl(webUrl)) {
      await launchUrl(webUrl);
    } else {
      log('Could not launch either URLs');
    }
  }
}
