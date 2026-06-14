import '../../../../core/utils/amount_formatter.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../transactions/domain/models/transaction_reference.dart';

class UserTransfer {
  const UserTransfer({
    required this.id,
    required this.ownerUserId,
    required this.reference,
    required this.senderUserId,
    required this.senderDisplayName,
    required this.recipientUserId,
    required this.recipientDisplayName,
    required this.senderWalletId,
    required this.recipientWalletId,
    required this.currencyCode,
    required this.amountMinor,
    this.note,
    required this.ledgerTransactionId,
    this.mirroredLedgerTransactionId,
    this.linkedDebtSettlementId,
    required this.createdAt,
  });

  factory UserTransfer.fromJson(Map<String, dynamic> json) {
    return UserTransfer(
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
      currencyCode: json['currencyCode'] as String,
      amountMinor: (json['amountMinor'] as num).toInt(),
      note: json['note'] as String?,
      ledgerTransactionId: json['ledgerTransactionId'] as String,
      mirroredLedgerTransactionId:
          json['mirroredLedgerTransactionId'] as String?,
      linkedDebtSettlementId: json['linkedDebtSettlementId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  final String id;
  final String ownerUserId;
  final TransactionReference reference;
  final String senderUserId;
  final String senderDisplayName;
  final String recipientUserId;
  final String recipientDisplayName;
  final String senderWalletId;
  final String recipientWalletId;
  final String currencyCode;
  final int amountMinor;
  final String? note;
  final String ledgerTransactionId;
  final String? mirroredLedgerTransactionId;
  final String? linkedDebtSettlementId;
  final DateTime createdAt;

  Currency get currency => currencyFromCode(currencyCode);

  String get amount => AmountFormatter.majorFromMinor(amountMinor).toString();

  UserTransfer copyWith({
    String? id,
    String? ownerUserId,
    TransactionReference? reference,
    String? senderUserId,
    String? senderDisplayName,
    String? recipientUserId,
    String? recipientDisplayName,
    String? senderWalletId,
    String? recipientWalletId,
    String? currencyCode,
    int? amountMinor,
    String? note,
    String? ledgerTransactionId,
    String? mirroredLedgerTransactionId,
    String? linkedDebtSettlementId,
    DateTime? createdAt,
  }) {
    return UserTransfer(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      reference: reference ?? this.reference,
      senderUserId: senderUserId ?? this.senderUserId,
      senderDisplayName: senderDisplayName ?? this.senderDisplayName,
      recipientUserId: recipientUserId ?? this.recipientUserId,
      recipientDisplayName: recipientDisplayName ?? this.recipientDisplayName,
      senderWalletId: senderWalletId ?? this.senderWalletId,
      recipientWalletId: recipientWalletId ?? this.recipientWalletId,
      currencyCode: currencyCode ?? this.currencyCode,
      amountMinor: amountMinor ?? this.amountMinor,
      note: note ?? this.note,
      ledgerTransactionId: ledgerTransactionId ?? this.ledgerTransactionId,
      mirroredLedgerTransactionId:
          mirroredLedgerTransactionId ?? this.mirroredLedgerTransactionId,
      linkedDebtSettlementId:
          linkedDebtSettlementId ?? this.linkedDebtSettlementId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'ownerUserId': ownerUserId,
    'reference': reference.toJson(),
    'senderUserId': senderUserId,
    'senderDisplayName': senderDisplayName,
    'recipientUserId': recipientUserId,
    'recipientDisplayName': recipientDisplayName,
    'senderWalletId': senderWalletId,
    'recipientWalletId': recipientWalletId,
    'currencyCode': currencyCode,
    'amountMinor': amountMinor,
    'note': note,
    'ledgerTransactionId': ledgerTransactionId,
    'mirroredLedgerTransactionId': mirroredLedgerTransactionId,
    'linkedDebtSettlementId': linkedDebtSettlementId,
    'createdAt': createdAt.toIso8601String(),
  };
}
