import '../../../../core/network/remote_data_source.dart';
import '../../domain/models/wallet_dashboard_snapshot.dart';
import '../../domain/models/wallet_overview.dart';

abstract interface class WalletRemoteDataSource implements RemoteDataSource {
  Future<WalletOverview> archiveWallet({
    required String ownerUserId,
    required String walletId,
  });
  Future<WalletOverview> createWallet({
    required String ownerUserId,
    required String name,
  });
  Future<WalletDashboardSnapshot> fetchDashboardSnapshot(String ownerUserId);
  Future<List<WalletOverview>> fetchWallets(String ownerUserId);
  Future<WalletOverview?> getWalletById({
    required String ownerUserId,
    required String walletId,
  });
  Future<WalletOverview> renameWallet({
    required String ownerUserId,
    required String walletId,
    required String name,
  });
}
