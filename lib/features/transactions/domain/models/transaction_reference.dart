import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_reference.freezed.dart';
part 'transaction_reference.g.dart';

@freezed
abstract class TransactionReference with _$TransactionReference {
  const factory TransactionReference({
    required String value,
    required int year,
    required int sequence,
  }) = _TransactionReference;

  factory TransactionReference.fromJson(Map<String, dynamic> json) =>
      _$TransactionReferenceFromJson(json);
}
