import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/core/themes/default_theme.dart';
import 'package:in_app_bot/in_app_bot/features/chat_body/providers/parts_notifier_provider.dart';
import 'package:in_app_bot/in_app_bot/features/handlers/domain/interfaces/marker_handler.dart';
import 'package:in_app_bot/in_app_bot/features/handlers/managers/marker_manager.dart';
import 'package:in_app_bot/in_app_bot/features/media/presentation/widgets/media_utilities.dart';

void processMessage(String msg, BuildContext context, WidgetRef ref,
    bool isLoading, int messageIndex) {
  List<Widget> newMessageParts = [];
  MarkerManager markerManager = MarkerManager();

  RegExp pattern = RegExp(
      r'\*\*(.*?)\*\*|\#\w+|\[link\]\w+|\[promo\]\w+|\[wh\]\d+|\[inst\]\w+|\[repform\]\w*|\&\w+');
  int lastMatchEnd = 0;

  for (var match in pattern.allMatches(msg)) {
    int start = match.start;
    int end = match.end;
    String marker = msg.substring(start, end);

    if (start > lastMatchEnd) {
      newMessageParts.add(
        Text(
          msg.substring(lastMatchEnd, start),
          style: Theme.of(context).customTheme.messageStyle,
        ),
      );
    }

    if (marker.startsWith('**') && marker.endsWith('**')) {
      String content = marker.substring(2, marker.length - 2);
      MarkerHandler? handler = markerManager.getHandlerForMarker(content);
      if (handler != null) {
        newMessageParts.addAll(handler.handle(content, context, ref));
      } else {
        newMessageParts.add(
          Text(
            content,
            style: Theme.of(context).customTheme.messageStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        );
      }
    } else {
      MarkerHandler? handler = markerManager.getHandlerForMarker(marker);
      if (handler != null) {
        newMessageParts.addAll(handler.handle(marker, context, ref));
      } else if (marker.startsWith('#')) {
        processMediaMarker(marker, newMessageParts, ref);
      } else {
        newMessageParts.add(
          Text(
            marker,
            style: Theme.of(context).customTheme.messageStyle,
          ),
        );
      }
    }

    lastMatchEnd = end;
  }

  if (lastMatchEnd < msg.length) {
    newMessageParts.add(
      Text(
        msg.substring(lastMatchEnd),
        style: Theme.of(context).customTheme.messageStyle,
      ),
    );
  }

  ref
      .read(messagePartsProvider.notifier)
      .updateMessageParts(messageIndex, newMessageParts);
}
