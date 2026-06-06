// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settlement_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SettlementSummary {

 DebtSettlement get settlement; String get transferReference; String get counterpartyDisplayName; String get remainingAmountAfterSettlement; bool get isCompleted;
/// Create a copy of SettlementSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettlementSummaryCopyWith<SettlementSummary> get copyWith => _$SettlementSummaryCopyWithImpl<SettlementSummary>(this as SettlementSummary, _$identity);

  /// Serializes this SettlementSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettlementSummary&&(identical(other.settlement, settlement) || other.settlement == settlement)&&(identical(other.transferReference, transferReference) || other.transferReference == transferReference)&&(identical(other.counterpartyDisplayName, counterpartyDisplayName) || other.counterpartyDisplayName == counterpartyDisplayName)&&(identical(other.remainingAmountAfterSettlement, remainingAmountAfterSettlement) || other.remainingAmountAfterSettlement == remainingAmountAfterSettlement)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,settlement,transferReference,counterpartyDisplayName,remainingAmountAfterSettlement,isCompleted);

@override
String toString() {
  return 'SettlementSummary(settlement: $settlement, transferReference: $transferReference, counterpartyDisplayName: $counterpartyDisplayName, remainingAmountAfterSettlement: $remainingAmountAfterSettlement, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class $SettlementSummaryCopyWith<$Res>  {
  factory $SettlementSummaryCopyWith(SettlementSummary value, $Res Function(SettlementSummary) _then) = _$SettlementSummaryCopyWithImpl;
@useResult
$Res call({
 DebtSettlement settlement, String transferReference, String counterpartyDisplayName, String remainingAmountAfterSettlement, bool isCompleted
});


$DebtSettlementCopyWith<$Res> get settlement;

}
/// @nodoc
class _$SettlementSummaryCopyWithImpl<$Res>
    implements $SettlementSummaryCopyWith<$Res> {
  _$SettlementSummaryCopyWithImpl(this._self, this._then);

  final SettlementSummary _self;
  final $Res Function(SettlementSummary) _then;

/// Create a copy of SettlementSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? settlement = null,Object? transferReference = null,Object? counterpartyDisplayName = null,Object? remainingAmountAfterSettlement = null,Object? isCompleted = null,}) {
  return _then(_self.copyWith(
settlement: null == settlement ? _self.settlement : settlement // ignore: cast_nullable_to_non_nullable
as DebtSettlement,transferReference: null == transferReference ? _self.transferReference : transferReference // ignore: cast_nullable_to_non_nullable
as String,counterpartyDisplayName: null == counterpartyDisplayName ? _self.counterpartyDisplayName : counterpartyDisplayName // ignore: cast_nullable_to_non_nullable
as String,remainingAmountAfterSettlement: null == remainingAmountAfterSettlement ? _self.remainingAmountAfterSettlement : remainingAmountAfterSettlement // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SettlementSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DebtSettlementCopyWith<$Res> get settlement {
  
  return $DebtSettlementCopyWith<$Res>(_self.settlement, (value) {
    return _then(_self.copyWith(settlement: value));
  });
}
}


/// Adds pattern-matching-related methods to [SettlementSummary].
extension SettlementSummaryPatterns on SettlementSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettlementSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettlementSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettlementSummary value)  $default,){
final _that = this;
switch (_that) {
case _SettlementSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettlementSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SettlementSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DebtSettlement settlement,  String transferReference,  String counterpartyDisplayName,  String remainingAmountAfterSettlement,  bool isCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettlementSummary() when $default != null:
return $default(_that.settlement,_that.transferReference,_that.counterpartyDisplayName,_that.remainingAmountAfterSettlement,_that.isCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DebtSettlement settlement,  String transferReference,  String counterpartyDisplayName,  String remainingAmountAfterSettlement,  bool isCompleted)  $default,) {final _that = this;
switch (_that) {
case _SettlementSummary():
return $default(_that.settlement,_that.transferReference,_that.counterpartyDisplayName,_that.remainingAmountAfterSettlement,_that.isCompleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DebtSettlement settlement,  String transferReference,  String counterpartyDisplayName,  String remainingAmountAfterSettlement,  bool isCompleted)?  $default,) {final _that = this;
switch (_that) {
case _SettlementSummary() when $default != null:
return $default(_that.settlement,_that.transferReference,_that.counterpartyDisplayName,_that.remainingAmountAfterSettlement,_that.isCompleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SettlementSummary implements SettlementSummary {
  const _SettlementSummary({required this.settlement, required this.transferReference, required this.counterpartyDisplayName, required this.remainingAmountAfterSettlement, required this.isCompleted});
  factory _SettlementSummary.fromJson(Map<String, dynamic> json) => _$SettlementSummaryFromJson(json);

@override final  DebtSettlement settlement;
@override final  String transferReference;
@override final  String counterpartyDisplayName;
@override final  String remainingAmountAfterSettlement;
@override final  bool isCompleted;

/// Create a copy of SettlementSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettlementSummaryCopyWith<_SettlementSummary> get copyWith => __$SettlementSummaryCopyWithImpl<_SettlementSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettlementSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettlementSummary&&(identical(other.settlement, settlement) || other.settlement == settlement)&&(identical(other.transferReference, transferReference) || other.transferReference == transferReference)&&(identical(other.counterpartyDisplayName, counterpartyDisplayName) || other.counterpartyDisplayName == counterpartyDisplayName)&&(identical(other.remainingAmountAfterSettlement, remainingAmountAfterSettlement) || other.remainingAmountAfterSettlement == remainingAmountAfterSettlement)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,settlement,transferReference,counterpartyDisplayName,remainingAmountAfterSettlement,isCompleted);

@override
String toString() {
  return 'SettlementSummary(settlement: $settlement, transferReference: $transferReference, counterpartyDisplayName: $counterpartyDisplayName, remainingAmountAfterSettlement: $remainingAmountAfterSettlement, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class _$SettlementSummaryCopyWith<$Res> implements $SettlementSummaryCopyWith<$Res> {
  factory _$SettlementSummaryCopyWith(_SettlementSummary value, $Res Function(_SettlementSummary) _then) = __$SettlementSummaryCopyWithImpl;
@override @useResult
$Res call({
 DebtSettlement settlement, String transferReference, String counterpartyDisplayName, String remainingAmountAfterSettlement, bool isCompleted
});


@override $DebtSettlementCopyWith<$Res> get settlement;

}
/// @nodoc
class __$SettlementSummaryCopyWithImpl<$Res>
    implements _$SettlementSummaryCopyWith<$Res> {
  __$SettlementSummaryCopyWithImpl(this._self, this._then);

  final _SettlementSummary _self;
  final $Res Function(_SettlementSummary) _then;

/// Create a copy of SettlementSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? settlement = null,Object? transferReference = null,Object? counterpartyDisplayName = null,Object? remainingAmountAfterSettlement = null,Object? isCompleted = null,}) {
  return _then(_SettlementSummary(
settlement: null == settlement ? _self.settlement : settlement // ignore: cast_nullable_to_non_nullable
as DebtSettlement,transferReference: null == transferReference ? _self.transferReference : transferReference // ignore: cast_nullable_to_non_nullable
as String,counterpartyDisplayName: null == counterpartyDisplayName ? _self.counterpartyDisplayName : counterpartyDisplayName // ignore: cast_nullable_to_non_nullable
as String,remainingAmountAfterSettlement: null == remainingAmountAfterSettlement ? _self.remainingAmountAfterSettlement : remainingAmountAfterSettlement // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SettlementSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DebtSettlementCopyWith<$Res> get settlement {
  
  return $DebtSettlementCopyWith<$Res>(_self.settlement, (value) {
    return _then(_self.copyWith(settlement: value));
  });
}
}

// dart format on
