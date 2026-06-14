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
    required this.repaidAmountMinor,
    required this.remainingAmountMinor,
    required this.isCompleted,
    required this.currencyCode,
  });

  factory DebtSummary.fromJson(Map<String, dynamic> json) {
    return DebtSummary(
      debt: Debt.fromJson(json['debt'] as Map<String, dynamic>),
      contact: Contact.fromJson(json['contact'] as Map<String, dynamic>),
      repayments: (json['repayments'] as List<dynamic>)
          .map(
            (dynamic item) =>
                DebtRepayment.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
      settlements: (json['settlements'] as List<dynamic>? ?? const [])
          .map(
            (dynamic item) =>
                SettlementSummary.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
      repaidAmountMinor: (json['repaidAmountMinor'] as num).toInt(),
      remainingAmountMinor: (json['remainingAmountMinor'] as num).toInt(),
      isCompleted: json['isCompleted'] as bool,
      currencyCode: json['currencyCode'] as String,
    );
  }

  final Debt debt;
  final Contact contact;
  final List<DebtRepayment> repayments;
  final List<SettlementSummary> settlements;
  final int repaidAmountMinor;
  final int remainingAmountMinor;
  final bool isCompleted;
  final String currencyCode;

  Currency get currency => currencyFromCode(currencyCode);

  String get repaidAmount =>
      AmountFormatter.majorFromMinor(repaidAmountMinor).toString();

  String get remainingAmount =>
      AmountFormatter.majorFromMinor(remainingAmountMinor).toString();

  DebtSummary copyWith({
    Debt? debt,
    Contact? contact,
    List<DebtRepayment>? repayments,
    List<SettlementSummary>? settlements,
    int? repaidAmountMinor,
    int? remainingAmountMinor,
    bool? isCompleted,
    String? currencyCode,
  }) {
    return DebtSummary(
      debt: debt ?? this.debt,
      contact: contact ?? this.contact,
      repayments: repayments ?? this.repayments,
      settlements: settlements ?? this.settlements,
      repaidAmountMinor: repaidAmountMinor ?? this.repaidAmountMinor,
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
    'repaidAmountMinor': repaidAmountMinor,
    'remainingAmountMinor': remainingAmountMinor,
    'isCompleted': isCompleted,
    'currencyCode': currencyCode,
  };
}
