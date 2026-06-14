import '../../../../core/utils/amount_formatter.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../../shared/domain/enums/transaction_type.dart';

class TransactionRecord {
  const TransactionRecord({
    required this.id,
    required this.type,
    required this.initiatedByUserId,
    this.sourceWalletId,
    this.destinationWalletId,
    required this.sourceAmountMinor,
    required this.sourceCurrencyCode,
    this.destinationAmountMinor,
    this.destinationCurrencyCode,
    this.relatedTransactionId,
    this.note,
    required this.createdAt,
  });

  factory TransactionRecord.fromJson(Map<String, dynamic> json) {
    return TransactionRecord(
      id: json['id'] as String,
      type: TransactionType.values.byName(json['type'] as String),
      initiatedByUserId: json['initiatedByUserId'] as String,
      sourceWalletId: json['sourceWalletId'] as String?,
      destinationWalletId: json['destinationWalletId'] as String?,
      sourceAmountMinor: (json['sourceAmountMinor'] as num).toInt(),
      sourceCurrencyCode: json['sourceCurrencyCode'] as String,
      destinationAmountMinor: (json['destinationAmountMinor'] as num?)?.toInt(),
      destinationCurrencyCode: json['destinationCurrencyCode'] as String?,
      relatedTransactionId: json['relatedTransactionId'] as String?,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  final String id;
  final TransactionType type;
  final String initiatedByUserId;
  final String? sourceWalletId;
  final String? destinationWalletId;
  final int sourceAmountMinor;
  final String sourceCurrencyCode;
  final int? destinationAmountMinor;
  final String? destinationCurrencyCode;
  final String? relatedTransactionId;
  final String? note;
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

  TransactionRecord copyWith({
    String? id,
    TransactionType? type,
    String? initiatedByUserId,
    String? sourceWalletId,
    String? destinationWalletId,
    int? sourceAmountMinor,
    String? sourceCurrencyCode,
    int? destinationAmountMinor,
    bool clearDestinationAmountMinor = false,
    String? destinationCurrencyCode,
    String? relatedTransactionId,
    String? note,
    DateTime? createdAt,
  }) {
    return TransactionRecord(
      id: id ?? this.id,
      type: type ?? this.type,
      initiatedByUserId: initiatedByUserId ?? this.initiatedByUserId,
      sourceWalletId: sourceWalletId ?? this.sourceWalletId,
      destinationWalletId: destinationWalletId ?? this.destinationWalletId,
      sourceAmountMinor: sourceAmountMinor ?? this.sourceAmountMinor,
      sourceCurrencyCode: sourceCurrencyCode ?? this.sourceCurrencyCode,
      destinationAmountMinor: clearDestinationAmountMinor
          ? null
          : destinationAmountMinor ?? this.destinationAmountMinor,
      destinationCurrencyCode:
          destinationCurrencyCode ?? this.destinationCurrencyCode,
      relatedTransactionId: relatedTransactionId ?? this.relatedTransactionId,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'type': type.name,
    'initiatedByUserId': initiatedByUserId,
    'sourceWalletId': sourceWalletId,
    'destinationWalletId': destinationWalletId,
    'sourceAmountMinor': sourceAmountMinor,
    'sourceCurrencyCode': sourceCurrencyCode,
    'destinationAmountMinor': destinationAmountMinor,
    'destinationCurrencyCode': destinationCurrencyCode,
    'relatedTransactionId': relatedTransactionId,
    'note': note,
    'createdAt': createdAt.toIso8601String(),
  };
}
