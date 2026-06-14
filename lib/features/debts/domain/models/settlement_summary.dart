import '../../../../core/utils/amount_formatter.dart';
import 'debt_settlement.dart';

class SettlementSummary {
  const SettlementSummary({
    required this.settlement,
    required this.transferReference,
    required this.counterpartyDisplayName,
    required this.remainingAmountAfterSettlementMinor,
    required this.isCompleted,
  });

  factory SettlementSummary.fromJson(Map<String, dynamic> json) {
    return SettlementSummary(
      settlement: DebtSettlement.fromJson(
        json['settlement'] as Map<String, dynamic>,
      ),
      transferReference: json['transferReference'] as String,
      counterpartyDisplayName: json['counterpartyDisplayName'] as String,
      remainingAmountAfterSettlementMinor:
          (json['remainingAmountAfterSettlementMinor'] as num).toInt(),
      isCompleted: json['isCompleted'] as bool,
    );
  }

  final DebtSettlement settlement;
  final String transferReference;
  final String counterpartyDisplayName;
  final int remainingAmountAfterSettlementMinor;
  final bool isCompleted;

  String get remainingAmountAfterSettlement => AmountFormatter.majorFromMinor(
    remainingAmountAfterSettlementMinor,
  ).toString();

  SettlementSummary copyWith({
    DebtSettlement? settlement,
    String? transferReference,
    String? counterpartyDisplayName,
    int? remainingAmountAfterSettlementMinor,
    bool? isCompleted,
  }) {
    return SettlementSummary(
      settlement: settlement ?? this.settlement,
      transferReference: transferReference ?? this.transferReference,
      counterpartyDisplayName:
          counterpartyDisplayName ?? this.counterpartyDisplayName,
      remainingAmountAfterSettlementMinor:
          remainingAmountAfterSettlementMinor ??
          this.remainingAmountAfterSettlementMinor,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'settlement': settlement.toJson(),
    'transferReference': transferReference,
    'counterpartyDisplayName': counterpartyDisplayName,
    'remainingAmountAfterSettlementMinor': remainingAmountAfterSettlementMinor,
    'isCompleted': isCompleted,
  };
}
