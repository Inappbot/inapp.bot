import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/presentation/state/notification_providers.dart';

class ClearNotificationsUseCase {
  void call(WidgetRef ref) {
    ref.read(selectedNotificationProvider.notifier).state = null;
  }
}

final clearNotificationsUseCaseProvider =
    Provider((ref) => ClearNotificationsUseCase());
