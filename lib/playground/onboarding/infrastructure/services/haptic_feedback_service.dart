import 'dart:io';

import 'package:flutter/services.dart';

class HapticFeedbackService {
  static void triggerFeedback() {
    HapticFeedback.lightImpact();
    if (!Platform.isAndroid) {
      HapticFeedback.heavyImpact();
    }
  }
}
