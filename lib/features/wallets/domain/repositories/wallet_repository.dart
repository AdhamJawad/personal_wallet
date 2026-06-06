import '../models/wallet_dashboard_snapshot.dart';
import '../models/wallet_overview.dart';

abstract interface class WalletRepository {
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
