import 'package:flutter/material.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/domain/usecases/get_config_use_case.dart';
import 'package:in_app_bot/in_app_bot/features/modes/common/presentation/utils/user_error.dart';
import 'package:in_app_bot/in_app_bot/features/modes/product_mode/data/datasources/config_data_source.dart';

class SendMessageGptService {
  final GetConfigUseCase getConfigUseCase =
      GetConfigUseCase(ConfigDataSource());

  Future<bool> preSendMessageCheck(
      bool isTyping, String message, BuildContext context) async {
    if (isTyping) {
      showUserErrorSnackBar('One message at a time, please.', context);
      return true;
    }
    if (message.trim().isEmpty) {
      return true;
    }
    return false;
  }

  Future<Map<String, dynamic>> getConfig(String configName) async {
    final configEntity = await getConfigUseCase.execute(configName);
    return configEntity.data;
  }
}
