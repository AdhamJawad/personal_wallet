// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_transfer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserTransfer _$UserTransferFromJson(
  Map<String, dynamic> json,
) => _UserTransfer(
  id: json['id'] as String,
  ownerUserId: json['ownerUserId'] as String,
  reference: TransactionReference.fromJson(
    json['reference'] as Map<String, dynamic>,
  ),
  senderUserId: json['senderUserId'] as String,
  senderDisplayName: json['senderDisplayName'] as String,
  recipientUserId: json['recipientUserId'] as String,
  recipientDisplayName: json['recipientDisplayName'] as String,
  senderWalletId: json['senderWalletId'] as String,
  recipientWalletId: json['recipientWalletId'] as String,
  currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
  amount: json['amount'] as String,
  note: json['note'] as String?,
  ledgerTransactionId: json['ledgerTransactionId'] as String,
  mirroredLedgerTransactionId: json['mirroredLedgerTransactionId'] as String?,
  linkedDebtSettlementId: json['linkedDebtSettlementId'] as String?,
  createdAt: const DateTimeConverter().fromJson(json['createdAt'] as String),
);

Map<String, dynamic> _$UserTransferToJson(_UserTransfer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerUserId': instance.ownerUserId,
      'reference': instance.reference,
      'senderUserId': instance.senderUserId,
      'senderDisplayName': instance.senderDisplayName,
      'recipientUserId': instance.recipientUserId,
      'recipientDisplayName': instance.recipientDisplayName,
      'senderWalletId': instance.senderWalletId,
      'recipientWalletId': instance.recipientWalletId,
      'currency': _$CurrencyEnumMap[instance.currency]!,
      'amount': instance.amount,
      'note': instance.note,
      'ledgerTransactionId': instance.ledgerTransactionId,
      'mirroredLedgerTransactionId': instance.mirroredLedgerTransactionId,
      'linkedDebtSettlementId': instance.linkedDebtSettlementId,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
    };

const _$CurrencyEnumMap = {Currency.usd: 'usd', Currency.syp: 'syp'};
