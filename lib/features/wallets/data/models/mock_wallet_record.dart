import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/wallet.dart';

part 'mock_wallet_record.freezed.dart';
part 'mock_wallet_record.g.dart';

@freezed
abstract class MockWalletRecord with _$MockWalletRecord {
  const factory MockWalletRecord({
    required Wallet wallet,
    required String usdBalance,
    required String sypBalance,
  }) = _MockWalletRecord;

  factory MockWalletRecord.fromJson(Map<String, dynamic> json) =>
      _$MockWalletRecordFromJson(json);
}
