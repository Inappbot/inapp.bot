import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/entities/chat_model.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/chat_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatUIState {
  final bool isTyping;
  final bool isSendButtonEnabled;
  final bool isLoading;
  final bool isTtsActive;
  final bool showMuteIcon;
  final bool showUnMuteIcon;
  final bool isTtsPlaying;
  final bool shouldShrinkAppBar;
  final bool isTtsMuted;

  ChatUIState({
    this.isTyping = false,
    this.isSendButtonEnabled = false,
    this.isLoading = false,
    this.isTtsActive = true,
    this.showMuteIcon = false,
    this.showUnMuteIcon = false,
    this.isTtsPlaying = false,
    this.shouldShrinkAppBar = false,
    this.isTtsMuted = false,
  });

  ChatUIState copyWith({
    bool? isTyping,
    bool? isSendButtonEnabled,
    bool? shouldShrinkAppBar,
    bool? isTtsMuted,
    bool? isTtsActive,
    bool? showMuteIcon,
    bool? showUnMuteIcon,
    bool? isTtsPlaying,
    bool? isLoading,
  }) {
    return ChatUIState(
      isTyping: isTyping ?? this.isTyping,
      isSendButtonEnabled: isSendButtonEnabled ?? this.isSendButtonEnabled,
      shouldShrinkAppBar: shouldShrinkAppBar ?? this.shouldShrinkAppBar,
      isTtsMuted: isTtsMuted ?? this.isTtsMuted,
      isTtsActive: isTtsActive ?? this.isTtsActive,
      showMuteIcon: showMuteIcon ?? this.showMuteIcon,
      showUnMuteIcon: showUnMuteIcon ?? this.showUnMuteIcon,
      isTtsPlaying: isTtsPlaying ?? this.isTtsPlaying,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isTyping': isTyping,
      'isSendButtonEnabled': isSendButtonEnabled,
      'shouldShrinkAppBar': shouldShrinkAppBar,
      'isTtsMuted': isTtsMuted,
      'isTtsActive': isTtsActive,
      'showMuteIcon': showMuteIcon,
      'showUnMuteIcon': showUnMuteIcon,
      'isTtsPlaying': isTtsPlaying,
      'isLoading': isLoading,
    };
  }

  factory ChatUIState.fromJson(Map<String, dynamic> json) {
    return ChatUIState(
      isTyping: json['isTyping'],
      isSendButtonEnabled: json['isSendButtonEnabled'],
      shouldShrinkAppBar: json['shouldShrinkAppBar'],
      isTtsMuted: json['isTtsMuted'],
      isTtsActive: json['isTtsActive'],
      showMuteIcon: json['showMuteIcon'],
      showUnMuteIcon: json['showUnMuteIcon'],
      isTtsPlaying: json['isTtsPlaying'],
      isLoading: json['isLoading'],
    );
  }
}

final chatUIStateLoader = FutureProvider<ChatUIState>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final storedState = prefs.getString('chatUIState');
  if (storedState != null) {
    return ChatUIState.fromJson(jsonDecode(storedState));
  }
  return ChatUIState();
});

final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatModel>>(
  (ref) => ChatNotifier(),
);

class ButtonStateNotifier extends StateNotifier<bool> {
  ButtonStateNotifier() : super(false);

  void disableButton() => state = true;
  void enableButton() => state = false;
}

final buttonDisabledProvider = StateNotifierProvider<ButtonStateNotifier, bool>(
  (ref) => ButtonStateNotifier(),
);

final chatUIState = StateProvider<ChatUIState>((ref) {
  final asyncState = ref.watch(chatUIStateLoader);

  return asyncState.when(
    data: (state) => state,
    loading: () => ChatUIState(),
    error: (err, stack) => ChatUIState(),
  );
});

final sendButtonEnabledProvider = StateProvider<bool>((ref) => false);

final isFirstScrollToEndProvider = StateProvider<bool>((ref) => true);

final buttonEnabledProvider = StateProvider<bool>((ref) => true);

final chatLoadingProvider = StateProvider<bool>((ref) => false);
