import '../../../../core/utils/amount_formatter.dart';
import 'wallet_activity_item.dart';
import 'wallet_overview.dart';

class WalletDashboardSnapshot {
  const WalletDashboardSnapshot({
    required this.ownerUserId,
    required this.totalUsdMinor,
    required this.totalSypMinor,
    required this.walletSummaries,
    required this.recentActivities,
  });

  factory WalletDashboardSnapshot.fromJson(Map<String, dynamic> json) {
    return WalletDashboardSnapshot(
      ownerUserId: json['ownerUserId'] as String,
      totalUsdMinor: (json['totalUsdMinor'] as num).toInt(),
      totalSypMinor: (json['totalSypMinor'] as num).toInt(),
      walletSummaries: (json['walletSummaries'] as List<dynamic>)
          .map(
            (dynamic item) =>
                WalletOverview.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
      recentActivities: (json['recentActivities'] as List<dynamic>)
          .map(
            (dynamic item) =>
                WalletActivityItem.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
    );
  }

  final String ownerUserId;
  final int totalUsdMinor;
  final int totalSypMinor;
  final List<WalletOverview> walletSummaries;
  final List<WalletActivityItem> recentActivities;

  String get totalUsd =>
      AmountFormatter.majorFromMinor(totalUsdMinor).toString();

  String get totalSyp =>
      AmountFormatter.majorFromMinor(totalSypMinor).toString();

  WalletDashboardSnapshot copyWith({
    String? ownerUserId,
    int? totalUsdMinor,
    int? totalSypMinor,
    List<WalletOverview>? walletSummaries,
    List<WalletActivityItem>? recentActivities,
  }) {
    return WalletDashboardSnapshot(
      ownerUserId: ownerUserId ?? this.ownerUserId,
      totalUsdMinor: totalUsdMinor ?? this.totalUsdMinor,
      totalSypMinor: totalSypMinor ?? this.totalSypMinor,
      walletSummaries: walletSummaries ?? this.walletSummaries,
      recentActivities: recentActivities ?? this.recentActivities,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'ownerUserId': ownerUserId,
    'totalUsdMinor': totalUsdMinor,
    'totalSypMinor': totalSypMinor,
    'walletSummaries': walletSummaries
        .map((WalletOverview item) => item.toJson())
        .toList(),
    'recentActivities': recentActivities
        .map((WalletActivityItem item) => item.toJson())
        .toList(),
  };
}
