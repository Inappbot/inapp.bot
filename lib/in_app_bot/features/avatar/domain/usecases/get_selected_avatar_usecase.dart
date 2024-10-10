import 'package:in_app_bot/in_app_bot/features/avatar/domain/entities/avatar_entity.dart';
import 'package:in_app_bot/in_app_bot/features/avatar/domain/repositories/avatar_repository.dart';

class GetSelectedAvatarUseCase {
  final AvatarRepository avatarRepository;

  GetSelectedAvatarUseCase({required this.avatarRepository});

  Future<AvatarEntity> call() {
    return avatarRepository.getSelectedAvatar();
  }
}
