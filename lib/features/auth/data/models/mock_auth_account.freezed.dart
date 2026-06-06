// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mock_auth_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MockAuthAccount {

 AppUser get user; String get password;
/// Create a copy of MockAuthAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MockAuthAccountCopyWith<MockAuthAccount> get copyWith => _$MockAuthAccountCopyWithImpl<MockAuthAccount>(this as MockAuthAccount, _$identity);

  /// Serializes this MockAuthAccount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MockAuthAccount&&(identical(other.user, user) || other.user == user)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,password);

@override
String toString() {
  return 'MockAuthAccount(user: $user, password: $password)';
}


}

/// @nodoc
abstract mixin class $MockAuthAccountCopyWith<$Res>  {
  factory $MockAuthAccountCopyWith(MockAuthAccount value, $Res Function(MockAuthAccount) _then) = _$MockAuthAccountCopyWithImpl;
@useResult
$Res call({
 AppUser user, String password
});


$AppUserCopyWith<$Res> get user;

}
/// @nodoc
class _$MockAuthAccountCopyWithImpl<$Res>
    implements $MockAuthAccountCopyWith<$Res> {
  _$MockAuthAccountCopyWithImpl(this._self, this._then);

  final MockAuthAccount _self;
  final $Res Function(MockAuthAccount) _then;

/// Create a copy of MockAuthAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? password = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AppUser,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of MockAuthAccount
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppUserCopyWith<$Res> get user {
  
  return $AppUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [MockAuthAccount].
extension MockAuthAccountPatterns on MockAuthAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MockAuthAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MockAuthAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MockAuthAccount value)  $default,){
final _that = this;
switch (_that) {
case _MockAuthAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MockAuthAccount value)?  $default,){
final _that = this;
switch (_that) {
case _MockAuthAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppUser user,  String password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MockAuthAccount() when $default != null:
return $default(_that.user,_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppUser user,  String password)  $default,) {final _that = this;
switch (_that) {
case _MockAuthAccount():
return $default(_that.user,_that.password);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppUser user,  String password)?  $default,) {final _that = this;
switch (_that) {
case _MockAuthAccount() when $default != null:
return $default(_that.user,_that.password);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MockAuthAccount implements MockAuthAccount {
  const _MockAuthAccount({required this.user, required this.password});
  factory _MockAuthAccount.fromJson(Map<String, dynamic> json) => _$MockAuthAccountFromJson(json);

@override final  AppUser user;
@override final  String password;

/// Create a copy of MockAuthAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MockAuthAccountCopyWith<_MockAuthAccount> get copyWith => __$MockAuthAccountCopyWithImpl<_MockAuthAccount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MockAuthAccountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MockAuthAccount&&(identical(other.user, user) || other.user == user)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,password);

@override
String toString() {
  return 'MockAuthAccount(user: $user, password: $password)';
}


}

/// @nodoc
abstract mixin class _$MockAuthAccountCopyWith<$Res> implements $MockAuthAccountCopyWith<$Res> {
  factory _$MockAuthAccountCopyWith(_MockAuthAccount value, $Res Function(_MockAuthAccount) _then) = __$MockAuthAccountCopyWithImpl;
@override @useResult
$Res call({
 AppUser user, String password
});


@override $AppUserCopyWith<$Res> get user;

}
/// @nodoc
class __$MockAuthAccountCopyWithImpl<$Res>
    implements _$MockAuthAccountCopyWith<$Res> {
  __$MockAuthAccountCopyWithImpl(this._self, this._then);

  final _MockAuthAccount _self;
  final $Res Function(_MockAuthAccount) _then;

/// Create a copy of MockAuthAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? password = null,}) {
  return _then(_MockAuthAccount(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AppUser,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of MockAuthAccount
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppUserCopyWith<$Res> get user {
  
  return $AppUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
