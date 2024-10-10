import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/application/services/chat_operations.dart';
import 'package:in_app_bot/in_app_bot/features/avatar/presentation/state/avatar_animation_provider.dart';
import 'package:in_app_bot/in_app_bot/features/chat_bubble/presentation/widgets/chat_mode_provider.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/domain/usecases/clear_notifications_use_case.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/presentation/state/notification_providers.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/presentation/widgets/notification_icon.dart';
import 'package:in_app_bot/in_app_bot/features/qr_assistant_scanner/presentation/providers/qr_ai_providers.dart';
import 'package:in_app_bot/in_app_bot/features/text_to_speech/presentation/providers/tts_provider.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/providers.dart';
import 'package:in_app_bot/in_app_bot/presentation/utils/chat_helpers.dart';
import 'package:in_app_bot/playground/onboarding/infrastructure/services/haptic_feedback_service.dart';

Widget buildLeftAppBarContent(BuildContext context, WidgetRef ref,
    String productbotName, dynamic chatState, Function clearChat) {
  return Consumer(
    builder: (context, ref, child) {
      final isButtonDisabled = ref.watch(buttonDisabledProvider);
      return IconButton(
        icon: const Icon(Icons.close),
        color: Theme.of(context).iconTheme.color,
        onPressed: isButtonDisabled
            ? null
            : () => handleIconButtonPress(
                ref, context, productbotName, chatState, clearChat),
      );
    },
  );
}

Future<void> handleIconButtonPress(WidgetRef ref, BuildContext context,
    String productbotName, dynamic chatState, Function clearChat) async {
  ref.read(buttonDisabledProvider.notifier).disableButton();
  ref.read(avatarAnimationProvider.notifier).pauseVideos();
  ref.read(selectedNotificationProvider.notifier).state = null;
  ref.read(productDataProvider.notifier).state = null;

  ref.read(chatUIState.notifier).state = ChatUIState().copyWith(
    isTtsMuted: ref.read(chatUIState.notifier).state.isTtsMuted,
    isTtsActive: ref.read(chatUIState.notifier).state.isTtsActive,
    isLoading: false,
  );

  ref.read(ttsHelperProvider.notifier).reset();
  ref.read(chatStateProvider.notifier).reset();

  try {
    saveChatOrHandleEmpty(ref, productbotName, chatState, clearChat);
    ref.read(clearNotificationsUseCaseProvider).call(ref);
  } catch (_) {
  } finally {
    ref.read(isFirstScrollToEndProvider.notifier).state = true;
    ref.read(buttonDisabledProvider.notifier).enableButton();
    Navigator.pop(context);
  }
}

void saveChatOrHandleEmpty(WidgetRef ref, String productbotName,
    dynamic chatState, Function clearChat) {
  if (productbotName.isNotEmpty) {
    clearChatAndMessageParts(ref);
    ChatOperationService.clearChatList();
  } else if (chatState.isNotEmpty) {
    clearChatAndMessageParts(ref);
    ChatOperationService.clearChatList();
  } else {
    log("There is no data in the chat list to save.");
  }
}

Widget buildRightAppBarContent(
    BuildContext context, WidgetRef ref, String appUserId) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      NotificationIcon(appUserId: appUserId),
      const SizedBox(width: 8.0),
      buildVolumeIconButton(context, ref),
    ],
  );
}

Widget buildVolumeIconButton(BuildContext context, WidgetRef ref) {
  final isTtsActive = ref.watch(chatUIState).isTtsActive;
  final isButtonEnabled = ref.watch(buttonEnabledProvider);

  return IconButton(
    icon: Icon(isTtsActive ? Icons.volume_up : Icons.volume_off),
    color: isTtsActive
        ? Theme.of(context).iconTheme.color
        : Theme.of(context).colorScheme.onSurface,
    onPressed: isButtonEnabled
        ? () async {
            toggleTts(ref);
            ref.read(buttonEnabledProvider.notifier).state = false;
            await Future.delayed(const Duration(seconds: 1));
            HapticFeedbackService.triggerFeedback();
            ref.read(buttonEnabledProvider.notifier).state = true;
          }
        : null,
  );
}

void toggleTts(WidgetRef ref) {
  final currentState = ref.read(chatUIState);
  final ttsHelper = ref.read(ttsHelperProvider.notifier);
  if (currentState.isTtsActive) {
    ttsHelper.stop();
  }

  final isTtsActive = !currentState.isTtsActive;
  ref.read(chatUIState.notifier).state =
      currentState.copyWith(isTtsActive: isTtsActive);
  handleMuteUnmuteClick(isTtsActive, ref);
}

void handleMuteUnmuteClick(bool isMuteClicked, WidgetRef ref) {
  final currentState = ref.read(chatUIState);
  final ttsRepository = ref.read(ttsRepositoryProvider);

  final double newVolume = currentState.isTtsMuted ? 1.0 : 0.0;
  final bool showMuteIcon = !currentState.isTtsMuted;
  final bool showUnMuteIcon = currentState.isTtsMuted;

  ttsRepository.setVolume(newVolume);
  ref.read(chatUIState.notifier).state = currentState.copyWith(
    isTtsMuted: !currentState.isTtsMuted,
    showMuteIcon: showMuteIcon,
    showUnMuteIcon: showUnMuteIcon,
  );

  Future.delayed(const Duration(seconds: 1), () {
    final updatedState = ref.read(chatUIState);
    if (updatedState.isTtsMuted != isMuteClicked) {
      ref.read(chatUIState.notifier).state = updatedState.copyWith(
        showMuteIcon: false,
        showUnMuteIcon: false,
      );
    }
  });
}
