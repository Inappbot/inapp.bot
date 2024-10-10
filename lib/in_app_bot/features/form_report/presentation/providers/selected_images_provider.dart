import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedImagesProvider = StateNotifierProvider.family<
    SelectedImagesNotifier, Map<String, List<File>>, String>((ref, formId) {
  return SelectedImagesNotifier();
});

class SelectedImagesNotifier extends StateNotifier<Map<String, List<File>>> {
  SelectedImagesNotifier() : super({});

  void addImages(String formId, List<File> images) {
    state = {
      ...state,
      formId: [...(state[formId] ?? []), ...images],
    };
  }

  void removeImage(String formId, int index) {
    if (state[formId] != null && index < state[formId]!.length) {
      state = {
        ...state,
        formId: [...state[formId]!]..removeAt(index),
      };
    }
  }

  void clearImages(String formId) {
    state = {
      ...state,
      formId: [],
    };
  }
}
