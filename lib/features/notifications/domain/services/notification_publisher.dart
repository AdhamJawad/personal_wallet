import '../repositories/notification_repository.dart';

class NotificationPublisher {
  const NotificationPublisher(this._notificationRepository);

  final NotificationRepository _notificationRepository;

  Future<void> publish({
    required String ownerUserId,
    required String type,
    required String title,
    required String message,
    String? relatedEntityId,
    String? relatedEntityType,
  }) {
    return _notificationRepository.publishNotification(
      ownerUserId: ownerUserId,
      title: title,
      message: message,
      type: type,
      relatedEntityId: relatedEntityId,
      relatedEntityType: relatedEntityType,
    );
  }
}
