import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/chat_bubble/domain/enums/chat_mode.dart';
import 'package:in_app_bot/in_app_bot/features/chat_bubble/presentation/widgets/chat_mode_provider.dart';
import 'package:in_app_bot/in_app_bot/features/index_frequent_messages/application/notifiers/search_notifier.dart';

class QuestionsNotifier extends StateNotifier<List<String>> {
  final ChatMode mode;

  QuestionsNotifier(this.mode) : super([]);

  Future<void> fetchQuestionsFromFirebase() async {
    final CollectionReference collection = _getCollectionReference();

    final QuerySnapshot snapshot = await collection.get();
    List<String> fetchedQuestions = [];

    for (var doc in snapshot.docs) {
      try {
        if (doc.get('frequency_message') == true) {
          fetchedQuestions.add(doc.get('question'));
        }
      } catch (e) {
        log("Error getting field 'question' or 'frequency_message': $e");
      }
    }

    state = fetchedQuestions;
  }

  CollectionReference _getCollectionReference() {
    switch (mode) {
      case ChatMode.indexMode:
        return FirebaseFirestore.instance
            .collection('chatbots')
            .doc('f_p_resp')
            .collection('faq_previous_responses');
      case ChatMode.dataplusMode:
        return FirebaseFirestore.instance
            .collection('chatbots')
            .doc('data_plus')
            .collection('data_plus_previous_responses');
      case ChatMode.productMode:
        return FirebaseFirestore.instance
            .collection('chatbots')
            .doc('p_p_resp')
            .collection('product_previous_responses');
      // add more cases here if needed
      default:
        return FirebaseFirestore.instance
            .collection('chatbots')
            .doc('data_plus')
            .collection('data_plus_previous_responses');
    }
  }
}

final questionsProvider =
    StateNotifierProvider<QuestionsNotifier, List<String>>((ref) {
  final chatMode = ref.watch(chatStateProvider).mode ?? ChatMode.dataplusMode;
  return QuestionsNotifier(chatMode);
});

final filteredQuestionsProvider = Provider<List<String>>((ref) {
  final searchQuery = ref.watch(searchProvider).toLowerCase();
  final allQuestions = ref.watch(questionsProvider);

  return allQuestions.where((question) {
    return question.toLowerCase().contains(searchQuery);
  }).toList();
});

class ButtonStateNotifier extends StateNotifier<bool> {
  ButtonStateNotifier() : super(false);

  void setButtonPressed(bool pressed) {
    state = pressed;
  }
}

final buttonProvider = StateNotifierProvider<ButtonStateNotifier, bool>((ref) {
  return ButtonStateNotifier();
});

class PressedButtonIdNotifier extends StateNotifier<String?> {
  PressedButtonIdNotifier() : super(null);

  void setPressedButtonId(String? id) {
    state = id;
  }
}

final pressedButtonIdProvider =
    StateNotifierProvider<PressedButtonIdNotifier, String?>((ref) {
  return PressedButtonIdNotifier();
});
