import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/enums/notification_type.dart';
import '../../domain/models/notification_item.dart';

part 'notification_state.freezed.dart';

@freezed
abstract class NotificationState with _$NotificationState {
  const NotificationState._();

  const factory NotificationState({
    @Default(false) bool isLoading,
    @Default(<NotificationItem>[]) List<NotificationItem> notifications,
    NotificationType? filter,
    String? errorMessage,
  }) = _NotificationState;

  List<NotificationItem> get visibleNotifications {
    final NotificationType? activeFilter = filter;
    if (activeFilter == null) {
      return notifications;
    }
    return notifications
        .where((NotificationItem item) => item.type == activeFilter)
        .toList(growable: false);
  }
}
