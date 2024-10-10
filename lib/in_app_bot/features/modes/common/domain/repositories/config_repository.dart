import 'package:in_app_bot/in_app_bot/features/modes/common/domain/entities/config_entity.dart';

abstract class ConfigRepository {
  Future<ConfigEntity> getConfig(String docName);
}
