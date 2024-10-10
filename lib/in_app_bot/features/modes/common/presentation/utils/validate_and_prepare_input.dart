import 'package:flutter/material.dart';

bool validateAndPrepareInput(TextEditingController textEditingController) {
  if (textEditingController.text.trim().isEmpty) {
    return false;
  }

  return true;
}
