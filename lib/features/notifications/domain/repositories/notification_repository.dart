import '../models/notification_item.dart';

abstract interface class NotificationRepository {
  Future<void> clearRead(String ownerUserId);
  Future<List<NotificationItem>> fetchNotifications(String ownerUserId);
  Future<NotificationItem> publishNotification({
    required String ownerUserId,
    required String title,
    required String message,
    required String type,
    String? relatedEntityId,
    String? relatedEntityType,
  });
  Future<NotificationItem> markAsRead({
    required String ownerUserId,
    required String notificationId,
  });
}
