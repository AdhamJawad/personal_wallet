import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_time_converter.dart';
import '../../../../shared/domain/models/money.dart';
import '../../../../shared/domain/enums/currency.dart';

part 'wallet_balance_snapshot.freezed.dart';
part 'wallet_balance_snapshot.g.dart';

@freezed
abstract class WalletBalanceSnapshot with _$WalletBalanceSnapshot {
  const factory WalletBalanceSnapshot({
    required String walletId,
    required Money usdBalance,
    required Money sypBalance,
    @DateTimeConverter() required DateTime asOf,
  }) = _WalletBalanceSnapshot;

  factory WalletBalanceSnapshot.fromJson(Map<String, dynamic> json) =>
      _$WalletBalanceSnapshotFromJson(json);
}

extension WalletBalanceSnapshotX on WalletBalanceSnapshot {
  static WalletBalanceSnapshot empty(String walletId) {
    return WalletBalanceSnapshot(
      walletId: walletId,
      usdBalance: Money(amountMinor: 0, currencyCode: Currency.usd.code),
      sypBalance: Money(amountMinor: 0, currencyCode: Currency.syp.code),
      asOf: DateTime.now().toUtc(),
    );
  }
}
