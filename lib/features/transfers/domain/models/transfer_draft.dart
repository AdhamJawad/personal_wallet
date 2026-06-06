import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/enums/currency.dart';

part 'transfer_draft.freezed.dart';
part 'transfer_draft.g.dart';

@freezed
abstract class TransferDraft with _$TransferDraft {
  const factory TransferDraft({
    required String senderWalletId,
    required String senderWalletName,
    required String recipientUserId,
    required String recipientDisplayName,
    required Currency currency,
    required String amount,
    String? note,
  }) = _TransferDraft;

  factory TransferDraft.fromJson(Map<String, dynamic> json) =>
      _$TransferDraftFromJson(json);
}
