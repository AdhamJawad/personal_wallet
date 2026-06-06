abstract interface class SyncEngine {
  Future<void> enqueue(String recordId);
  Future<void> processPending();
}
