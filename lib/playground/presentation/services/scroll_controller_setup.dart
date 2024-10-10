import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/presentation/providers/playground_providers.dart';

class ScrollControllerSetup {
  late ScrollController scrollController;
  final WidgetRef ref;

  ScrollControllerSetup({required this.ref}) {
    scrollController = ScrollController()..addListener(scrollListener);
  }

  void scrollListener() {
    double newSize = max(50, min(100, 100 - scrollController.offset / 2));
    ref.read(imageSizeProvider.notifier).state = newSize;
  }

  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
  }
}
