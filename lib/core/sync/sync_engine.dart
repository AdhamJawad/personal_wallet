import 'models/sync_operation.dart';

abstract interface class SyncEngine {
  Future<void> enqueueOperation(SyncOperation operation);
  Future<void> processPending(String ownerUserId);
}
