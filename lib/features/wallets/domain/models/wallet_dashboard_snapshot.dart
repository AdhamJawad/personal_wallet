import 'package:freezed_annotation/freezed_annotation.dart';

import 'wallet_activity_item.dart';
import 'wallet_overview.dart';

part 'wallet_dashboard_snapshot.freezed.dart';
part 'wallet_dashboard_snapshot.g.dart';

@freezed
abstract class WalletDashboardSnapshot with _$WalletDashboardSnapshot {
  const factory WalletDashboardSnapshot({
    required String ownerUserId,
    required String totalUsd,
    required String totalSyp,
    required List<WalletOverview> walletSummaries,
    required List<WalletActivityItem> recentActivities,
  }) = _WalletDashboardSnapshot;

  factory WalletDashboardSnapshot.fromJson(Map<String, dynamic> json) =>
      _$WalletDashboardSnapshotFromJson(json);
}
