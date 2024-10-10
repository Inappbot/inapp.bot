import 'package:flutter/material.dart';
import 'package:in_app_bot/playground/features/modes/domain/mode_info.dart';
import 'package:in_app_bot/playground/features/modes/presentation/modes_view.dart';

void navigateToModePage(BuildContext context, ModeInfo mode) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ModesPage(
        title: mode.title,
        imageUrl: mode.imageUrl,
        modeItems: mode.modeItems
            .map((item) => {
                  'title': item.title,
                  'description': item.description,
                })
            .toList(),
        showChatBubble: mode.chatMode != null,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(
        opacity: animation,
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 300),
    ),
  );
}
