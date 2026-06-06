// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_overview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletOverview {

 Wallet get wallet; WalletBalanceSnapshot get balance;
/// Create a copy of WalletOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletOverviewCopyWith<WalletOverview> get copyWith => _$WalletOverviewCopyWithImpl<WalletOverview>(this as WalletOverview, _$identity);

  /// Serializes this WalletOverview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletOverview&&(identical(other.wallet, wallet) || other.wallet == wallet)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wallet,balance);

@override
String toString() {
  return 'WalletOverview(wallet: $wallet, balance: $balance)';
}


}

/// @nodoc
abstract mixin class $WalletOverviewCopyWith<$Res>  {
  factory $WalletOverviewCopyWith(WalletOverview value, $Res Function(WalletOverview) _then) = _$WalletOverviewCopyWithImpl;
@useResult
$Res call({
 Wallet wallet, WalletBalanceSnapshot balance
});


$WalletCopyWith<$Res> get wallet;$WalletBalanceSnapshotCopyWith<$Res> get balance;

}
/// @nodoc
class _$WalletOverviewCopyWithImpl<$Res>
    implements $WalletOverviewCopyWith<$Res> {
  _$WalletOverviewCopyWithImpl(this._self, this._then);

  final WalletOverview _self;
  final $Res Function(WalletOverview) _then;

/// Create a copy of WalletOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wallet = null,Object? balance = null,}) {
  return _then(_self.copyWith(
wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as Wallet,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as WalletBalanceSnapshot,
  ));
}
/// Create a copy of WalletOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletCopyWith<$Res> get wallet {
  
  return $WalletCopyWith<$Res>(_self.wallet, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}/// Create a copy of WalletOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletBalanceSnapshotCopyWith<$Res> get balance {
  
  return $WalletBalanceSnapshotCopyWith<$Res>(_self.balance, (value) {
    return _then(_self.copyWith(balance: value));
  });
}
}


/// Adds pattern-matching-related methods to [WalletOverview].
extension WalletOverviewPatterns on WalletOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletOverview value)  $default,){
final _that = this;
switch (_that) {
case _WalletOverview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletOverview value)?  $default,){
final _that = this;
switch (_that) {
case _WalletOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Wallet wallet,  WalletBalanceSnapshot balance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletOverview() when $default != null:
return $default(_that.wallet,_that.balance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Wallet wallet,  WalletBalanceSnapshot balance)  $default,) {final _that = this;
switch (_that) {
case _WalletOverview():
return $default(_that.wallet,_that.balance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Wallet wallet,  WalletBalanceSnapshot balance)?  $default,) {final _that = this;
switch (_that) {
case _WalletOverview() when $default != null:
return $default(_that.wallet,_that.balance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalletOverview implements WalletOverview {
  const _WalletOverview({required this.wallet, required this.balance});
  factory _WalletOverview.fromJson(Map<String, dynamic> json) => _$WalletOverviewFromJson(json);

@override final  Wallet wallet;
@override final  WalletBalanceSnapshot balance;

/// Create a copy of WalletOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletOverviewCopyWith<_WalletOverview> get copyWith => __$WalletOverviewCopyWithImpl<_WalletOverview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletOverviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletOverview&&(identical(other.wallet, wallet) || other.wallet == wallet)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wallet,balance);

@override
String toString() {
  return 'WalletOverview(wallet: $wallet, balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$WalletOverviewCopyWith<$Res> implements $WalletOverviewCopyWith<$Res> {
  factory _$WalletOverviewCopyWith(_WalletOverview value, $Res Function(_WalletOverview) _then) = __$WalletOverviewCopyWithImpl;
@override @useResult
$Res call({
 Wallet wallet, WalletBalanceSnapshot balance
});


@override $WalletCopyWith<$Res> get wallet;@override $WalletBalanceSnapshotCopyWith<$Res> get balance;

}
/// @nodoc
class __$WalletOverviewCopyWithImpl<$Res>
    implements _$WalletOverviewCopyWith<$Res> {
  __$WalletOverviewCopyWithImpl(this._self, this._then);

  final _WalletOverview _self;
  final $Res Function(_WalletOverview) _then;

/// Create a copy of WalletOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wallet = null,Object? balance = null,}) {
  return _then(_WalletOverview(
wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as Wallet,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as WalletBalanceSnapshot,
  ));
}

/// Create a copy of WalletOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletCopyWith<$Res> get wallet {
  
  return $WalletCopyWith<$Res>(_self.wallet, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}/// Create a copy of WalletOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletBalanceSnapshotCopyWith<$Res> get balance {
  
  return $WalletBalanceSnapshotCopyWith<$Res>(_self.balance, (value) {
    return _then(_self.copyWith(balance: value));
  });
}
}

// dart format on
