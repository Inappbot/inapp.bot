import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/domain/entities/notification_entity.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/presentation/state/cached_notifications_provider.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/presentation/state/notification_providers.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/presentation/widgets/notification_list_item.dart';

final isUpdatingProvider = StateProvider<bool>((ref) => false);

class NotificationsStreamWidget extends ConsumerStatefulWidget {
  final String appUserId;

  const NotificationsStreamWidget({Key? key, required this.appUserId})
      : super(key: key);

  @override
  NotificationsStreamWidgetState createState() =>
      NotificationsStreamWidgetState();
}

class NotificationsStreamWidgetState
    extends ConsumerState<NotificationsStreamWidget>
    with TickerProviderStateMixin {
  List<AnimationController> _animationControllers = [];
  List<Animation<double>> _scaleAnimations = [];
  late AnimationController _loadingSpaceController;

  @override
  void initState() {
    super.initState();
    _loadingSpaceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cachedNotificationsProvider.notifier).refresh();
    });
  }

  Future<void> _refreshNotifications() async {
    final isUpdating = ref.read(isUpdatingProvider);
    if (isUpdating) return;

    ref.read(isUpdatingProvider.notifier).state = true;
    _loadingSpaceController.forward();

    try {
      await Future.delayed(const Duration(milliseconds: 200));

      final firestore = FirebaseFirestore.instance;
      final dbHelper = ref.read(databaseProvider);

      final syncStartTime = DateTime.now();
      log('Starting manual synchronization with Firestore at $syncStartTime');

      final lastSync = ref.read(lastSyncProvider);
      log('Last sync time: $lastSync');

      final query = firestore
          .collection('chatbots')
          .doc('alert')
          .collection('notifications')
          .orderBy('timestamp', descending: true);

      final notifications = await query.get();

      final firestoreNotifications = notifications.docs.map((doc) {
        final data = doc.data();
        return NotificationEntity(
          id: doc.id,
          type: data['type'],
          url: data['url'],
          title: data['title'],
          description: data['description'],
          timestamp:
              (data['timestamp'] as Timestamp).toDate().millisecondsSinceEpoch,
          linkToGo: data['link_to_go'],
          textButton: data['text_button'],
          context: data['context'],
        );
      }).toList();

      log('Fetched ${firestoreNotifications.length} notifications from Firestore');

      final localNotifications = await dbHelper.getNotifications();
      log('Existing notifications in local database: ${localNotifications.length}');

      final newNotifications = firestoreNotifications.where((notification) {
        return !localNotifications.any((local) => local.id == notification.id);
      }).toList();

      log('New notifications to add: ${newNotifications.length}');

      final notificationsToDelete = localNotifications.where((local) {
        return !firestoreNotifications
            .any((firestore) => firestore.id == local.id);
      }).toList();

      if (newNotifications.isNotEmpty) {
        await dbHelper.insertNotifications(newNotifications);
        log('${newNotifications.length} new notifications added to local database');
      } else {
        log('No new notifications found');
      }

      if (notificationsToDelete.isNotEmpty) {
        await dbHelper.deleteNotifications(
            notificationsToDelete.map((n) => n.id).toList());
        log('${notificationsToDelete.length} notifications removed from local database');
      }

      ref.read(lastSyncProvider.notifier).updateLastSync(syncStartTime);
      log('Last sync updated to: $syncStartTime');

      final updatedNotifications = await dbHelper.getNotifications();

      ref
          .read(cachedNotificationsProvider.notifier)
          .updateNotifications(updatedNotifications);

      final syncEndTime = DateTime.now();
      log('Manual synchronization complete at $syncEndTime. Total notifications in local database: ${updatedNotifications.length}');
      log('Sync duration: ${syncEndTime.difference(syncStartTime)}');

      if (_animationControllers.length != updatedNotifications.length) {
        _initializeAnimations(updatedNotifications.length);
      }
    } catch (e) {
      log('Error refreshing notifications: $e');
    } finally {
      await Future.delayed(const Duration(milliseconds: 300));
      ref.read(isUpdatingProvider.notifier).state = false;
      _loadingSpaceController.reverse();
    }
  }

  void _initializeAnimations(int itemCount) {
    for (var controller in _animationControllers) {
      controller.dispose();
    }

    _animationControllers = List.generate(
      itemCount,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this,
      ),
    );

    _scaleAnimations = _animationControllers.map((controller) {
      return Tween<double>(begin: 0.90, end: 1).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.elasticOut,
        ),
      );
    }).toList();

    _playAnimations();
  }

  void _playAnimations() {
    for (int i = 0; i < _animationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _animationControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    _loadingSpaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: _refreshNotifications,
          builder: (_, __, ___, ____, _____) => const SizedBox.shrink(),
        ),
        SliverToBoxAdapter(
          child: AnimatedBuilder(
            animation: _loadingSpaceController,
            builder: (context, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: ref.watch(isUpdatingProvider)
                    ? 20 * _loadingSpaceController.value
                    : 0,
                child: const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Consumer(
            builder: (context, ref, child) {
              final cachedNotifications =
                  ref.watch(cachedNotificationsProvider);
              return cachedNotifications.when(
                data: (notifications) {
                  if (_animationControllers.length != notifications.length) {
                    _initializeAnimations(notifications.length);
                  }

                  if (notifications.isEmpty) {
                    return const SizedBox(
                      height: 300,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications_off_rounded,
                                size: 64, color: Colors.blue),
                            SizedBox(height: 16),
                            Text('No notifications yet',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blue,
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w300)),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      if (index < _scaleAnimations.length) {
                        return ScaleTransition(
                          scale: _scaleAnimations[index],
                          child: NotificationListItem(
                            notification: notification,
                            appUserId: widget.appUserId,
                          ),
                        );
                      } else {
                        return NotificationListItem(
                          notification: notification,
                          appUserId: widget.appUserId,
                        );
                      }
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                error: (error, stackTrace) => Center(
                  child: Text('Error: $error',
                      style: const TextStyle(
                          color: Colors.red, fontFamily: 'poppins')),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
