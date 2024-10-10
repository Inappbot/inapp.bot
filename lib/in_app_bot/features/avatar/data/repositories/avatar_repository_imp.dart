import 'package:in_app_bot/in_app_bot/data/datasources/remote/remote_data_source.dart';
import 'package:in_app_bot/in_app_bot/features/avatar/domain/entities/avatar_entity.dart';
import 'package:in_app_bot/in_app_bot/features/avatar/domain/repositories/avatar_repository.dart';

class AvatarRepositoryImp implements AvatarRepository {
  final RemoteDataSource remoteDataSource;

  AvatarRepositoryImp({required this.remoteDataSource});

  @override
  Future<AvatarEntity> getSelectedAvatar() {
    return remoteDataSource.getSelectedAvatar();
  }
}
