import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/index_frequent_messages/application/notifiers/message_input_notifier.dart';
import 'package:in_app_bot/in_app_bot/features/index_frequent_messages/application/notifiers/questions_notifier.dart';
import 'package:in_app_bot/in_app_bot/features/index_frequent_messages/presentation/states/frequent_messages_state.dart';

class FrequentMessagesController {
  final FrequentMessagesWidgetState _state;
  final WidgetRef ref;

  late AnimationController iconAnimationController;
  late AnimationController rotationController;
  late Animation<double> iconSizeAnimation;
  late Animation<Offset> iconSlideAnimation;
  TextEditingController searchController = TextEditingController();

  FrequentMessagesController(this._state, this.ref);

  void init() {
    iconAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: _state,
    );

    rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: _state,
    );

    iconSizeAnimation =
        Tween<double>(begin: 1.0, end: 2.5).animate(iconAnimationController);
    iconSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(2.5, 0))
            .animate(iconAnimationController);

    iconAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        iconAnimationController.reverse();
      }
    });

    ref.read(questionsProvider.notifier).fetchQuestionsFromFirebase();
  }

  List<String> get filteredQuestions {
    final questions = ref.watch(questionsProvider);
    return questions
        .where((question) => question.contains(searchController.text))
        .toList();
  }

  void handleButtonPress(String buttonId, String message, String appUserId) {
    final buttonPressed = ref.read(buttonProvider);
    if (!buttonPressed) {
      ref.read(buttonProvider.notifier).setButtonPressed(true);
      ref.read(pressedButtonIdProvider.notifier).setPressedButtonId(buttonId);

      iconAnimationController.forward();
      iconAnimationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.pop(_state.context);
          iconAnimationController.removeStatusListener((status) {});

          ref.read(messageInputProvider.notifier).setMessage(message);

          ref.read(buttonProvider.notifier).setButtonPressed(false);
          ref.read(pressedButtonIdProvider.notifier).setPressedButtonId(null);
        }
      });
    }
  }

  void dispose() {
    iconAnimationController.dispose();
    rotationController.dispose();
    searchController.dispose();
  }
}
