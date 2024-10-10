import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:in_app_bot/in_app_bot/features/handlers/domain/interfaces/marker_handler.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsappHandler implements MarkerHandler {
  @override
  List<Widget> handle(String marker, BuildContext context, dynamic ref) {
    String phoneNumber = marker.substring(4);
    return [buildWhatsAppRow(phoneNumber)];
  }

  Widget buildWhatsAppRow(String phoneNumber) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildWhatsAppIcon(),
        const SizedBox(width: 8.0),
        buildWhatsAppButton(phoneNumber),
      ],
    );
  }

  Widget buildWhatsAppIcon() {
    return SizedBox(
      width: 44.0,
      height: 44.0,
      child: Lottie.asset('assets/animations/animation_whastapp.json',
          fit: BoxFit.cover),
    );
  }

  Widget buildWhatsAppButton(String phoneNumber) {
    return Flexible(
      child: ElevatedButton(
        style: whatsappbuttonStyle,
        onPressed: () => openWhatsApp(phoneNumber),
        child: buildButtonContent(phoneNumber),
      ),
    );
  }

  Future<void> openWhatsApp(String phoneNumber) async {
    var nativeUrl = Uri.parse("whatsapp://send?phone=$phoneNumber&text=Hello");
    var webUrl = Uri.parse('https://wa.me/$phoneNumber?text=Hello');
    if (await canLaunchUrl(nativeUrl)) {
      await launchUrl(nativeUrl);
    } else if (await canLaunchUrl(webUrl)) {
      await launchUrl(webUrl);
    } else {
      log("WhatsApp could not be opened");
    }
  }

  Widget buildButtonContent(String phoneNumber) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '+$phoneNumber',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4.0),
        const Text('Open in WhatsApp', overflow: TextOverflow.ellipsis),
      ],
    );
  }

  final ButtonStyle whatsappbuttonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: const Color(0xFF25D366),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  );
}
