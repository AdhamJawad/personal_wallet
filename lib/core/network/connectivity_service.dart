abstract interface class ConnectivityService {
  Future<bool> get isConnected;
  Stream<bool> watchConnection();
}
