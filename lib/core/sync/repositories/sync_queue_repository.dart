import '../enums/conflict_resolution_strategy.dart';
import '../enums/sync_operation_type.dart';
import '../models/conflict_summary.dart';
import '../models/sync_operation.dart';

abstract interface class SyncQueueRepository {
  Future<SyncOperation> addOperation({
    required String ownerUserId,
    required String entityId,
    required SyncOperationType type,
    required Map<String, dynamic> payload,
  });
  Future<void> clearCompleted(String ownerUserId);
  Future<List<ConflictSummary>> fetchConflicts(String ownerUserId);
  Future<List<SyncOperation>> fetchOperations(String ownerUserId);
  Future<SyncOperation?> getOperationById({
    required String ownerUserId,
    required String operationId,
  });
  Future<SyncOperation> markConflict({
    required String ownerUserId,
    required String operationId,
    required String entityId,
    required ConflictResolutionStrategy recommendedStrategy,
    required Map<String, dynamic> localPayload,
    Map<String, dynamic>? remotePayload,
    String? summary,
  });
  Future<SyncOperation> markFailed({
    required String ownerUserId,
    required String operationId,
    required String errorMessage,
  });
  Future<SyncOperation> markSynced({
    required String ownerUserId,
    required String operationId,
  });
  Future<SyncOperation> retryOperation({
    required String ownerUserId,
    required String operationId,
  });
}
