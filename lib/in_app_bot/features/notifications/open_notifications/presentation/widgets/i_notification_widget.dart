import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/domain/entities/notification_entity.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/open_notifications/domain/services/notification_service.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/open_notifications/presentation/utils/platform_specific_icons.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/open_notifications/presentation/widgets/media_content_widget.dart';
import 'package:intl/intl.dart';

class INotificationWidget extends ConsumerWidget {
  final NotificationEntity notification;

  const INotificationWidget({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              MediaContentWidget(notification: notification),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 8),
                    Text(
                      notification.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildFooter(context, ref),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      notification.title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildFooter(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat('dd MMM yyyy, HH:mm').format(
            DateTime.fromMillisecondsSinceEpoch(notification.timestamp),
          ),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(PlatformSpecificIcons.share),
              onPressed: () => ref
                  .read(notificationServiceProvider)
                  .shareNotification(notification),
            ),
          ],
        ),
      ],
    );
  }
}
