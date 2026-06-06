import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/notifications/domain/services/notification_publisher.dart';
import '../enums/conflict_resolution_strategy.dart';
import '../models/conflict_summary.dart';
import '../models/sync_operation.dart';
import '../repositories/sync_queue_repository.dart';
import 'sync_state.dart';

class SyncController extends StateNotifier<SyncState> {
  SyncController({
    required SyncQueueRepository syncQueueRepository,
    required NotificationPublisher notificationPublisher,
    required String? ownerUserId,
  }) : _syncQueueRepository = syncQueueRepository,
       _notificationPublisher = notificationPublisher,
       _ownerUserId = ownerUserId,
       super(const SyncState()) {
    if (ownerUserId != null) {
      initialize();
    }
  }

  final SyncQueueRepository _syncQueueRepository;
  final NotificationPublisher _notificationPublisher;
  final String? _ownerUserId;

  String get _resolvedOwnerUserId {
    final String? ownerUserId = _ownerUserId;
    if (ownerUserId == null) {
      throw const SyncControllerException('No authenticated user found.');
    }
    return ownerUserId;
  }

  Future<void> _reload() async {
    final List<SyncOperation> operations = await _syncQueueRepository
        .fetchOperations(_resolvedOwnerUserId);
    final List<ConflictSummary> conflicts = await _syncQueueRepository
        .fetchConflicts(_resolvedOwnerUserId);
    state = state.copyWith(
      operations: operations,
      conflicts: conflicts,
      isLoading: false,
      errorMessage: null,
    );
  }

  Future<void> clearCompleted() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _syncQueueRepository.clearCompleted(_resolvedOwnerUserId);
      await _reload();
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> initialize() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _reload();
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> markConflict({
    required String operationId,
    required String entityId,
    required Map<String, dynamic> localPayload,
    Map<String, dynamic>? remotePayload,
    String? summary,
    ConflictResolutionStrategy recommendedStrategy =
        ConflictResolutionStrategy.manualReview,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _syncQueueRepository.markConflict(
        ownerUserId: _resolvedOwnerUserId,
        operationId: operationId,
        entityId: entityId,
        recommendedStrategy: recommendedStrategy,
        localPayload: localPayload,
        remotePayload: remotePayload,
        summary: summary,
      );
      await _reload();
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> markFailed({
    required String operationId,
    required String errorMessage,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _syncQueueRepository.markFailed(
        ownerUserId: _resolvedOwnerUserId,
        operationId: operationId,
        errorMessage: errorMessage,
      );
      await _notificationPublisher.publish(
        ownerUserId: _resolvedOwnerUserId,
        type: 'syncFailure',
        title: 'Sync failed',
        message: errorMessage,
        relatedEntityId: operationId,
        relatedEntityType: 'syncOperation',
      );
      await _reload();
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> markSynced(String operationId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _syncQueueRepository.markSynced(
        ownerUserId: _resolvedOwnerUserId,
        operationId: operationId,
      );
      await _notificationPublisher.publish(
        ownerUserId: _resolvedOwnerUserId,
        type: 'syncSuccess',
        title: 'Sync succeeded',
        message: 'An operation was marked as synced.',
        relatedEntityId: operationId,
        relatedEntityType: 'syncOperation',
      );
      await _reload();
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> retryOperation(String operationId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _syncQueueRepository.retryOperation(
        ownerUserId: _resolvedOwnerUserId,
        operationId: operationId,
      );
      await _reload();
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }
}

class SyncControllerException implements Exception {
  const SyncControllerException(this.message);

  final String message;

  @override
  String toString() => message;
}
