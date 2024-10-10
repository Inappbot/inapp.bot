import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyFormNotifier extends ChangeNotifier {
  static int _counter = 0;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String formId;
  String description = "";
  String email = "";
  List<File> imageFiles = [];

  MyFormNotifier() : formId = _generateFormId() {
    log("Form ID: $formId");
  }

  static String _generateFormId() {
    return 'form_${DateTime.now().millisecondsSinceEpoch}_${_counter++}';
  }

  void updateFormId() {
    formId = _generateFormId();
    log("New Form ID: $formId");
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    email = newEmail;
    notifyListeners();
  }

  void updateDescription(String newDescription) {
    description = newDescription;
    notifyListeners();
  }

  void clearForm() {
    updateFormId();
    email = "";
    description = "";
    imageFiles.clear();
    notifyListeners();
  }
}

final myFormProvider = ChangeNotifierProvider((ref) => MyFormNotifier());
