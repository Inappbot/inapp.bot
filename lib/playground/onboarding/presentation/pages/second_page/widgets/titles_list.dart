import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/second_page/widgets/animated/animated_title_widget.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';

Widget buildTitlesList() {
  return Consumer(builder: (context, ref, child) {
    final titles = ref.watch(AnimationState.lottieTitles);
    return AnimatedTitleWidget(
      titles: titles,
      onTitleTap: (String title) => log("Tapped on title: $title"),
    );
  });
}
