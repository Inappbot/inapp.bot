import 'package:in_app_bot/in_app_bot/features/avatar/domain/entities/avatar_entity.dart';

class AvatarModel extends AvatarEntity {
  const AvatarModel({
    required super.age,
    required super.avatarLoading,
    required super.ethnicity,
    required super.gender,
    required super.hairstyle,
    required super.isSelected,
    required super.name,
    required super.photo,
    required super.videoChat,
    required super.videoTalking,
  });

  factory AvatarModel.fromMap(Map<String, dynamic> map) {
    return AvatarModel(
      age: map['age'] as String,
      avatarLoading: map['avatar_loading'] as String,
      ethnicity: map['ethnicity'] as String,
      gender: map['gender'] as String,
      hairstyle: map['hairstyle'] as String,
      isSelected: map['is_selected'] as bool,
      name: map['name'] as String,
      photo: map['photo'] as String,
      videoChat: map['video_chat'] as String,
      videoTalking: map['video_talking'] as String,
    );
  }
}
