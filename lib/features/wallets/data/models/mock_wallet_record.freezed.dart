// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mock_wallet_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MockWalletRecord {

 Wallet get wallet;
/// Create a copy of MockWalletRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MockWalletRecordCopyWith<MockWalletRecord> get copyWith => _$MockWalletRecordCopyWithImpl<MockWalletRecord>(this as MockWalletRecord, _$identity);

  /// Serializes this MockWalletRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MockWalletRecord&&(identical(other.wallet, wallet) || other.wallet == wallet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wallet);

@override
String toString() {
  return 'MockWalletRecord(wallet: $wallet)';
}


}

/// @nodoc
abstract mixin class $MockWalletRecordCopyWith<$Res>  {
  factory $MockWalletRecordCopyWith(MockWalletRecord value, $Res Function(MockWalletRecord) _then) = _$MockWalletRecordCopyWithImpl;
@useResult
$Res call({
 Wallet wallet
});


$WalletCopyWith<$Res> get wallet;

}
/// @nodoc
class _$MockWalletRecordCopyWithImpl<$Res>
    implements $MockWalletRecordCopyWith<$Res> {
  _$MockWalletRecordCopyWithImpl(this._self, this._then);

  final MockWalletRecord _self;
  final $Res Function(MockWalletRecord) _then;

/// Create a copy of MockWalletRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wallet = null,}) {
  return _then(_self.copyWith(
wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as Wallet,
  ));
}
/// Create a copy of MockWalletRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletCopyWith<$Res> get wallet {
  
  return $WalletCopyWith<$Res>(_self.wallet, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}
}


/// Adds pattern-matching-related methods to [MockWalletRecord].
extension MockWalletRecordPatterns on MockWalletRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MockWalletRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MockWalletRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MockWalletRecord value)  $default,){
final _that = this;
switch (_that) {
case _MockWalletRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MockWalletRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MockWalletRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Wallet wallet)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MockWalletRecord() when $default != null:
return $default(_that.wallet);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Wallet wallet)  $default,) {final _that = this;
switch (_that) {
case _MockWalletRecord():
return $default(_that.wallet);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Wallet wallet)?  $default,) {final _that = this;
switch (_that) {
case _MockWalletRecord() when $default != null:
return $default(_that.wallet);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MockWalletRecord implements MockWalletRecord {
  const _MockWalletRecord({required this.wallet});
  factory _MockWalletRecord.fromJson(Map<String, dynamic> json) => _$MockWalletRecordFromJson(json);

@override final  Wallet wallet;

/// Create a copy of MockWalletRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MockWalletRecordCopyWith<_MockWalletRecord> get copyWith => __$MockWalletRecordCopyWithImpl<_MockWalletRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MockWalletRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MockWalletRecord&&(identical(other.wallet, wallet) || other.wallet == wallet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wallet);

@override
String toString() {
  return 'MockWalletRecord(wallet: $wallet)';
}


}

/// @nodoc
abstract mixin class _$MockWalletRecordCopyWith<$Res> implements $MockWalletRecordCopyWith<$Res> {
  factory _$MockWalletRecordCopyWith(_MockWalletRecord value, $Res Function(_MockWalletRecord) _then) = __$MockWalletRecordCopyWithImpl;
@override @useResult
$Res call({
 Wallet wallet
});


@override $WalletCopyWith<$Res> get wallet;

}
/// @nodoc
class __$MockWalletRecordCopyWithImpl<$Res>
    implements _$MockWalletRecordCopyWith<$Res> {
  __$MockWalletRecordCopyWithImpl(this._self, this._then);

  final _MockWalletRecord _self;
  final $Res Function(_MockWalletRecord) _then;

/// Create a copy of MockWalletRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wallet = null,}) {
  return _then(_MockWalletRecord(
wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as Wallet,
  ));
}

/// Create a copy of MockWalletRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletCopyWith<$Res> get wallet {
  
  return $WalletCopyWith<$Res>(_self.wallet, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}
}

// dart format on
