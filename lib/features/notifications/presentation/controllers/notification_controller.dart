import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/enums/notification_type.dart';
import '../../domain/models/notification_item.dart';
import '../../domain/repositories/notification_repository.dart';
import 'notification_state.dart';

class NotificationController extends StateNotifier<NotificationState> {
  NotificationController({
    required NotificationRepository notificationRepository,
    required String? ownerUserId,
  }) : _notificationRepository = notificationRepository,
       _ownerUserId = ownerUserId,
       super(const NotificationState()) {
    if (ownerUserId != null) {
      initialize();
    }
  }

  final NotificationRepository _notificationRepository;
  final String? _ownerUserId;

  String get _resolvedOwnerUserId {
    final String? ownerUserId = _ownerUserId;
    if (ownerUserId == null) {
      throw const NotificationControllerException(
        'No authenticated user found.',
      );
    }
    return ownerUserId;
  }

  Future<void> initialize() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final List<NotificationItem> notifications = await _notificationRepository
          .fetchNotifications(_resolvedOwnerUserId);
      state = state.copyWith(
        isLoading: false,
        notifications: notifications,
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> clearRead() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _notificationRepository.clearRead(_resolvedOwnerUserId);
      await initialize();
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> markAsRead(String notificationId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _notificationRepository.markAsRead(
        ownerUserId: _resolvedOwnerUserId,
        notificationId: notificationId,
      );
      await initialize();
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  void setFilter(NotificationType? type) {
    state = state.copyWith(filter: type);
  }
}

class NotificationControllerException implements Exception {
  const NotificationControllerException(this.message);

  final String message;

  @override
  String toString() => message;
}
