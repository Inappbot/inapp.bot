import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/appbar/presentation/widgets/app_bar_widgets.dart';
import 'package:in_app_bot/in_app_bot/features/appbar/presentation/widgets/typing_indicator.dart';
import 'package:in_app_bot/in_app_bot/features/avatar/presentation/widgets/video_avatar.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends ConsumerStatefulWidget {
  final dynamic chatState;
  final Function clearChat;
  final String productbotName;
  final String productbotId;
  final bool isTyping;
  final bool isTtsActive;
  final String appUserId;
  final bool shouldShrinkAppBar;
  final Function handlePauseInSpeech;

  const CustomAppBar({
    super.key,
    required this.chatState,
    required this.clearChat,
    required this.productbotName,
    required this.productbotId,
    required this.isTyping,
    required this.isTtsActive,
    required this.appUserId,
    required this.shouldShrinkAppBar,
    required this.handlePauseInSpeech,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomAppBarrState();
}

class _CustomAppBarrState extends ConsumerState<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    ref.listen<ChatUIState>(chatUIState, (previous, next) async {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(next.toJson());
      await prefs.setString('chatUIState', jsonString);

      log('ChatUIState saved: $jsonString');
    });

    return PreferredSize(
      preferredSize: const Size.fromHeight(200.0),
      child: Consumer(
        builder: (context, ref, child) {
          final shouldShrink = ref.watch(chatUIState).shouldShrinkAppBar;
          final targetAppBarHeight =
              _calculateAppBarHeight(context, shouldShrink);
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: targetAppBarHeight,
            child: SafeArea(
              child: Stack(
                children: [
                  _buildCustomAppBar(context, ref),
                  _buildCenterContent(context, widget.isTyping),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  double _calculateAppBarHeight(BuildContext context, bool shouldShrink) {
    final screenHeight = MediaQuery.of(context).size.height;
    if (screenHeight < 800) {
      return shouldShrink ? 100.0 : 150.0;
    } else {
      return shouldShrink ? 142.0 : 200.0;
    }
  }

  Widget _buildCustomAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      toolbarHeight: 62.0,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildLeftAppBarContent(context, ref, widget.productbotName,
              widget.chatState, widget.clearChat),
          buildRightAppBarContent(context, ref, widget.appUserId),
        ],
      ),
    );
  }

  Widget _buildCenterContent(BuildContext context, bool isTyping) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          const Flexible(
            child: VideoAvatar(),
          ),
          const SizedBox(height: 0),
          buildTypingIndicator(context, isTyping),
        ],
      ),
    );
  }
}
