// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ledger_balance_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LedgerBalanceSummary {

 String get walletId; Money get usdBalance; Money get sypBalance;
/// Create a copy of LedgerBalanceSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LedgerBalanceSummaryCopyWith<LedgerBalanceSummary> get copyWith => _$LedgerBalanceSummaryCopyWithImpl<LedgerBalanceSummary>(this as LedgerBalanceSummary, _$identity);

  /// Serializes this LedgerBalanceSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LedgerBalanceSummary&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.usdBalance, usdBalance) || other.usdBalance == usdBalance)&&(identical(other.sypBalance, sypBalance) || other.sypBalance == sypBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,walletId,usdBalance,sypBalance);

@override
String toString() {
  return 'LedgerBalanceSummary(walletId: $walletId, usdBalance: $usdBalance, sypBalance: $sypBalance)';
}


}

/// @nodoc
abstract mixin class $LedgerBalanceSummaryCopyWith<$Res>  {
  factory $LedgerBalanceSummaryCopyWith(LedgerBalanceSummary value, $Res Function(LedgerBalanceSummary) _then) = _$LedgerBalanceSummaryCopyWithImpl;
@useResult
$Res call({
 String walletId, Money usdBalance, Money sypBalance
});




}
/// @nodoc
class _$LedgerBalanceSummaryCopyWithImpl<$Res>
    implements $LedgerBalanceSummaryCopyWith<$Res> {
  _$LedgerBalanceSummaryCopyWithImpl(this._self, this._then);

  final LedgerBalanceSummary _self;
  final $Res Function(LedgerBalanceSummary) _then;

/// Create a copy of LedgerBalanceSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? walletId = null,Object? usdBalance = null,Object? sypBalance = null,}) {
  return _then(_self.copyWith(
walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,usdBalance: null == usdBalance ? _self.usdBalance : usdBalance // ignore: cast_nullable_to_non_nullable
as Money,sypBalance: null == sypBalance ? _self.sypBalance : sypBalance // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}

}


/// Adds pattern-matching-related methods to [LedgerBalanceSummary].
extension LedgerBalanceSummaryPatterns on LedgerBalanceSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LedgerBalanceSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LedgerBalanceSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LedgerBalanceSummary value)  $default,){
final _that = this;
switch (_that) {
case _LedgerBalanceSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LedgerBalanceSummary value)?  $default,){
final _that = this;
switch (_that) {
case _LedgerBalanceSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String walletId,  Money usdBalance,  Money sypBalance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LedgerBalanceSummary() when $default != null:
return $default(_that.walletId,_that.usdBalance,_that.sypBalance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String walletId,  Money usdBalance,  Money sypBalance)  $default,) {final _that = this;
switch (_that) {
case _LedgerBalanceSummary():
return $default(_that.walletId,_that.usdBalance,_that.sypBalance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String walletId,  Money usdBalance,  Money sypBalance)?  $default,) {final _that = this;
switch (_that) {
case _LedgerBalanceSummary() when $default != null:
return $default(_that.walletId,_that.usdBalance,_that.sypBalance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LedgerBalanceSummary implements LedgerBalanceSummary {
  const _LedgerBalanceSummary({required this.walletId, required this.usdBalance, required this.sypBalance});
  factory _LedgerBalanceSummary.fromJson(Map<String, dynamic> json) => _$LedgerBalanceSummaryFromJson(json);

@override final  String walletId;
@override final  Money usdBalance;
@override final  Money sypBalance;

/// Create a copy of LedgerBalanceSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LedgerBalanceSummaryCopyWith<_LedgerBalanceSummary> get copyWith => __$LedgerBalanceSummaryCopyWithImpl<_LedgerBalanceSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LedgerBalanceSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LedgerBalanceSummary&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.usdBalance, usdBalance) || other.usdBalance == usdBalance)&&(identical(other.sypBalance, sypBalance) || other.sypBalance == sypBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,walletId,usdBalance,sypBalance);

@override
String toString() {
  return 'LedgerBalanceSummary(walletId: $walletId, usdBalance: $usdBalance, sypBalance: $sypBalance)';
}


}

/// @nodoc
abstract mixin class _$LedgerBalanceSummaryCopyWith<$Res> implements $LedgerBalanceSummaryCopyWith<$Res> {
  factory _$LedgerBalanceSummaryCopyWith(_LedgerBalanceSummary value, $Res Function(_LedgerBalanceSummary) _then) = __$LedgerBalanceSummaryCopyWithImpl;
@override @useResult
$Res call({
 String walletId, Money usdBalance, Money sypBalance
});




}
/// @nodoc
class __$LedgerBalanceSummaryCopyWithImpl<$Res>
    implements _$LedgerBalanceSummaryCopyWith<$Res> {
  __$LedgerBalanceSummaryCopyWithImpl(this._self, this._then);

  final _LedgerBalanceSummary _self;
  final $Res Function(_LedgerBalanceSummary) _then;

/// Create a copy of LedgerBalanceSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? walletId = null,Object? usdBalance = null,Object? sypBalance = null,}) {
  return _then(_LedgerBalanceSummary(
walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,usdBalance: null == usdBalance ? _self.usdBalance : usdBalance // ignore: cast_nullable_to_non_nullable
as Money,sypBalance: null == sypBalance ? _self.sypBalance : sypBalance // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}


}

// dart format on
