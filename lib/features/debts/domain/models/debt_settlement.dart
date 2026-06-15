import '../../../../core/utils/amount_formatter.dart';
import '../../../../shared/domain/enums/currency.dart';

class DebtSettlement {
  const DebtSettlement({
    required this.id,
    required this.debtId,
    required this.linkedTransferId,
    required this.currencyCode,
    required this.amountMinor,
    this.note,
    required this.createdAt,
  });

  factory DebtSettlement.fromJson(Map<String, dynamic> json) {
    return DebtSettlement(
      id: json['id'] as String,
      debtId: json['debtId'] as String,
      linkedTransferId:
          (json['linkedTransferId'] ?? json['transferId']) as String,
      currencyCode: json['currencyCode'] as String,
      amountMinor: (json['amountMinor'] as num).toInt(),
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  final String id;
  final String debtId;
  final String linkedTransferId;
  final String currencyCode;
  final int amountMinor;
  final String? note;
  final DateTime createdAt;

  Currency get currency => currencyFromCode(currencyCode);
  String get transferId => linkedTransferId;

  String get amount => AmountFormatter.majorFromMinor(amountMinor).toString();

  DebtSettlement copyWith({
    String? id,
    String? debtId,
    String? linkedTransferId,
    String? currencyCode,
    int? amountMinor,
    String? note,
    DateTime? createdAt,
  }) {
    return DebtSettlement(
      id: id ?? this.id,
      debtId: debtId ?? this.debtId,
      linkedTransferId: linkedTransferId ?? this.linkedTransferId,
      currencyCode: currencyCode ?? this.currencyCode,
      amountMinor: amountMinor ?? this.amountMinor,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'debtId': debtId,
    'linkedTransferId': linkedTransferId,
    'currencyCode': currencyCode,
    'amountMinor': amountMinor,
    'note': note,
    'createdAt': createdAt.toIso8601String(),
  };
}
