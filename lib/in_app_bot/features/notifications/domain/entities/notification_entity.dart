import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String type;
  final String url;
  final String title;
  final String description;
  final int timestamp;
  final String? linkToGo;
  final String textButton;
  final bool? isRead;
  final String? context;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.url,
    required this.title,
    required this.description,
    required this.timestamp,
    this.linkToGo,
    required this.textButton,
    this.isRead = false,
    this.context,
  });

  factory NotificationEntity.fromMap(Map<String, dynamic> map) {
    return NotificationEntity(
      id: map['id'],
      type: map['type'],
      url: map['url'],
      title: map['title'],
      description: map['description'],
      timestamp: map['timestamp'],
      linkToGo: map['link_to_go'],
      textButton: map['text_button'],
      isRead: map['is_read'] == 1,
      context: map['context'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'url': url,
      'title': title,
      'description': description,
      'timestamp': timestamp,
      'link_to_go': linkToGo,
      'text_button': textButton,
      'is_read': isRead == true ? 1 : 0,
      'context': context,
    };
  }

  @override
  List<Object?> get props => [
        id,
        type,
        url,
        title,
        description,
        timestamp,
        linkToGo,
        textButton,
        isRead,
        context,
      ];
}
