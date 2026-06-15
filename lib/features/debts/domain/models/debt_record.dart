import '../../../../core/utils/amount_formatter.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../../shared/domain/enums/debt_status.dart';

class DebtRecord {
  const DebtRecord({
    required this.id,
    required this.lenderPartyId,
    required this.borrowerPartyId,
    required this.currencyCode,
    required this.principalAmountMinor,
    required this.repaidAmountMinor,
    required this.status,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DebtRecord.fromJson(Map<String, dynamic> json) {
    final String? rawStatus = json['status'] as String?;
    return DebtRecord(
      id: json['id'] as String,
      lenderPartyId: json['lenderPartyId'] as String,
      borrowerPartyId: json['borrowerPartyId'] as String,
      currencyCode: json['currencyCode'] as String,
      principalAmountMinor: (json['principalAmountMinor'] as num).toInt(),
      repaidAmountMinor: (json['repaidAmountMinor'] as num).toInt(),
      status: switch (rawStatus) {
        'active' => DebtStatus.active,
        'completed' => DebtStatus.completed,
        'cancelled' => DebtStatus.cancelled,
        'open' => DebtStatus.active,
        'settled' => DebtStatus.completed,
        'disputed' => DebtStatus.cancelled,
        _ => DebtStatus.active,
      },
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  final String id;
  final String lenderPartyId;
  final String borrowerPartyId;
  final String currencyCode;
  final int principalAmountMinor;
  final int repaidAmountMinor;
  final DebtStatus status;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  Currency get currency => currencyFromCode(currencyCode);

  String get principalAmount =>
      AmountFormatter.majorFromMinor(principalAmountMinor).toString();

  String get repaidAmount =>
      AmountFormatter.majorFromMinor(repaidAmountMinor).toString();

  DebtRecord copyWith({
    String? id,
    String? lenderPartyId,
    String? borrowerPartyId,
    String? currencyCode,
    int? principalAmountMinor,
    int? repaidAmountMinor,
    DebtStatus? status,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DebtRecord(
      id: id ?? this.id,
      lenderPartyId: lenderPartyId ?? this.lenderPartyId,
      borrowerPartyId: borrowerPartyId ?? this.borrowerPartyId,
      currencyCode: currencyCode ?? this.currencyCode,
      principalAmountMinor: principalAmountMinor ?? this.principalAmountMinor,
      repaidAmountMinor: repaidAmountMinor ?? this.repaidAmountMinor,
      status: status ?? this.status,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'lenderPartyId': lenderPartyId,
    'borrowerPartyId': borrowerPartyId,
    'currencyCode': currencyCode,
    'principalAmountMinor': principalAmountMinor,
    'repaidAmountMinor': repaidAmountMinor,
    'status': status.name,
    'note': note,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
