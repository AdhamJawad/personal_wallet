import 'package:freezed_annotation/freezed_annotation.dart';

import 'wallet.dart';
import 'wallet_balance_snapshot.dart';

part 'wallet_overview.freezed.dart';
part 'wallet_overview.g.dart';

@freezed
abstract class WalletOverview with _$WalletOverview {
  const factory WalletOverview({
    required Wallet wallet,
    required WalletBalanceSnapshot balance,
  }) = _WalletOverview;

  factory WalletOverview.fromJson(Map<String, dynamic> json) =>
      _$WalletOverviewFromJson(json);
}
