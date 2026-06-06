// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_dashboard_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletDashboardSnapshot _$WalletDashboardSnapshotFromJson(
  Map<String, dynamic> json,
) => _WalletDashboardSnapshot(
  ownerUserId: json['ownerUserId'] as String,
  totalUsd: json['totalUsd'] as String,
  totalSyp: json['totalSyp'] as String,
  walletSummaries: (json['walletSummaries'] as List<dynamic>)
      .map((e) => WalletOverview.fromJson(e as Map<String, dynamic>))
      .toList(),
  recentActivities: (json['recentActivities'] as List<dynamic>)
      .map((e) => WalletActivityItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WalletDashboardSnapshotToJson(
  _WalletDashboardSnapshot instance,
) => <String, dynamic>{
  'ownerUserId': instance.ownerUserId,
  'totalUsd': instance.totalUsd,
  'totalSyp': instance.totalSyp,
  'walletSummaries': instance.walletSummaries,
  'recentActivities': instance.recentActivities,
};
