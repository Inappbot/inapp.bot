import 'package:in_app_bot/in_app_bot/features/avatar/data/models/avatar_model.dart';

abstract class RemoteDataSource {
  Future<AvatarModel> getSelectedAvatar();
}
