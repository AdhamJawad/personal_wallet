import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_time_converter.dart';

part 'wallet_activity_item.freezed.dart';
part 'wallet_activity_item.g.dart';

@freezed
abstract class WalletActivityItem with _$WalletActivityItem {
  const factory WalletActivityItem({
    required String id,
    required String title,
    required String subtitle,
    required String walletId,
    required String walletName,
    @DateTimeConverter() required DateTime occurredAt,
  }) = _WalletActivityItem;

  factory WalletActivityItem.fromJson(Map<String, dynamic> json) =>
      _$WalletActivityItemFromJson(json);
}
