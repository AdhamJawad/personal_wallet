import '../../../../core/utils/amount_formatter.dart';
import '../../../../shared/domain/enums/currency.dart';

class DebtRepayment {
  const DebtRepayment({
    required this.id,
    required this.debtId,
    required this.amountMinor,
    required this.currencyCode,
    this.note,
    required this.createdAt,
  });

  factory DebtRepayment.fromJson(Map<String, dynamic> json) {
    return DebtRepayment(
      id: json['id'] as String,
      debtId: json['debtId'] as String,
      amountMinor: (json['amountMinor'] as num).toInt(),
      currencyCode: json['currencyCode'] as String,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  final String id;
  final String debtId;
  final int amountMinor;
  final String currencyCode;
  final String? note;
  final DateTime createdAt;

  Currency get currency => currencyFromCode(currencyCode);

  String get amount => AmountFormatter.majorFromMinor(amountMinor).toString();

  DebtRepayment copyWith({
    String? id,
    String? debtId,
    int? amountMinor,
    String? currencyCode,
    String? note,
    DateTime? createdAt,
  }) {
    return DebtRepayment(
      id: id ?? this.id,
      debtId: debtId ?? this.debtId,
      amountMinor: amountMinor ?? this.amountMinor,
      currencyCode: currencyCode ?? this.currencyCode,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'debtId': debtId,
    'amountMinor': amountMinor,
    'currencyCode': currencyCode,
    'note': note,
    'createdAt': createdAt.toIso8601String(),
  };
}
