import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/chat_bubble/domain/enums/chat_mode.dart';

abstract class ChatModeParams {}

class IndexModeParams extends ChatModeParams {
  final String appUserId;
  IndexModeParams({required this.appUserId});
}

class ScanAIModeParams extends ChatModeParams {
  final String appUserId;

  ScanAIModeParams({required this.appUserId});
}

class DataplusModeParams extends ChatModeParams {
  final String appUserId;
  DataplusModeParams({required this.appUserId});
}

class ProductModeParams extends ChatModeParams {
  final String appUserId;
  final String productbotId;
  final String productbotName;
  final String productbotImageUrl;
  final String productbotDescription;

  ProductModeParams({
    required this.appUserId,
    required this.productbotId,
    required this.productbotName,
    required this.productbotImageUrl,
    required this.productbotDescription,
  });
}

class ChatState {
  final ChatMode? mode;
  final ChatModeParams? params;

  ChatState({this.mode, this.params});

  ChatState copyWith({ChatMode? mode, ChatModeParams? params}) {
    return ChatState(
      mode: mode ?? this.mode,
      params: params ?? this.params,
    );
  }
}

class ChatStateNotifier extends StateNotifier<ChatState> {
  ChatStateNotifier() : super(ChatState());

  void setMode(ChatMode mode, ChatModeParams params) {
    state = ChatState(mode: mode, params: params);
  }

  void reset() {
    state = ChatState();
  }
}

final chatStateProvider = StateNotifierProvider<ChatStateNotifier, ChatState>(
    (ref) => ChatStateNotifier());
