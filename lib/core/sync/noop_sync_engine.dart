import 'sync_engine.dart';
import 'models/sync_operation.dart';

class NoopSyncEngine implements SyncEngine {
  const NoopSyncEngine();

  @override
  Future<void> enqueueOperation(SyncOperation operation) async {}

  @override
  Future<void> processPending(String ownerUserId) async {}
}
