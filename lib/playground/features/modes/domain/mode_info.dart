import 'package:in_app_bot/in_app_bot/features/chat_bubble/domain/enums/chat_mode.dart';
import 'package:in_app_bot/playground/features/modes/domain/base_mode.dart';

class ModeInfo {
  final String imageUrl;
  final String title;
  final ChatMode? chatMode;
  final List<BaseMode> modeItems;
  final Map<String, String>? extraData;

  ModeInfo({
    required this.imageUrl,
    required this.title,
    this.chatMode,
    required this.modeItems,
    this.extraData,
  });
}
