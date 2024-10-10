import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/index_frequent_messages/application/controllers/frequent_messages_controller.dart';
import 'package:in_app_bot/in_app_bot/features/index_frequent_messages/application/notifiers/questions_notifier.dart';

class FrequentMessageButton extends ConsumerWidget {
  final Color iconColor;
  final Color textColor;
  final String message;
  final String buttonId;
  final String appUserId;
  final FrequentMessagesController controller;

  const FrequentMessageButton({
    super.key,
    required this.iconColor,
    required this.textColor,
    required this.message,
    required this.buttonId,
    required this.appUserId,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final pressedButtonId = ref.watch(pressedButtonIdProvider);
    final isPressed = pressedButtonId == buttonId;

    return ElevatedButton(
      style: buttonStyle(isPressed, textColor, isDarkMode),
      onPressed: () =>
          controller.handleButtonPress(buttonId, message, appUserId),
      child: buttonContent(isPressed, message, iconColor),
    );
  }

  ButtonStyle buttonStyle(bool isPressed, Color textColor, bool isDarkMode) {
    return ElevatedButton.styleFrom(
      foregroundColor: isPressed ? Colors.white : textColor,
      backgroundColor:
          isPressed ? const Color(0xFF2196F3) : backgroundColor(isDarkMode),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(10),
      elevation: 0,
    );
  }

  Color backgroundColor(bool isDarkMode) {
    return isDarkMode ? const Color.fromARGB(255, 60, 60, 60) : Colors.white;
  }

  Widget buttonContent(bool isPressed, String message, Color iconColor) {
    return Row(
      children: [
        Expanded(child: messageText(isPressed, message)),
        iconDisplay(isPressed, iconColor),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget messageText(bool isPressed, String message) {
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(message,
            style: TextStyle(
                fontSize: isPressed ? 16 : 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget iconDisplay(bool isPressed, Color iconColor) {
    return isPressed
        ? SlideTransition(
            position: controller.iconSlideAnimation,
            child: ScaleTransition(
              scale: controller.iconSizeAnimation,
              child:
                  const Icon(Icons.send_rounded, color: Colors.white, size: 18),
            ),
          )
        : Icon(Icons.send_rounded, color: iconColor, size: 18);
  }
}
