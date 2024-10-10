import 'package:flutter/material.dart';
import 'package:in_app_bot/playground/features/modes/domain/mode_info.dart';
import 'package:in_app_bot/playground/features/modes/presentation/navigation/mode_navigation.dart';
import 'package:in_app_bot/playground/presentation/widgets/play_container.dart';

Widget buildModeRow(BuildContext context, ModeInfo mode) {
  return Row(
    children: [
      Expanded(
        child: PlayContainer(
          imageUrl: mode.imageUrl,
          title: mode.title,
          onTap: () => navigateToModePage(context, mode),
        ),
      ),
    ],
  );
}
