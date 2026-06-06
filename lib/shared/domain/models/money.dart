import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/currency.dart';

part 'money.freezed.dart';
part 'money.g.dart';

@freezed
abstract class Money with _$Money {
  const factory Money({required Currency currency, required String amount}) =
      _Money;

  factory Money.fromJson(Map<String, dynamic> json) => _$MoneyFromJson(json);
}
