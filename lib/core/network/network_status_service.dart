enum NetworkStatus { online, offline, constrained, unknown }

abstract interface class NetworkStatusService {
  Future<NetworkStatus> currentStatus();
  Stream<NetworkStatus> watchStatus();
}
