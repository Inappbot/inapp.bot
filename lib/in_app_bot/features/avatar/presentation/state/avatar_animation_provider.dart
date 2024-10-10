import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/data/datasources/remote/remote_data_source.dart';
import 'package:in_app_bot/in_app_bot/data/datasources/remote/remote_data_source_imp.dart';
import 'package:in_app_bot/in_app_bot/features/avatar/data/repositories/avatar_repository_imp.dart';
import 'package:in_app_bot/in_app_bot/features/avatar/domain/repositories/avatar_repository.dart';
import 'package:in_app_bot/in_app_bot/features/avatar/domain/usecases/get_selected_avatar_usecase.dart';

import 'avatar_animation_state.dart';
import 'avatar_animation_state_notifier.dart';

final avatarAnimationProvider =
    StateNotifierProvider<AvatarAnimationNotifier, AvatarAnimationState>(
  (ref) {
    return AvatarAnimationNotifier(
      getSelectedAvatarUseCase: ref.watch(_getSelectedAvatarUseCase),
    );
  },
);

final _getSelectedAvatarUseCase = Provider<GetSelectedAvatarUseCase>((ref) {
  return GetSelectedAvatarUseCase(
      avatarRepository: ref.watch(_avatarRepositoryProvider));
});

final _avatarRepositoryProvider = Provider<AvatarRepository>((ref) {
  return AvatarRepositoryImp(
      remoteDataSource: ref.watch(_remoteDataSourceProvider));
});

final _remoteDataSourceProvider = Provider<RemoteDataSource>((ref) {
  return RemoteDataSourceImp();
});
