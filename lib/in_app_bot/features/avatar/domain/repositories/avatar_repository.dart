import 'package:in_app_bot/in_app_bot/features/avatar/domain/entities/avatar_entity.dart';

abstract class AvatarRepository {
  Future<AvatarEntity> getSelectedAvatar();
}
