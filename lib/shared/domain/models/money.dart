import '../../../core/utils/amount_formatter.dart';
import '../enums/currency.dart';

class Money {
  const Money({required this.amountMinor, required this.currencyCode});

  factory Money.fromJson(Map<String, dynamic> json) {
    return Money(
      amountMinor: (json['amountMinor'] as num).toInt(),
      currencyCode: json['currencyCode'] as String,
    );
  }

  final int amountMinor;
  final String currencyCode;

  Currency get currency => currencyFromCode(currencyCode);

  String get amount => AmountFormatter.majorFromMinor(amountMinor).toString();

  Money copyWith({int? amountMinor, String? currencyCode}) {
    return Money(
      amountMinor: amountMinor ?? this.amountMinor,
      currencyCode: currencyCode ?? this.currencyCode,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'amountMinor': amountMinor,
    'currencyCode': currencyCode,
  };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Money &&
            other.amountMinor == amountMinor &&
            other.currencyCode == currencyCode;
  }

  @override
  int get hashCode => Object.hash(amountMinor, currencyCode);
}
