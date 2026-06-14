import '../../../../core/utils/amount_formatter.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../../shared/domain/enums/transaction_type.dart';
import 'transaction_reference.dart';

class LedgerTransaction {
  const LedgerTransaction({
    required this.id,
    required this.reference,
    required this.type,
    required this.initiatedByUserId,
    this.senderDisplayName,
    this.recipientUserId,
    this.recipientDisplayName,
    this.sourceWalletId,
    this.destinationWalletId,
    required this.sourceCurrencyCode,
    this.destinationCurrencyCode,
    required this.sourceAmountMinor,
    this.destinationAmountMinor,
    this.exchangeRate,
    this.note,
    this.attachmentLabel,
    this.transferRecordId,
    this.debtSettlementId,
    this.relatedTransactionId,
    required this.createdAt,
  });

  factory LedgerTransaction.fromJson(Map<String, dynamic> json) {
    return LedgerTransaction(
      id: json['id'] as String,
      reference: TransactionReference.fromJson(
        json['reference'] as Map<String, dynamic>,
      ),
      type: TransactionType.values.byName(json['type'] as String),
      initiatedByUserId: json['initiatedByUserId'] as String,
      senderDisplayName: json['senderDisplayName'] as String?,
      recipientUserId: json['recipientUserId'] as String?,
      recipientDisplayName: json['recipientDisplayName'] as String?,
      sourceWalletId: json['sourceWalletId'] as String?,
      destinationWalletId: json['destinationWalletId'] as String?,
      sourceCurrencyCode: json['sourceCurrencyCode'] as String,
      destinationCurrencyCode: json['destinationCurrencyCode'] as String?,
      sourceAmountMinor: (json['sourceAmountMinor'] as num).toInt(),
      destinationAmountMinor: (json['destinationAmountMinor'] as num?)?.toInt(),
      exchangeRate: json['exchangeRate'] as String?,
      note: json['note'] as String?,
      attachmentLabel: json['attachmentLabel'] as String?,
      transferRecordId: json['transferRecordId'] as String?,
      debtSettlementId: json['debtSettlementId'] as String?,
      relatedTransactionId: json['relatedTransactionId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  final String id;
  final TransactionReference reference;
  final TransactionType type;
  final String initiatedByUserId;
  final String? senderDisplayName;
  final String? recipientUserId;
  final String? recipientDisplayName;
  final String? sourceWalletId;
  final String? destinationWalletId;
  final String sourceCurrencyCode;
  final String? destinationCurrencyCode;
  final int sourceAmountMinor;
  final int? destinationAmountMinor;
  final String? exchangeRate;
  final String? note;
  final String? attachmentLabel;
  final String? transferRecordId;
  final String? debtSettlementId;
  final String? relatedTransactionId;
  final DateTime createdAt;

  Currency get sourceCurrency => currencyFromCode(sourceCurrencyCode);

  Currency? get destinationCurrency => destinationCurrencyCode == null
      ? null
      : currencyFromCode(destinationCurrencyCode!);

  String get sourceAmount =>
      AmountFormatter.majorFromMinor(sourceAmountMinor).toString();

  String? get destinationAmount => destinationAmountMinor == null
      ? null
      : AmountFormatter.majorFromMinor(destinationAmountMinor!).toString();

  LedgerTransaction copyWith({
    String? id,
    TransactionReference? reference,
    TransactionType? type,
    String? initiatedByUserId,
    String? senderDisplayName,
    String? recipientUserId,
    String? recipientDisplayName,
    String? sourceWalletId,
    String? destinationWalletId,
    String? sourceCurrencyCode,
    String? destinationCurrencyCode,
    int? sourceAmountMinor,
    int? destinationAmountMinor,
    bool clearDestinationAmountMinor = false,
    String? exchangeRate,
    String? note,
    String? attachmentLabel,
    String? transferRecordId,
    String? debtSettlementId,
    String? relatedTransactionId,
    DateTime? createdAt,
  }) {
    return LedgerTransaction(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      type: type ?? this.type,
      initiatedByUserId: initiatedByUserId ?? this.initiatedByUserId,
      senderDisplayName: senderDisplayName ?? this.senderDisplayName,
      recipientUserId: recipientUserId ?? this.recipientUserId,
      recipientDisplayName: recipientDisplayName ?? this.recipientDisplayName,
      sourceWalletId: sourceWalletId ?? this.sourceWalletId,
      destinationWalletId: destinationWalletId ?? this.destinationWalletId,
      sourceCurrencyCode: sourceCurrencyCode ?? this.sourceCurrencyCode,
      destinationCurrencyCode:
          destinationCurrencyCode ?? this.destinationCurrencyCode,
      sourceAmountMinor: sourceAmountMinor ?? this.sourceAmountMinor,
      destinationAmountMinor: clearDestinationAmountMinor
          ? null
          : destinationAmountMinor ?? this.destinationAmountMinor,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      note: note ?? this.note,
      attachmentLabel: attachmentLabel ?? this.attachmentLabel,
      transferRecordId: transferRecordId ?? this.transferRecordId,
      debtSettlementId: debtSettlementId ?? this.debtSettlementId,
      relatedTransactionId: relatedTransactionId ?? this.relatedTransactionId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'reference': reference.toJson(),
    'type': type.name,
    'initiatedByUserId': initiatedByUserId,
    'senderDisplayName': senderDisplayName,
    'recipientUserId': recipientUserId,
    'recipientDisplayName': recipientDisplayName,
    'sourceWalletId': sourceWalletId,
    'destinationWalletId': destinationWalletId,
    'sourceCurrencyCode': sourceCurrencyCode,
    'destinationCurrencyCode': destinationCurrencyCode,
    'sourceAmountMinor': sourceAmountMinor,
    'destinationAmountMinor': destinationAmountMinor,
    'exchangeRate': exchangeRate,
    'note': note,
    'attachmentLabel': attachmentLabel,
    'transferRecordId': transferRecordId,
    'debtSettlementId': debtSettlementId,
    'relatedTransactionId': relatedTransactionId,
    'createdAt': createdAt.toIso8601String(),
  };
}
