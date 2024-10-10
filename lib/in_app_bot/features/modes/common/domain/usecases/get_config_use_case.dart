import 'package:in_app_bot/in_app_bot/features/modes/common/domain/entities/config_entity.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/repositories/config_repository.dart';

class GetConfigUseCase {
  final ConfigRepository repository;

  GetConfigUseCase(this.repository);

  Future<ConfigEntity> execute(String docName) async {
    return await repository.getConfig(docName);
  }
}
