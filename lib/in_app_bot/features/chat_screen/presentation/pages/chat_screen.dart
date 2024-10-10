import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/chat_screen/presentation/pages/chat_screen_state.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String productbotId;
  final String productbotName;
  final String productbotImageUrl;
  final String productbotDescription;
  final String appUserId;
  final void Function()? handlePauseInSpeech;

  const ChatScreen({
    Key? key,
    this.productbotId = '',
    this.productbotName = '',
    this.productbotImageUrl = '',
    this.productbotDescription = '',
    this.appUserId = '',
    this.handlePauseInSpeech,
  }) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}
