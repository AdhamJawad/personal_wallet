import 'dart:convert';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/local_store.dart';
import '../../../../core/utils/id_generator.dart';
import '../../enums/conflict_resolution_strategy.dart';
import '../../enums/sync_operation_status.dart';
import '../../enums/sync_operation_type.dart';
import '../../models/conflict_record.dart';
import '../../models/conflict_summary.dart';
import '../../models/sync_operation.dart';
import '../../repositories/sync_queue_repository.dart';

class MockSyncQueueRepository implements SyncQueueRepository {
  MockSyncQueueRepository(this._localStore);

  final LocalStore _localStore;

  static String _operationsKey(String ownerUserId) =>
      'sync.operations.$ownerUserId';

  Future<List<SyncOperation>> _loadOperations(String ownerUserId) async {
    final String? rawValue = await _localStore.read(
      boxName: AppConstants.syncQueueBox,
      key: _operationsKey(ownerUserId),
    );

    if (rawValue == null || rawValue.isEmpty) {
      return const <SyncOperation>[];
    }

    final List<dynamic> decoded = jsonDecode(rawValue) as List<dynamic>;
    return decoded
        .map(
          (dynamic item) =>
              SyncOperation.fromJson(item as Map<String, dynamic>),
        )
        .toList(growable: false);
  }

  Future<void> _saveOperations(
    String ownerUserId,
    List<SyncOperation> operations,
  ) async {
    await _localStore.write(
      boxName: AppConstants.syncQueueBox,
      key: _operationsKey(ownerUserId),
      value: jsonEncode(
        operations.map((SyncOperation item) => item.toJson()).toList(),
      ),
    );
  }

  @override
  Future<SyncOperation> addOperation({
    required String ownerUserId,
    required String entityId,
    required SyncOperationType type,
    required Map<String, dynamic> payload,
  }) async {
    final DateTime now = DateTime.now().toUtc();
    final SyncOperation operation = SyncOperation(
      id: IdGenerator.next(),
      ownerUserId: ownerUserId,
      entityId: entityId,
      type: type,
      status: SyncOperationStatus.pending,
      payload: payload,
      createdAt: now,
      updatedAt: now,
    );
    final List<SyncOperation> operations = await _loadOperations(ownerUserId);
    await _saveOperations(
      ownerUserId,
      List<SyncOperation>.from(operations)..add(operation),
    );
    return operation;
  }

  @override
  Future<void> clearCompleted(String ownerUserId) async {
    final List<SyncOperation> operations = await _loadOperations(ownerUserId);
    await _saveOperations(
      ownerUserId,
      operations
          .where(
            (SyncOperation item) => item.status != SyncOperationStatus.synced,
          )
          .toList(growable: false),
    );
  }

  @override
  Future<List<ConflictSummary>> fetchConflicts(String ownerUserId) async {
    final List<SyncOperation> operations = await fetchOperations(ownerUserId);
    return operations
        .where((SyncOperation item) => item.conflictRecord != null)
        .map(
          (SyncOperation item) => ConflictSummary(
            operation: item,
            record: item.conflictRecord!,
            recommendedStrategy: item.conflictRecord!.recommendedStrategy,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<List<SyncOperation>> fetchOperations(String ownerUserId) async {
    final List<SyncOperation> operations = await _loadOperations(ownerUserId);
    final List<SyncOperation> ordered = List<SyncOperation>.from(operations)
      ..sort((SyncOperation left, SyncOperation right) {
        return right.createdAt.compareTo(left.createdAt);
      });
    return ordered;
  }

  @override
  Future<SyncOperation?> getOperationById({
    required String ownerUserId,
    required String operationId,
  }) async {
    final List<SyncOperation> operations = await _loadOperations(ownerUserId);
    return operations.cast<SyncOperation?>().firstWhere(
      (SyncOperation? item) => item?.id == operationId,
      orElse: () => null,
    );
  }

  Future<SyncOperation> _updateOperation({
    required String ownerUserId,
    required String operationId,
    required SyncOperation Function(SyncOperation existing) transform,
  }) async {
    final List<SyncOperation> operations = await _loadOperations(ownerUserId);
    final int index = operations.indexWhere(
      (SyncOperation item) => item.id == operationId,
    );

    if (index < 0) {
      throw const SyncQueueException('Sync operation was not found.');
    }

    final SyncOperation updated = transform(operations[index]);
    final List<SyncOperation> rewritten = List<SyncOperation>.from(operations)
      ..[index] = updated;
    await _saveOperations(ownerUserId, rewritten);
    return updated;
  }

  @override
  Future<SyncOperation> markConflict({
    required String ownerUserId,
    required String operationId,
    required String entityId,
    required ConflictResolutionStrategy recommendedStrategy,
    required Map<String, dynamic> localPayload,
    Map<String, dynamic>? remotePayload,
    String? summary,
  }) {
    final DateTime now = DateTime.now().toUtc();
    return _updateOperation(
      ownerUserId: ownerUserId,
      operationId: operationId,
      transform: (SyncOperation existing) {
        return existing.copyWith(
          status: SyncOperationStatus.conflict,
          conflictRecord: ConflictRecord(
            id: IdGenerator.next(),
            operationId: existing.id,
            entityId: entityId,
            recommendedStrategy: recommendedStrategy,
            localPayload: localPayload,
            remotePayload: remotePayload,
            summary: summary,
            createdAt: now,
            updatedAt: now,
          ),
          updatedAt: now,
          lastAttemptedAt: now,
        );
      },
    );
  }

  @override
  Future<SyncOperation> markFailed({
    required String ownerUserId,
    required String operationId,
    required String errorMessage,
  }) {
    final DateTime now = DateTime.now().toUtc();
    return _updateOperation(
      ownerUserId: ownerUserId,
      operationId: operationId,
      transform: (SyncOperation existing) {
        return existing.copyWith(
          status: SyncOperationStatus.failed,
          errorMessage: errorMessage,
          updatedAt: now,
          lastAttemptedAt: now,
        );
      },
    );
  }

  @override
  Future<SyncOperation> markSynced({
    required String ownerUserId,
    required String operationId,
  }) {
    final DateTime now = DateTime.now().toUtc();
    return _updateOperation(
      ownerUserId: ownerUserId,
      operationId: operationId,
      transform: (SyncOperation existing) {
        return existing.copyWith(
          status: SyncOperationStatus.synced,
          errorMessage: null,
          conflictRecord: null,
          updatedAt: now,
          syncedAt: now,
          lastAttemptedAt: now,
        );
      },
    );
  }

  @override
  Future<SyncOperation> retryOperation({
    required String ownerUserId,
    required String operationId,
  }) {
    final DateTime now = DateTime.now().toUtc();
    return _updateOperation(
      ownerUserId: ownerUserId,
      operationId: operationId,
      transform: (SyncOperation existing) {
        return existing.copyWith(
          status: SyncOperationStatus.pending,
          retryCount: existing.retryCount + 1,
          errorMessage: null,
          conflictRecord: null,
          updatedAt: now,
          lastAttemptedAt: now,
        );
      },
    );
  }
}

class SyncQueueException implements Exception {
  const SyncQueueException(this.message);

  final String message;

  @override
  String toString() => message;
}
