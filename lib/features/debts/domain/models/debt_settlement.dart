import '../../../../core/utils/amount_formatter.dart';
import '../../../../shared/domain/enums/currency.dart';

class DebtSettlement {
  const DebtSettlement({
    required this.id,
    required this.debtId,
    required this.ownerUserId,
    required this.transferId,
    required this.ledgerTransactionId,
    required this.transferReference,
    required this.currencyCode,
    required this.amountMinor,
    this.note,
    required this.createdAt,
  });

  factory DebtSettlement.fromJson(Map<String, dynamic> json) {
    return DebtSettlement(
      id: json['id'] as String,
      debtId: json['debtId'] as String,
      ownerUserId: json['ownerUserId'] as String,
      transferId: json['transferId'] as String,
      ledgerTransactionId: json['ledgerTransactionId'] as String,
      transferReference: json['transferReference'] as String,
      currencyCode: json['currencyCode'] as String,
      amountMinor: (json['amountMinor'] as num).toInt(),
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  final String id;
  final String debtId;
  final String ownerUserId;
  final String transferId;
  final String ledgerTransactionId;
  final String transferReference;
  final String currencyCode;
  final int amountMinor;
  final String? note;
  final DateTime createdAt;

  Currency get currency => currencyFromCode(currencyCode);

  String get amount => AmountFormatter.majorFromMinor(amountMinor).toString();

  DebtSettlement copyWith({
    String? id,
    String? debtId,
    String? ownerUserId,
    String? transferId,
    String? ledgerTransactionId,
    String? transferReference,
    String? currencyCode,
    int? amountMinor,
    String? note,
    DateTime? createdAt,
  }) {
    return DebtSettlement(
      id: id ?? this.id,
      debtId: debtId ?? this.debtId,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      transferId: transferId ?? this.transferId,
      ledgerTransactionId: ledgerTransactionId ?? this.ledgerTransactionId,
      transferReference: transferReference ?? this.transferReference,
      currencyCode: currencyCode ?? this.currencyCode,
      amountMinor: amountMinor ?? this.amountMinor,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'debtId': debtId,
    'ownerUserId': ownerUserId,
    'transferId': transferId,
    'ledgerTransactionId': ledgerTransactionId,
    'transferReference': transferReference,
    'currencyCode': currencyCode,
    'amountMinor': amountMinor,
    'note': note,
    'createdAt': createdAt.toIso8601String(),
  };
}
