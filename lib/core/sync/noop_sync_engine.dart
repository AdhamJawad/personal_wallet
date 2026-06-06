import 'sync_engine.dart';

class NoopSyncEngine implements SyncEngine {
  const NoopSyncEngine();

  @override
  Future<void> enqueue(String recordId) async {}

  @override
  Future<void> processPending() async {}
}
