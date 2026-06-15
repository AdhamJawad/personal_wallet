import '../../../../core/utils/amount_formatter.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../contacts/domain/models/contact.dart';
import 'debt.dart';
import 'debt_repayment.dart';
import 'settlement_summary.dart';

class DebtSummary {
  const DebtSummary({
    required this.debt,
    required this.contact,
    required this.repayments,
    this.settlements = const <SettlementSummary>[],
    required this.repaymentAmountMinor,
    required this.settledAmountMinor,
    required this.resolvedAmountMinor,
    required this.remainingAmountMinor,
    required this.isCompleted,
    required this.currencyCode,
  });

  factory DebtSummary.fromJson(Map<String, dynamic> json) {
    final List<SettlementSummary> settlements =
        (json['settlements'] as List<dynamic>? ?? const [])
            .map(
              (dynamic item) =>
                  SettlementSummary.fromJson(item as Map<String, dynamic>),
            )
            .toList(growable: false);
    final int repaymentAmountMinor =
        (json['repaymentAmountMinor'] as num?)?.toInt() ??
        (json['repaidAmountMinor'] as num?)?.toInt() ??
        0;
    final int settledAmountMinor =
        (json['settledAmountMinor'] as num?)?.toInt() ??
        settlements.fold<int>(
          0,
          (int total, SettlementSummary item) =>
              total + item.settlement.amountMinor,
        );

    return DebtSummary(
      debt: Debt.fromJson(json['debt'] as Map<String, dynamic>),
      contact: Contact.fromJson(json['contact'] as Map<String, dynamic>),
      repayments: (json['repayments'] as List<dynamic>)
          .map(
            (dynamic item) =>
                DebtRepayment.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
      settlements: settlements,
      repaymentAmountMinor: repaymentAmountMinor,
      settledAmountMinor: settledAmountMinor,
      resolvedAmountMinor:
          (json['resolvedAmountMinor'] as num?)?.toInt() ??
          (json['repaidAmountMinor'] as num?)?.toInt() ??
          (repaymentAmountMinor + settledAmountMinor),
      remainingAmountMinor: (json['remainingAmountMinor'] as num).toInt(),
      isCompleted: json['isCompleted'] as bool,
      currencyCode: json['currencyCode'] as String,
    );
  }

  final Debt debt;
  final Contact contact;
  final List<DebtRepayment> repayments;
  final List<SettlementSummary> settlements;
  final int repaymentAmountMinor;
  final int settledAmountMinor;
  final int resolvedAmountMinor;
  final int remainingAmountMinor;
  final bool isCompleted;
  final String currencyCode;

  int get repaidAmountMinor => resolvedAmountMinor;

  Currency get currency => currencyFromCode(currencyCode);

  String get repaidAmount =>
      AmountFormatter.majorFromMinor(resolvedAmountMinor).toString();

  String get remainingAmount =>
      AmountFormatter.majorFromMinor(remainingAmountMinor).toString();

  DebtSummary copyWith({
    Debt? debt,
    Contact? contact,
    List<DebtRepayment>? repayments,
    List<SettlementSummary>? settlements,
    int? repaymentAmountMinor,
    int? settledAmountMinor,
    int? resolvedAmountMinor,
    int? remainingAmountMinor,
    bool? isCompleted,
    String? currencyCode,
  }) {
    return DebtSummary(
      debt: debt ?? this.debt,
      contact: contact ?? this.contact,
      repayments: repayments ?? this.repayments,
      settlements: settlements ?? this.settlements,
      repaymentAmountMinor: repaymentAmountMinor ?? this.repaymentAmountMinor,
      settledAmountMinor: settledAmountMinor ?? this.settledAmountMinor,
      resolvedAmountMinor: resolvedAmountMinor ?? this.resolvedAmountMinor,
      remainingAmountMinor: remainingAmountMinor ?? this.remainingAmountMinor,
      isCompleted: isCompleted ?? this.isCompleted,
      currencyCode: currencyCode ?? this.currencyCode,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'debt': debt.toJson(),
    'contact': contact.toJson(),
    'repayments': repayments
        .map((DebtRepayment item) => item.toJson())
        .toList(),
    'settlements': settlements
        .map((SettlementSummary item) => item.toJson())
        .toList(),
    'repaymentAmountMinor': repaymentAmountMinor,
    'settledAmountMinor': settledAmountMinor,
    'resolvedAmountMinor': resolvedAmountMinor,
    'remainingAmountMinor': remainingAmountMinor,
    'isCompleted': isCompleted,
    'currencyCode': currencyCode,
  };
}
