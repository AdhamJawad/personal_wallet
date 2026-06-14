// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransferSummary {

 UserTransfer get transfer; bool get isIncoming; bool get isDebtSettlement; String get counterpartyDisplayName;
/// Create a copy of TransferSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferSummaryCopyWith<TransferSummary> get copyWith => _$TransferSummaryCopyWithImpl<TransferSummary>(this as TransferSummary, _$identity);

  /// Serializes this TransferSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferSummary&&(identical(other.transfer, transfer) || other.transfer == transfer)&&(identical(other.isIncoming, isIncoming) || other.isIncoming == isIncoming)&&(identical(other.isDebtSettlement, isDebtSettlement) || other.isDebtSettlement == isDebtSettlement)&&(identical(other.counterpartyDisplayName, counterpartyDisplayName) || other.counterpartyDisplayName == counterpartyDisplayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transfer,isIncoming,isDebtSettlement,counterpartyDisplayName);

@override
String toString() {
  return 'TransferSummary(transfer: $transfer, isIncoming: $isIncoming, isDebtSettlement: $isDebtSettlement, counterpartyDisplayName: $counterpartyDisplayName)';
}


}

/// @nodoc
abstract mixin class $TransferSummaryCopyWith<$Res>  {
  factory $TransferSummaryCopyWith(TransferSummary value, $Res Function(TransferSummary) _then) = _$TransferSummaryCopyWithImpl;
@useResult
$Res call({
 UserTransfer transfer, bool isIncoming, bool isDebtSettlement, String counterpartyDisplayName
});




}
/// @nodoc
class _$TransferSummaryCopyWithImpl<$Res>
    implements $TransferSummaryCopyWith<$Res> {
  _$TransferSummaryCopyWithImpl(this._self, this._then);

  final TransferSummary _self;
  final $Res Function(TransferSummary) _then;

/// Create a copy of TransferSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transfer = null,Object? isIncoming = null,Object? isDebtSettlement = null,Object? counterpartyDisplayName = null,}) {
  return _then(_self.copyWith(
transfer: null == transfer ? _self.transfer : transfer // ignore: cast_nullable_to_non_nullable
as UserTransfer,isIncoming: null == isIncoming ? _self.isIncoming : isIncoming // ignore: cast_nullable_to_non_nullable
as bool,isDebtSettlement: null == isDebtSettlement ? _self.isDebtSettlement : isDebtSettlement // ignore: cast_nullable_to_non_nullable
as bool,counterpartyDisplayName: null == counterpartyDisplayName ? _self.counterpartyDisplayName : counterpartyDisplayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferSummary].
extension TransferSummaryPatterns on TransferSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferSummary value)  $default,){
final _that = this;
switch (_that) {
case _TransferSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferSummary value)?  $default,){
final _that = this;
switch (_that) {
case _TransferSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserTransfer transfer,  bool isIncoming,  bool isDebtSettlement,  String counterpartyDisplayName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferSummary() when $default != null:
return $default(_that.transfer,_that.isIncoming,_that.isDebtSettlement,_that.counterpartyDisplayName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserTransfer transfer,  bool isIncoming,  bool isDebtSettlement,  String counterpartyDisplayName)  $default,) {final _that = this;
switch (_that) {
case _TransferSummary():
return $default(_that.transfer,_that.isIncoming,_that.isDebtSettlement,_that.counterpartyDisplayName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserTransfer transfer,  bool isIncoming,  bool isDebtSettlement,  String counterpartyDisplayName)?  $default,) {final _that = this;
switch (_that) {
case _TransferSummary() when $default != null:
return $default(_that.transfer,_that.isIncoming,_that.isDebtSettlement,_that.counterpartyDisplayName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransferSummary extends TransferSummary {
  const _TransferSummary({required this.transfer, required this.isIncoming, required this.isDebtSettlement, required this.counterpartyDisplayName}): super._();
  factory _TransferSummary.fromJson(Map<String, dynamic> json) => _$TransferSummaryFromJson(json);

@override final  UserTransfer transfer;
@override final  bool isIncoming;
@override final  bool isDebtSettlement;
@override final  String counterpartyDisplayName;

/// Create a copy of TransferSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferSummaryCopyWith<_TransferSummary> get copyWith => __$TransferSummaryCopyWithImpl<_TransferSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferSummary&&(identical(other.transfer, transfer) || other.transfer == transfer)&&(identical(other.isIncoming, isIncoming) || other.isIncoming == isIncoming)&&(identical(other.isDebtSettlement, isDebtSettlement) || other.isDebtSettlement == isDebtSettlement)&&(identical(other.counterpartyDisplayName, counterpartyDisplayName) || other.counterpartyDisplayName == counterpartyDisplayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transfer,isIncoming,isDebtSettlement,counterpartyDisplayName);

@override
String toString() {
  return 'TransferSummary(transfer: $transfer, isIncoming: $isIncoming, isDebtSettlement: $isDebtSettlement, counterpartyDisplayName: $counterpartyDisplayName)';
}


}

/// @nodoc
abstract mixin class _$TransferSummaryCopyWith<$Res> implements $TransferSummaryCopyWith<$Res> {
  factory _$TransferSummaryCopyWith(_TransferSummary value, $Res Function(_TransferSummary) _then) = __$TransferSummaryCopyWithImpl;
@override @useResult
$Res call({
 UserTransfer transfer, bool isIncoming, bool isDebtSettlement, String counterpartyDisplayName
});




}
/// @nodoc
class __$TransferSummaryCopyWithImpl<$Res>
    implements _$TransferSummaryCopyWith<$Res> {
  __$TransferSummaryCopyWithImpl(this._self, this._then);

  final _TransferSummary _self;
  final $Res Function(_TransferSummary) _then;

/// Create a copy of TransferSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transfer = null,Object? isIncoming = null,Object? isDebtSettlement = null,Object? counterpartyDisplayName = null,}) {
  return _then(_TransferSummary(
transfer: null == transfer ? _self.transfer : transfer // ignore: cast_nullable_to_non_nullable
as UserTransfer,isIncoming: null == isIncoming ? _self.isIncoming : isIncoming // ignore: cast_nullable_to_non_nullable
as bool,isDebtSettlement: null == isDebtSettlement ? _self.isDebtSettlement : isDebtSettlement // ignore: cast_nullable_to_non_nullable
as bool,counterpartyDisplayName: null == counterpartyDisplayName ? _self.counterpartyDisplayName : counterpartyDisplayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
