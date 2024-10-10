import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimationControllerSetup {
  late final AnimationController controller;
  late final Animation<double> fadeAnimation;
  late final AnimationController imageSizeController;
  late final Animation<double> imageSizeAnimation;
  final TickerProvider vsync;
  final WidgetRef ref;
  final bool fromFloatingActionButton;
  Timer? initTimer;
  bool isDisposed = false;

  AnimationControllerSetup({
    required this.vsync,
    required this.ref,
    required this.fromFloatingActionButton,
  }) {
    _initAnimationControllers();
    initTimer = Timer(const Duration(seconds: 2), safeForwardAnimation);
  }

  void safeForwardAnimation() {
    if (!isDisposed) {
      controller.forward();
      imageSizeController.forward();
    }
  }

  void _initAnimationControllers() {
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: vsync);

    fadeAnimation = Tween(begin: 1.0, end: 0.0).animate(controller);

    imageSizeController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: vsync)
      ..addStatusListener(_imageSizeStatusListener);

    imageSizeAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 70.0, end: 100.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50.0),
      TweenSequenceItem(
          tween: Tween(begin: 100.0, end: 30.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50.0),
    ]).animate(
        CurvedAnimation(parent: imageSizeController, curve: Curves.linear));
  }

  void _imageSizeStatusListener(AnimationStatus status) {
    if (fromFloatingActionButton) {
      if (status == AnimationStatus.forward) {
        HapticFeedback.lightImpact();
      } else if (status == AnimationStatus.completed) {
        HapticFeedback.heavyImpact();
      }
    }
  }

  void dispose() {
    isDisposed = true;
    initTimer?.cancel();
    controller.dispose();
    imageSizeController.dispose();
  }
}
