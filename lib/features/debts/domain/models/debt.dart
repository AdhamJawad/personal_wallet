import '../../../../core/utils/amount_formatter.dart';
import '../../../../shared/domain/enums/currency.dart';

class Debt {
  const Debt({
    required this.id,
    required this.ownerUserId,
    required this.counterpartyContactId,
    required this.isOwedToMe,
    required this.currencyCode,
    required this.originalAmountMinor,
    this.note,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
  });

  factory Debt.fromJson(Map<String, dynamic> json) {
    return Debt(
      id: json['id'] as String,
      ownerUserId: json['ownerUserId'] as String,
      counterpartyContactId: json['counterpartyContactId'] as String,
      isOwedToMe: json['isOwedToMe'] as bool,
      currencyCode: json['currencyCode'] as String,
      originalAmountMinor: (json['originalAmountMinor'] as num).toInt(),
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );
  }

  final String id;
  final String ownerUserId;
  final String counterpartyContactId;
  final bool isOwedToMe;
  final String currencyCode;
  final int originalAmountMinor;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;

  Currency get currency => currencyFromCode(currencyCode);

  String get originalAmount =>
      AmountFormatter.majorFromMinor(originalAmountMinor).toString();

  Debt copyWith({
    String? id,
    String? ownerUserId,
    String? counterpartyContactId,
    bool? isOwedToMe,
    String? currencyCode,
    int? originalAmountMinor,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    bool clearCompletedAt = false,
  }) {
    return Debt(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      counterpartyContactId:
          counterpartyContactId ?? this.counterpartyContactId,
      isOwedToMe: isOwedToMe ?? this.isOwedToMe,
      currencyCode: currencyCode ?? this.currencyCode,
      originalAmountMinor: originalAmountMinor ?? this.originalAmountMinor,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: clearCompletedAt ? null : completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'ownerUserId': ownerUserId,
    'counterpartyContactId': counterpartyContactId,
    'isOwedToMe': isOwedToMe,
    'currencyCode': currencyCode,
    'originalAmountMinor': originalAmountMinor,
    'note': note,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
  };
}
