import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessagePartsNotifier extends StateNotifier<Map<int, List<Widget>>> {
  MessagePartsNotifier() : super({});

  void clearMessageParts() => state = {};

  void updateMessageParts(int index, List<Widget> parts) {
    state = {...state, index: parts};
  }
}

final messagePartsProvider =
    StateNotifierProvider<MessagePartsNotifier, Map<int, List<Widget>>>(
        (ref) => MessagePartsNotifier());
