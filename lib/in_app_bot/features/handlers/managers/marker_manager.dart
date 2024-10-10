import 'dart:developer';

import 'package:in_app_bot/in_app_bot/features/handlers/domain/interfaces/marker_handler.dart';
import 'package:in_app_bot/in_app_bot/features/handlers/form_handler.dart';
import 'package:in_app_bot/in_app_bot/features/handlers/style_handlers/instagram_handler.dart';
import 'package:in_app_bot/in_app_bot/features/handlers/style_handlers/link_handler.dart';
import 'package:in_app_bot/in_app_bot/features/handlers/style_handlers/promo_code_handler.dart';
import 'package:in_app_bot/in_app_bot/features/handlers/style_handlers/whatsapp_handler.dart';

class MarkerManager {
  MarkerHandler? getHandlerForMarker(String marker) {
    int endIndex = marker.indexOf(']');
    if (endIndex == -1 || endIndex < 1) {
      log("Error: Invalid marker format: $marker");
      return null;
    }
    String markerType = marker.substring(1, endIndex);

    switch (markerType) {
      case 'promo':
        return PromoCodeHandler();
      case 'wh':
        return WhatsappHandler();
      case 'inst':
        return InstagramHandler();
      case 'repform':
        return FormHandler();
      case 'link':
        return LinkHandler();
      default:
        log("Error: Unknown marker type: $markerType");
        return null;
    }
  }
}
