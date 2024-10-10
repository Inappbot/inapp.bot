class ChatModel {
  final String msg;
  final int chatIndex;
  final bool isPreviousResponse;

  const ChatModel({
    required this.msg,
    required this.chatIndex,
    this.isPreviousResponse = false,
  }) : assert(chatIndex >= 0, 'chatIndex cannot be negative');

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final int chatIndex = json["chatIndex"] as int;
    if (chatIndex < 0) {
      throw ArgumentError('chatIndex cannot be negative');
    }
    return ChatModel(
      msg: json["msg"] as String,
      chatIndex: chatIndex,
    );
  }

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "chatIndex": chatIndex,
      };

  ChatModel copyWith({
    String? msg,
    int? chatIndex,
    bool? isPreviousResponse,
  }) {
    return ChatModel(
      msg: msg ?? this.msg,
      chatIndex: chatIndex ?? this.chatIndex,
      isPreviousResponse: isPreviousResponse ?? this.isPreviousResponse,
    );
  }
}
