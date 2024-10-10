import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/features/modes/presentation/widgets/scroll_content_widget.dart';
import 'package:in_app_bot/playground/presentation/animations/animation_controller_setup.dart';
import 'package:in_app_bot/playground/presentation/providers/playground_providers.dart';
import 'package:in_app_bot/playground/presentation/services/scroll_controller_setup.dart';

class ModesPage extends ConsumerStatefulWidget {
  final String title;
  final String imageUrl;

  final List<Map<String, String>> modeItems;
  final bool fromFloatingActionButton;
  final bool fromBottomNavigationBar;
  final bool showChatBubble;

  const ModesPage({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.modeItems,
    this.fromFloatingActionButton = false,
    this.fromBottomNavigationBar = false,
    this.showChatBubble = true,
  });

  @override
  ModesPageState createState() => ModesPageState();
}

class ModesPageState extends ConsumerState<ModesPage>
    with TickerProviderStateMixin {
  late final PageController pageController;
  late AnimationControllerSetup animationSetup;
  late final ScrollControllerSetup scrollSetup;

  @override
  void initState() {
    super.initState();

    pageController =
        PageController(initialPage: ref.read(selectedPageIndexProvider));

    animationSetup = AnimationControllerSetup(
        vsync: this,
        ref: ref,
        fromFloatingActionButton: widget.fromFloatingActionButton);

    animationSetup.initTimer =
        Timer(const Duration(seconds: 2), animationSetup.controller.forward);

    animationSetup.imageSizeController.forward();

    scrollSetup = ScrollControllerSetup(ref: ref);
    scrollSetup.scrollController = ScrollController()
      ..addListener(scrollSetup.scrollListener);
  }

  @override
  void dispose() {
    animationSetup.dispose();
    pageController.dispose();
    scrollSetup.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = ref.watch(imageSizeProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ScrollContent(
        title: widget.title,
        imageUrl: widget.imageUrl,
        fromFloatingActionButton: widget.fromFloatingActionButton,
        imageSizeAnimation: animationSetup.imageSizeAnimation,
        modeItems: widget.modeItems,
        pageController: pageController,
        scrollController: scrollSetup.scrollController,
        imageSize: imageSize,
        fromBottomNavigationBar: widget.fromBottomNavigationBar,
      ),
    );
  }
}
