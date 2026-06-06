import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_time_converter.dart';
import '../enums/notification_type.dart';

part 'notification_item.freezed.dart';
part 'notification_item.g.dart';

@freezed
abstract class NotificationItem with _$NotificationItem {
  const factory NotificationItem({
    required String id,
    required String ownerUserId,
    required NotificationType type,
    required String title,
    required String message,
    String? relatedEntityId,
    String? relatedEntityType,
    @Default(false) bool isRead,
    @DateTimeConverter() DateTime? readAt,
    @DateTimeConverter() required DateTime createdAt,
  }) = _NotificationItem;

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);
}
