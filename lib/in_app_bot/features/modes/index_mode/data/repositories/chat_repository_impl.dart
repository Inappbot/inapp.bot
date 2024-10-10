import 'package:in_app_bot/in_app_bot/application/services/chat_operations.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/entities/chat_model.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/repositories/chat_repository.dart';
import 'package:in_app_bot/in_app_bot/features/modes/data_plus_mode/data/services/dataplus_save_chat_service.dart';
import 'package:in_app_bot/in_app_bot/features/modes/index_mode/application/services/index_save_chat_service.dart';
import 'package:in_app_bot/in_app_bot/features/modes/index_mode/application/use_cases/index_check_previous_question_use_case.dart';
import 'package:in_app_bot/in_app_bot/features/modes/index_mode/data/datasources/index_previous_question_data_source.dart';
import 'package:in_app_bot/in_app_bot/presentation/providers/chat_notifier.dart';

class ChatRepositoryImpl implements ChatRepository {
  final Function(String)? addBotMessageCallback;
  final ChatNotifier _chatNotifier;
  final String _appUserId;
  final CheckPreviousQuestionUseCase _checkPreviousQuestionUseCase;
  final SaveChatServiceDataPlus _saveChatServiceDataPlus =
      SaveChatServiceDataPlus();

  ChatRepositoryImpl({
    this.addBotMessageCallback,
    required ChatNotifier chatNotifier,
    required String appUserId,
  })  : _chatNotifier = chatNotifier,
        _appUserId = appUserId,
        _checkPreviousQuestionUseCase =
            CheckPreviousQuestionUseCase(PreviousQuestionDataSource());

  @override
  Future<String?> checkPreviousQuestion(String msg) async {
    return await _checkPreviousQuestionUseCase.execute(msg);
  }

  @override
  Future<void> processPreviousAnswer(String msg, String previousAnswer) async {
    ChatOperationService.chatList
        .add(ChatModel(msg: msg, chatIndex: 0, isPreviousResponse: true));
    ChatOperationService.chatList.add(
        ChatModel(msg: previousAnswer, chatIndex: 1, isPreviousResponse: true));

    if (addBotMessageCallback != null) {
      await addBotMessageCallback!(previousAnswer);
    }

    String? currentChatId = _chatNotifier.currentChatId;
    if (currentChatId != null) {
      await SaveChatService().saveChat(_appUserId, currentChatId);
    }
  }

  @override
  List<ChatModel> getChatList() {
    return _chatNotifier.chatList;
  }

  @override
  void addChat(ChatModel chat) {
    _chatNotifier.addChat(chat);
  }

  @override
  void addChatList(List<ChatModel> chatList) {
    _chatNotifier.addChatList(chatList);
  }

  @override
  Future<void> saveChat(String appUserId, String chatId) async {
    await _saveChatServiceDataPlus.saveChatDataplus(appUserId, chatId);
  }

  @override
  Future<void> saveChatIndex() async {
    String? currentChatId = _chatNotifier.currentChatId;
    if (currentChatId != null) {
      await SaveChatService().saveChat(_appUserId, currentChatId);
    }
  }
}
