// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DebtSummary {

 Debt get debt; Contact get contact; List<DebtRepayment> get repayments; List<SettlementSummary> get settlements; String get repaidAmount; String get remainingAmount; bool get isCompleted; Currency get currency;
/// Create a copy of DebtSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtSummaryCopyWith<DebtSummary> get copyWith => _$DebtSummaryCopyWithImpl<DebtSummary>(this as DebtSummary, _$identity);

  /// Serializes this DebtSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtSummary&&(identical(other.debt, debt) || other.debt == debt)&&(identical(other.contact, contact) || other.contact == contact)&&const DeepCollectionEquality().equals(other.repayments, repayments)&&const DeepCollectionEquality().equals(other.settlements, settlements)&&(identical(other.repaidAmount, repaidAmount) || other.repaidAmount == repaidAmount)&&(identical(other.remainingAmount, remainingAmount) || other.remainingAmount == remainingAmount)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,debt,contact,const DeepCollectionEquality().hash(repayments),const DeepCollectionEquality().hash(settlements),repaidAmount,remainingAmount,isCompleted,currency);

@override
String toString() {
  return 'DebtSummary(debt: $debt, contact: $contact, repayments: $repayments, settlements: $settlements, repaidAmount: $repaidAmount, remainingAmount: $remainingAmount, isCompleted: $isCompleted, currency: $currency)';
}


}

/// @nodoc
abstract mixin class $DebtSummaryCopyWith<$Res>  {
  factory $DebtSummaryCopyWith(DebtSummary value, $Res Function(DebtSummary) _then) = _$DebtSummaryCopyWithImpl;
@useResult
$Res call({
 Debt debt, Contact contact, List<DebtRepayment> repayments, List<SettlementSummary> settlements, String repaidAmount, String remainingAmount, bool isCompleted, Currency currency
});


$DebtCopyWith<$Res> get debt;$ContactCopyWith<$Res> get contact;

}
/// @nodoc
class _$DebtSummaryCopyWithImpl<$Res>
    implements $DebtSummaryCopyWith<$Res> {
  _$DebtSummaryCopyWithImpl(this._self, this._then);

  final DebtSummary _self;
  final $Res Function(DebtSummary) _then;

/// Create a copy of DebtSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? debt = null,Object? contact = null,Object? repayments = null,Object? settlements = null,Object? repaidAmount = null,Object? remainingAmount = null,Object? isCompleted = null,Object? currency = null,}) {
  return _then(_self.copyWith(
debt: null == debt ? _self.debt : debt // ignore: cast_nullable_to_non_nullable
as Debt,contact: null == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as Contact,repayments: null == repayments ? _self.repayments : repayments // ignore: cast_nullable_to_non_nullable
as List<DebtRepayment>,settlements: null == settlements ? _self.settlements : settlements // ignore: cast_nullable_to_non_nullable
as List<SettlementSummary>,repaidAmount: null == repaidAmount ? _self.repaidAmount : repaidAmount // ignore: cast_nullable_to_non_nullable
as String,remainingAmount: null == remainingAmount ? _self.remainingAmount : remainingAmount // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,
  ));
}
/// Create a copy of DebtSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DebtCopyWith<$Res> get debt {
  
  return $DebtCopyWith<$Res>(_self.debt, (value) {
    return _then(_self.copyWith(debt: value));
  });
}/// Create a copy of DebtSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactCopyWith<$Res> get contact {
  
  return $ContactCopyWith<$Res>(_self.contact, (value) {
    return _then(_self.copyWith(contact: value));
  });
}
}


