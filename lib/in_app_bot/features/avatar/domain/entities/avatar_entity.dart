import 'package:equatable/equatable.dart';

class AvatarEntity extends Equatable {
  final String ethnicity;
  final String gender;
  final String hairstyle;
  final bool isSelected;
  final String name;
  final String photo;
  final String videoChat;
  final String videoTalking;
  final String avatarLoading;
  final String age;

  const AvatarEntity({
    required this.age,
    required this.avatarLoading,
    required this.ethnicity,
    required this.gender,
    required this.hairstyle,
    required this.isSelected,
    required this.name,
    required this.photo,
    required this.videoChat,
    required this.videoTalking,
  });

  @override
  List<Object?> get props => [
        age,
        avatarLoading,
        ethnicity,
        gender,
        hairstyle,
        isSelected,
        name,
        photo,
        videoChat,
        videoTalking,
      ];

  @override
  bool get stringify => true;
}
