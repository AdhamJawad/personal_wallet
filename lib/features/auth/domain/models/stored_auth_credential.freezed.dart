// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stored_auth_credential.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoredAuthCredential {

 String get phoneNumber; String get password;
/// Create a copy of StoredAuthCredential
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoredAuthCredentialCopyWith<StoredAuthCredential> get copyWith => _$StoredAuthCredentialCopyWithImpl<StoredAuthCredential>(this as StoredAuthCredential, _$identity);

  /// Serializes this StoredAuthCredential to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoredAuthCredential&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phoneNumber,password);

@override
String toString() {
  return 'StoredAuthCredential(phoneNumber: $phoneNumber, password: $password)';
}


}

/// @nodoc
abstract mixin class $StoredAuthCredentialCopyWith<$Res>  {
  factory $StoredAuthCredentialCopyWith(StoredAuthCredential value, $Res Function(StoredAuthCredential) _then) = _$StoredAuthCredentialCopyWithImpl;
@useResult
$Res call({
 String phoneNumber, String password
});




}
/// @nodoc
class _$StoredAuthCredentialCopyWithImpl<$Res>
    implements $StoredAuthCredentialCopyWith<$Res> {
  _$StoredAuthCredentialCopyWithImpl(this._self, this._then);

  final StoredAuthCredential _self;
  final $Res Function(StoredAuthCredential) _then;

/// Create a copy of StoredAuthCredential
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phoneNumber = null,Object? password = null,}) {
  return _then(_self.copyWith(
phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StoredAuthCredential].
extension StoredAuthCredentialPatterns on StoredAuthCredential {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoredAuthCredential value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoredAuthCredential() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoredAuthCredential value)  $default,){
final _that = this;
switch (_that) {
case _StoredAuthCredential():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoredAuthCredential value)?  $default,){
final _that = this;
switch (_that) {
case _StoredAuthCredential() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String phoneNumber,  String password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoredAuthCredential() when $default != null:
return $default(_that.phoneNumber,_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String phoneNumber,  String password)  $default,) {final _that = this;
switch (_that) {
case _StoredAuthCredential():
return $default(_that.phoneNumber,_that.password);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String phoneNumber,  String password)?  $default,) {final _that = this;
switch (_that) {
case _StoredAuthCredential() when $default != null:
return $default(_that.phoneNumber,_that.password);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoredAuthCredential implements StoredAuthCredential {
  const _StoredAuthCredential({required this.phoneNumber, required this.password});
  factory _StoredAuthCredential.fromJson(Map<String, dynamic> json) => _$StoredAuthCredentialFromJson(json);

@override final  String phoneNumber;
@override final  String password;

/// Create a copy of StoredAuthCredential
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoredAuthCredentialCopyWith<_StoredAuthCredential> get copyWith => __$StoredAuthCredentialCopyWithImpl<_StoredAuthCredential>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoredAuthCredentialToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoredAuthCredential&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phoneNumber,password);

@override
String toString() {
  return 'StoredAuthCredential(phoneNumber: $phoneNumber, password: $password)';
}


}

/// @nodoc
abstract mixin class _$StoredAuthCredentialCopyWith<$Res> implements $StoredAuthCredentialCopyWith<$Res> {
  factory _$StoredAuthCredentialCopyWith(_StoredAuthCredential value, $Res Function(_StoredAuthCredential) _then) = __$StoredAuthCredentialCopyWithImpl;
@override @useResult
$Res call({
 String phoneNumber, String password
});




}
/// @nodoc
class __$StoredAuthCredentialCopyWithImpl<$Res>
    implements _$StoredAuthCredentialCopyWith<$Res> {
  __$StoredAuthCredentialCopyWithImpl(this._self, this._then);

  final _StoredAuthCredential _self;
  final $Res Function(_StoredAuthCredential) _then;

/// Create a copy of StoredAuthCredential
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phoneNumber = null,Object? password = null,}) {
  return _then(_StoredAuthCredential(
phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
