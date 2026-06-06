// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_balance_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletBalanceSnapshot {

 String get walletId; Money get usdBalance; Money get sypBalance;@DateTimeConverter() DateTime get asOf;
/// Create a copy of WalletBalanceSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletBalanceSnapshotCopyWith<WalletBalanceSnapshot> get copyWith => _$WalletBalanceSnapshotCopyWithImpl<WalletBalanceSnapshot>(this as WalletBalanceSnapshot, _$identity);

  /// Serializes this WalletBalanceSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletBalanceSnapshot&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.usdBalance, usdBalance) || other.usdBalance == usdBalance)&&(identical(other.sypBalance, sypBalance) || other.sypBalance == sypBalance)&&(identical(other.asOf, asOf) || other.asOf == asOf));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,walletId,usdBalance,sypBalance,asOf);

@override
String toString() {
  return 'WalletBalanceSnapshot(walletId: $walletId, usdBalance: $usdBalance, sypBalance: $sypBalance, asOf: $asOf)';
}


}

/// @nodoc
abstract mixin class $WalletBalanceSnapshotCopyWith<$Res>  {
  factory $WalletBalanceSnapshotCopyWith(WalletBalanceSnapshot value, $Res Function(WalletBalanceSnapshot) _then) = _$WalletBalanceSnapshotCopyWithImpl;
@useResult
$Res call({
 String walletId, Money usdBalance, Money sypBalance,@DateTimeConverter() DateTime asOf
});


$MoneyCopyWith<$Res> get usdBalance;$MoneyCopyWith<$Res> get sypBalance;

}
/// @nodoc
class _$WalletBalanceSnapshotCopyWithImpl<$Res>
    implements $WalletBalanceSnapshotCopyWith<$Res> {
  _$WalletBalanceSnapshotCopyWithImpl(this._self, this._then);

  final WalletBalanceSnapshot _self;
  final $Res Function(WalletBalanceSnapshot) _then;

/// Create a copy of WalletBalanceSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? walletId = null,Object? usdBalance = null,Object? sypBalance = null,Object? asOf = null,}) {
  return _then(_self.copyWith(
walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,usdBalance: null == usdBalance ? _self.usdBalance : usdBalance // ignore: cast_nullable_to_non_nullable
as Money,sypBalance: null == sypBalance ? _self.sypBalance : sypBalance // ignore: cast_nullable_to_non_nullable
as Money,asOf: null == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of WalletBalanceSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get usdBalance {
  
  return $MoneyCopyWith<$Res>(_self.usdBalance, (value) {
    return _then(_self.copyWith(usdBalance: value));
  });
}/// Create a copy of WalletBalanceSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get sypBalance {
  
  return $MoneyCopyWith<$Res>(_self.sypBalance, (value) {
    return _then(_self.copyWith(sypBalance: value));
  });
}
}


/// Adds pattern-matching-related methods to [WalletBalanceSnapshot].
extension WalletBalanceSnapshotPatterns on WalletBalanceSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletBalanceSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletBalanceSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletBalanceSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _WalletBalanceSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletBalanceSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _WalletBalanceSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String walletId,  Money usdBalance,  Money sypBalance, @DateTimeConverter()  DateTime asOf)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletBalanceSnapshot() when $default != null:
return $default(_that.walletId,_that.usdBalance,_that.sypBalance,_that.asOf);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String walletId,  Money usdBalance,  Money sypBalance, @DateTimeConverter()  DateTime asOf)  $default,) {final _that = this;
switch (_that) {
case _WalletBalanceSnapshot():
return $default(_that.walletId,_that.usdBalance,_that.sypBalance,_that.asOf);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String walletId,  Money usdBalance,  Money sypBalance, @DateTimeConverter()  DateTime asOf)?  $default,) {final _that = this;
switch (_that) {
case _WalletBalanceSnapshot() when $default != null:
return $default(_that.walletId,_that.usdBalance,_that.sypBalance,_that.asOf);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalletBalanceSnapshot implements WalletBalanceSnapshot {
  const _WalletBalanceSnapshot({required this.walletId, required this.usdBalance, required this.sypBalance, @DateTimeConverter() required this.asOf});
  factory _WalletBalanceSnapshot.fromJson(Map<String, dynamic> json) => _$WalletBalanceSnapshotFromJson(json);

@override final  String walletId;
@override final  Money usdBalance;
@override final  Money sypBalance;
@override@DateTimeConverter() final  DateTime asOf;

/// Create a copy of WalletBalanceSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletBalanceSnapshotCopyWith<_WalletBalanceSnapshot> get copyWith => __$WalletBalanceSnapshotCopyWithImpl<_WalletBalanceSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletBalanceSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletBalanceSnapshot&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.usdBalance, usdBalance) || other.usdBalance == usdBalance)&&(identical(other.sypBalance, sypBalance) || other.sypBalance == sypBalance)&&(identical(other.asOf, asOf) || other.asOf == asOf));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,walletId,usdBalance,sypBalance,asOf);

@override
String toString() {
  return 'WalletBalanceSnapshot(walletId: $walletId, usdBalance: $usdBalance, sypBalance: $sypBalance, asOf: $asOf)';
}


}

/// @nodoc
abstract mixin class _$WalletBalanceSnapshotCopyWith<$Res> implements $WalletBalanceSnapshotCopyWith<$Res> {
  factory _$WalletBalanceSnapshotCopyWith(_WalletBalanceSnapshot value, $Res Function(_WalletBalanceSnapshot) _then) = __$WalletBalanceSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String walletId, Money usdBalance, Money sypBalance,@DateTimeConverter() DateTime asOf
});


@override $MoneyCopyWith<$Res> get usdBalance;@override $MoneyCopyWith<$Res> get sypBalance;

}
/// @nodoc
class __$WalletBalanceSnapshotCopyWithImpl<$Res>
    implements _$WalletBalanceSnapshotCopyWith<$Res> {
  __$WalletBalanceSnapshotCopyWithImpl(this._self, this._then);

  final _WalletBalanceSnapshot _self;
  final $Res Function(_WalletBalanceSnapshot) _then;

/// Create a copy of WalletBalanceSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? walletId = null,Object? usdBalance = null,Object? sypBalance = null,Object? asOf = null,}) {
  return _then(_WalletBalanceSnapshot(
walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,usdBalance: null == usdBalance ? _self.usdBalance : usdBalance // ignore: cast_nullable_to_non_nullable
as Money,sypBalance: null == sypBalance ? _self.sypBalance : sypBalance // ignore: cast_nullable_to_non_nullable
as Money,asOf: null == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of WalletBalanceSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get usdBalance {
  
  return $MoneyCopyWith<$Res>(_self.usdBalance, (value) {
    return _then(_self.copyWith(usdBalance: value));
  });
}/// Create a copy of WalletBalanceSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get sypBalance {
  
  return $MoneyCopyWith<$Res>(_self.sypBalance, (value) {
    return _then(_self.copyWith(sypBalance: value));
  });
}
}

// dart format on