/// Adds pattern-matching-related methods to [DebtSummary].
extension DebtSummaryPatterns on DebtSummary {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DebtSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DebtSummary() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DebtSummary value)  $default,){
final _that = this;
switch (_that) {
case _DebtSummary():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DebtSummary value)?  $default,){
final _that = this;
switch (_that) {
case _DebtSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Debt debt,  Contact contact,  List<DebtRepayment> repayments,  List<SettlementSummary> settlements,  String repaidAmount,  String remainingAmount,  bool isCompleted,  Currency currency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DebtSummary() when $default != null:
return $default(_that.debt,_that.contact,_that.repayments,_that.settlements,_that.repaidAmount,_that.remainingAmount,_that.isCompleted,_that.currency);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Debt debt,  Contact contact,  List<DebtRepayment> repayments,  List<SettlementSummary> settlements,  String repaidAmount,  String remainingAmount,  bool isCompleted,  Currency currency)  $default,) {final _that = this;
switch (_that) {
case _DebtSummary():
return $default(_that.debt,_that.contact,_that.repayments,_that.settlements,_that.repaidAmount,_that.remainingAmount,_that.isCompleted,_that.currency);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Debt debt,  Contact contact,  List<DebtRepayment> repayments,  List<SettlementSummary> settlements,  String repaidAmount,  String remainingAmount,  bool isCompleted,  Currency currency)?  $default,) {final _that = this;
switch (_that) {
case _DebtSummary() when $default != null:
return $default(_that.debt,_that.contact,_that.repayments,_that.settlements,_that.repaidAmount,_that.remainingAmount,_that.isCompleted,_that.currency);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DebtSummary extends DebtSummary {
  const _DebtSummary({required this.debt, required this.contact, required final  List<DebtRepayment> repayments, final  List<SettlementSummary> settlements = const <SettlementSummary>[], required this.repaidAmount, required this.remainingAmount, required this.isCompleted, required this.currency}): _repayments = repayments,_settlements = settlements,super._();
  factory _DebtSummary.fromJson(Map<String, dynamic> json) => _$DebtSummaryFromJson(json);

@override final  Debt debt;
@override final  Contact contact;
 final  List<DebtRepayment> _repayments;
@override List<DebtRepayment> get repayments {
  if (_repayments is EqualUnmodifiableListView) return _repayments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_repayments);
}

 final  List<SettlementSummary> _settlements;
@override@JsonKey() List<SettlementSummary> get settlements {
  if (_settlements is EqualUnmodifiableListView) return _settlements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_settlements);
}

@override final  String repaidAmount;
@override final  String remainingAmount;
@override final  bool isCompleted;
@override final  Currency currency;

/// Create a copy of DebtSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtSummaryCopyWith<_DebtSummary> get copyWith => __$DebtSummaryCopyWithImpl<_DebtSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DebtSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DebtSummary&&(identical(other.debt, debt) || other.debt == debt)&&(identical(other.contact, contact) || other.contact == contact)&&const DeepCollectionEquality().equals(other._repayments, _repayments)&&const DeepCollectionEquality().equals(other._settlements, _settlements)&&(identical(other.repaidAmount, repaidAmount) || other.repaidAmount == repaidAmount)&&(identical(other.remainingAmount, remainingAmount) || other.remainingAmount == remainingAmount)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,debt,contact,const DeepCollectionEquality().hash(_repayments),const DeepCollectionEquality().hash(_settlements),repaidAmount,remainingAmount,isCompleted,currency);

@override
String toString() {
  return 'DebtSummary(debt: $debt, contact: $contact, repayments: $repayments, settlements: $settlements, repaidAmount: $repaidAmount, remainingAmount: $remainingAmount, isCompleted: $isCompleted, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$DebtSummaryCopyWith<$Res> implements $DebtSummaryCopyWith<$Res> {
  factory _$DebtSummaryCopyWith(_DebtSummary value, $Res Function(_DebtSummary) _then) = __$DebtSummaryCopyWithImpl;
@override @useResult
$Res call({
 Debt debt, Contact contact, List<DebtRepayment> repayments, List<SettlementSummary> settlements, String repaidAmount, String remainingAmount, bool isCompleted, Currency currency
});


@override $DebtCopyWith<$Res> get debt;@override $ContactCopyWith<$Res> get contact;

}
/// @nodoc
class __$DebtSummaryCopyWithImpl<$Res>
    implements _$DebtSummaryCopyWith<$Res> {
  __$DebtSummaryCopyWithImpl(this._self, this._then);

  final _DebtSummary _self;
  final $Res Function(_DebtSummary) _then;

/// Create a copy of DebtSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? debt = null,Object? contact = null,Object? repayments = null,Object? settlements = null,Object? repaidAmount = null,Object? remainingAmount = null,Object? isCompleted = null,Object? currency = null,}) {
  return _then(_DebtSummary(
debt: null == debt ? _self.debt : debt // ignore: cast_nullable_to_non_nullable
as Debt,contact: null == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as Contact,repayments: null == repayments ? _self._repayments : repayments // ignore: cast_nullable_to_non_nullable
as List<DebtRepayment>,settlements: null == settlements ? _self._settlements : settlements // ignore: cast_nullable_to_non_nullable
as List<SettlementSummary>,repaidAmount: null == repaidAmount ? _self.repaidAmount : repaidAmount // ignore: cast_nullable_to_non_nullable
as String,remainingAmount: null == remainingAmount ? _self.remainingAmount : remainingAmount // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,
  ));
}

/// Create a copy of DebtSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DebtCopyWith<$Res> get debt {
  
  return $DebtCopyWith<$Res>(_self.debt, (value) {
    return _then(_self.copyWith(debt: value));
  });
}/// Create a copy of DebtSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactCopyWith<$Res> get contact {
  
  return $ContactCopyWith<$Res>(_self.contact, (value) {
    return _then(_self.copyWith(contact: value));
  });
}
}

// dart format on
