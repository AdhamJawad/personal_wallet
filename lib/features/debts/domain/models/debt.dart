import '../../../../core/utils/amount_formatter.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../../shared/domain/enums/debt_status.dart';

class Debt {
  const Debt({
    required this.id,
    required this.ownerUserId,
    required this.counterpartyContactId,
    required this.isOwedToMe,
    required this.currencyCode,
    required this.originalAmountMinor,
    this.status = DebtStatus.active,
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
      status: _statusFromJson(
        json['status'] as String?,
        completedAtRaw: json['completedAt'] as String?,
      ),
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
  final DebtStatus status;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;

  Currency get currency => currencyFromCode(currencyCode);
  bool get isCompleted => status == DebtStatus.completed;

  String get originalAmount =>
      AmountFormatter.majorFromMinor(originalAmountMinor).toString();

  Debt copyWith({
    String? id,
    String? ownerUserId,
    String? counterpartyContactId,
    bool? isOwedToMe,
    String? currencyCode,
    int? originalAmountMinor,
    DebtStatus? status,
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
      status: status ?? this.status,
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
    'status': status.name,
    'note': note,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
  };

  static DebtStatus _statusFromJson(
    String? rawStatus, {
    required String? completedAtRaw,
  }) {
    return switch (rawStatus) {
      'active' => DebtStatus.active,
      'completed' => DebtStatus.completed,
      'cancelled' => DebtStatus.cancelled,
      'open' => DebtStatus.active,
      'settled' => DebtStatus.completed,
      'disputed' => DebtStatus.cancelled,
      _ => completedAtRaw == null ? DebtStatus.active : DebtStatus.completed,
    };
  }
}
