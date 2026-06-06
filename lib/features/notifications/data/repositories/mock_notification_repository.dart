import 'dart:convert';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/local_store.dart';
import '../../../../core/utils/id_generator.dart';
import '../../domain/enums/notification_type.dart';
import '../../domain/models/notification_item.dart';
import 'local_notification_repository.dart';

class MockNotificationRepository implements LocalNotificationRepository {
  MockNotificationRepository(this._localStore);

  final LocalStore _localStore;

  static String _notificationsKey(String ownerUserId) =>
      'notifications.$ownerUserId';

  Future<List<NotificationItem>> _loadNotifications(String ownerUserId) async {
    final String? rawValue = await _localStore.read(
      boxName: AppConstants.notificationsBox,
      key: _notificationsKey(ownerUserId),
    );
    if (rawValue == null || rawValue.isEmpty) {
      return const <NotificationItem>[];
    }
    final List<dynamic> decoded = jsonDecode(rawValue) as List<dynamic>;
    return decoded
        .map(
          (dynamic item) =>
              NotificationItem.fromJson(item as Map<String, dynamic>),
        )
        .toList(growable: false);
  }

  Future<void> _saveNotifications(
    String ownerUserId,
    List<NotificationItem> notifications,
  ) async {
    await _localStore.write(
      boxName: AppConstants.notificationsBox,
      key: _notificationsKey(ownerUserId),
      value: jsonEncode(
        notifications.map((NotificationItem item) => item.toJson()).toList(),
      ),
    );
  }

  @override
  Future<void> clearRead(String ownerUserId) async {
    final List<NotificationItem> notifications = await _loadNotifications(
      ownerUserId,
    );
    await _saveNotifications(
      ownerUserId,
      notifications
          .where((NotificationItem item) => !item.isRead)
          .toList(growable: false),
    );
  }

  @override
  Future<List<NotificationItem>> fetchNotifications(String ownerUserId) async {
    final List<NotificationItem> notifications = await _loadNotifications(
      ownerUserId,
    );
    final List<NotificationItem> ordered = List<NotificationItem>.from(
      notifications,
    )..sort((left, right) => right.createdAt.compareTo(left.createdAt));
    return ordered;
  }

  @override
  Future<NotificationItem> markAsRead({
    required String ownerUserId,
    required String notificationId,
  }) async {
    final DateTime now = DateTime.now().toUtc();
    final List<NotificationItem> notifications = await _loadNotifications(
      ownerUserId,
    );
    final int index = notifications.indexWhere(
      (NotificationItem item) => item.id == notificationId,
    );
    if (index < 0) {
      throw const NotificationRepositoryException('Notification not found.');
    }
    final NotificationItem updated = notifications[index].copyWith(
      isRead: true,
      readAt: now,
    );
    await _saveNotifications(
      ownerUserId,
      List<NotificationItem>.from(notifications)..[index] = updated,
    );
    return updated;
  }

  @override
  Future<NotificationItem> publishNotification({
    required String ownerUserId,
    required String title,
    required String message,
    required String type,
    String? relatedEntityId,
    String? relatedEntityType,
  }) async {
    final NotificationType resolvedType = NotificationType.values.firstWhere(
      (NotificationType item) => item.name == type,
    );
    final NotificationItem notification = NotificationItem(
      id: IdGenerator.next(),
      ownerUserId: ownerUserId,
      type: resolvedType,
      title: title,
      message: message,
      relatedEntityId: relatedEntityId,
      relatedEntityType: relatedEntityType,
      createdAt: DateTime.now().toUtc(),
    );
    final List<NotificationItem> notifications = await _loadNotifications(
      ownerUserId,
    );
    await _saveNotifications(
      ownerUserId,
      List<NotificationItem>.from(notifications)..add(notification),
    );
    return notification;
  }
}

class NotificationRepositoryException implements Exception {
  const NotificationRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
