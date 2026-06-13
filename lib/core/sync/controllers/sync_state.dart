import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/sync_operation_status.dart';
import '../models/conflict_summary.dart';
import '../models/sync_operation.dart';

part 'sync_state.freezed.dart';

@freezed
abstract class SyncState with _$SyncState {
  const SyncState._();

  const factory SyncState({
    @Default(false) bool isLoading,
    @Default(<SyncOperation>[]) List<SyncOperation> operations,
    @Default(<ConflictSummary>[]) List<ConflictSummary> conflicts,
    String? errorMessage,
  }) = _SyncState;

  List<SyncOperation> get pendingOperations => operations
      .where((SyncOperation item) => item.status == SyncOperationStatus.pending)
      .toList(growable: false);

  List<SyncOperation> get syncedOperations => operations
      .where((SyncOperation item) => item.status == SyncOperationStatus.synced)
      .toList(growable: false);

  List<SyncOperation> get failedOperations => operations
      .where((SyncOperation item) => item.status == SyncOperationStatus.failed)
      .toList(growable: false);

  List<SyncOperation> get conflictOperations => operations
      .where(
        (SyncOperation item) => item.status == SyncOperationStatus.conflict,
      )
      .toList(growable: false);
}
