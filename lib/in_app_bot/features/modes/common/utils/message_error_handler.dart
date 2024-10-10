import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/presentation/utils/user_error.dart';

void handleSendMessageError(Exception e, BuildContext context) {
  if (e is SocketException) {
    // Handling network errors
    showUserErrorSnackBar('Network error. Please try again later.', context);
    log('Network error while sending message: ${e.message}');
  } else if (e is FormatException) {
    // Handling format errors
    showUserErrorSnackBar(
        'Invalid message format. Please correct it and try again.', context);
    log('Format error while sending message: ${e.message}');
  } else {
    // Handling other unexpected errors
    showUserErrorSnackBar(
        'An unexpected error occurred. Please try again later.', context);
    log('Unexpected error while sending message: ${e.toString()}');
  }
}
