import '../../../../core/utils/amount_formatter.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../enums/transfer_status.dart';
import '../../../transactions/domain/models/transaction_reference.dart';

class UserTransfer {
  const UserTransfer({
    required this.id,
    required this.senderUserId,
    required this.senderDisplayName,
    required this.recipientUserId,
    required this.recipientDisplayName,
    required this.senderWalletId,
    required this.recipientWalletId,
    required this.currencyCode,
    required this.amountMinor,
    required this.status,
    this.note,
    this.senderReference,
    this.recipientReference,
    this.senderLedgerTransactionId,
    this.recipientLedgerTransactionId,
    this.linkedDebtSettlementId,
    required this.createdAt,
  });

  factory UserTransfer.fromJson(Map<String, dynamic> json) {
    return UserTransfer(
      id: json['id'] as String,
      senderUserId: json['senderUserId'] as String,
      senderDisplayName: json['senderDisplayName'] as String,
      recipientUserId: json['recipientUserId'] as String,
      recipientDisplayName: json['recipientDisplayName'] as String,
      senderWalletId: json['senderWalletId'] as String,
      recipientWalletId: json['recipientWalletId'] as String,
      currencyCode: json['currencyCode'] as String,
      amountMinor: (json['amountMinor'] as num).toInt(),
      status: TransferStatus.values.byName(json['status'] as String),
      note: json['note'] as String?,
      senderReference: json['senderReference'] == null
          ? null
          : TransactionReference.fromJson(
              json['senderReference'] as Map<String, dynamic>,
            ),
      recipientReference: json['recipientReference'] == null
          ? null
          : TransactionReference.fromJson(
              json['recipientReference'] as Map<String, dynamic>,
            ),
      senderLedgerTransactionId: json['senderLedgerTransactionId'] as String?,
      recipientLedgerTransactionId:
          json['recipientLedgerTransactionId'] as String?,
      linkedDebtSettlementId: json['linkedDebtSettlementId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  final String id;
  final String senderUserId;
  final String senderDisplayName;
  final String recipientUserId;
  final String recipientDisplayName;
  final String senderWalletId;
  final String recipientWalletId;
  final String currencyCode;
  final int amountMinor;
  final TransferStatus status;
  final String? note;
  final TransactionReference? senderReference;
  final TransactionReference? recipientReference;
  final String? senderLedgerTransactionId;
  final String? recipientLedgerTransactionId;
  final String? linkedDebtSettlementId;
  final DateTime createdAt;

  Currency get currency => currencyFromCode(currencyCode);

  String get amount => AmountFormatter.majorFromMinor(amountMinor).toString();

  bool involvesUser(String userId) {
    return senderUserId == userId || recipientUserId == userId;
  }

  bool isIncomingFor(String ownerUserId) => senderUserId != ownerUserId;

  TransactionReference? referenceFor(String ownerUserId) {
    return senderUserId == ownerUserId ? senderReference : recipientReference;
  }

  String? ledgerTransactionIdFor(String ownerUserId) {
    return senderUserId == ownerUserId
        ? senderLedgerTransactionId
        : recipientLedgerTransactionId;
  }

  UserTransfer copyWith({
    String? id,
    String? senderUserId,
    String? senderDisplayName,
    String? recipientUserId,
    String? recipientDisplayName,
    String? senderWalletId,
    String? recipientWalletId,
    String? currencyCode,
    int? amountMinor,
    TransferStatus? status,
    String? note,
    TransactionReference? senderReference,
    TransactionReference? recipientReference,
    String? senderLedgerTransactionId,
    String? recipientLedgerTransactionId,
    String? linkedDebtSettlementId,
    DateTime? createdAt,
  }) {
    return UserTransfer(
      id: id ?? this.id,
      senderUserId: senderUserId ?? this.senderUserId,
      senderDisplayName: senderDisplayName ?? this.senderDisplayName,
      recipientUserId: recipientUserId ?? this.recipientUserId,
      recipientDisplayName: recipientDisplayName ?? this.recipientDisplayName,
      senderWalletId: senderWalletId ?? this.senderWalletId,
      recipientWalletId: recipientWalletId ?? this.recipientWalletId,
      currencyCode: currencyCode ?? this.currencyCode,
      amountMinor: amountMinor ?? this.amountMinor,
      status: status ?? this.status,
      note: note ?? this.note,
      senderReference: senderReference ?? this.senderReference,
      recipientReference: recipientReference ?? this.recipientReference,
      senderLedgerTransactionId:
          senderLedgerTransactionId ?? this.senderLedgerTransactionId,
      recipientLedgerTransactionId:
          recipientLedgerTransactionId ?? this.recipientLedgerTransactionId,
      linkedDebtSettlementId:
          linkedDebtSettlementId ?? this.linkedDebtSettlementId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'senderUserId': senderUserId,
    'senderDisplayName': senderDisplayName,
    'recipientUserId': recipientUserId,
    'recipientDisplayName': recipientDisplayName,
    'senderWalletId': senderWalletId,
    'recipientWalletId': recipientWalletId,
    'currencyCode': currencyCode,
    'amountMinor': amountMinor,
    'status': status.name,
    'note': note,
    'senderReference': senderReference?.toJson(),
    'recipientReference': recipientReference?.toJson(),
    'senderLedgerTransactionId': senderLedgerTransactionId,
    'recipientLedgerTransactionId': recipientLedgerTransactionId,
    'linkedDebtSettlementId': linkedDebtSettlementId,
    'createdAt': createdAt.toIso8601String(),
  };
}
