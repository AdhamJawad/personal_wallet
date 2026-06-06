// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pending_otp_verification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PendingOtpVerification {

 String get verificationId; String get fullName; String get phoneNumber; String get password;@DateTimeConverter() DateTime get createdAt;
/// Create a copy of PendingOtpVerification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PendingOtpVerificationCopyWith<PendingOtpVerification> get copyWith => _$PendingOtpVerificationCopyWithImpl<PendingOtpVerification>(this as PendingOtpVerification, _$identity);

  /// Serializes this PendingOtpVerification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PendingOtpVerification&&(identical(other.verificationId, verificationId) || other.verificationId == verificationId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.password, password) || other.password == password)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,verificationId,fullName,phoneNumber,password,createdAt);

@override
String toString() {
  return 'PendingOtpVerification(verificationId: $verificationId, fullName: $fullName, phoneNumber: $phoneNumber, password: $password, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PendingOtpVerificationCopyWith<$Res>  {
  factory $PendingOtpVerificationCopyWith(PendingOtpVerification value, $Res Function(PendingOtpVerification) _then) = _$PendingOtpVerificationCopyWithImpl;
@useResult
$Res call({
 String verificationId, String fullName, String phoneNumber, String password,@DateTimeConverter() DateTime createdAt
});




}
/// @nodoc
class _$PendingOtpVerificationCopyWithImpl<$Res>
    implements $PendingOtpVerificationCopyWith<$Res> {
  _$PendingOtpVerificationCopyWithImpl(this._self, this._then);

  final PendingOtpVerification _self;
  final $Res Function(PendingOtpVerification) _then;

/// Create a copy of PendingOtpVerification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? verificationId = null,Object? fullName = null,Object? phoneNumber = null,Object? password = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
verificationId: null == verificationId ? _self.verificationId : verificationId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PendingOtpVerification].
extension PendingOtpVerificationPatterns on PendingOtpVerification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PendingOtpVerification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PendingOtpVerification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PendingOtpVerification value)  $default,){
final _that = this;
switch (_that) {
case _PendingOtpVerification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PendingOtpVerification value)?  $default,){
final _that = this;
switch (_that) {
case _PendingOtpVerification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String verificationId,  String fullName,  String phoneNumber,  String password, @DateTimeConverter()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PendingOtpVerification() when $default != null:
return $default(_that.verificationId,_that.fullName,_that.phoneNumber,_that.password,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String verificationId,  String fullName,  String phoneNumber,  String password, @DateTimeConverter()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _PendingOtpVerification():
return $default(_that.verificationId,_that.fullName,_that.phoneNumber,_that.password,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String verificationId,  String fullName,  String phoneNumber,  String password, @DateTimeConverter()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PendingOtpVerification() when $default != null:
return $default(_that.verificationId,_that.fullName,_that.phoneNumber,_that.password,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PendingOtpVerification implements PendingOtpVerification {
  const _PendingOtpVerification({required this.verificationId, required this.fullName, required this.phoneNumber, required this.password, @DateTimeConverter() required this.createdAt});
  factory _PendingOtpVerification.fromJson(Map<String, dynamic> json) => _$PendingOtpVerificationFromJson(json);

@override final  String verificationId;
@override final  String fullName;
@override final  String phoneNumber;
@override final  String password;
@override@DateTimeConverter() final  DateTime createdAt;

/// Create a copy of PendingOtpVerification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingOtpVerificationCopyWith<_PendingOtpVerification> get copyWith => __$PendingOtpVerificationCopyWithImpl<_PendingOtpVerification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PendingOtpVerificationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingOtpVerification&&(identical(other.verificationId, verificationId) || other.verificationId == verificationId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.password, password) || other.password == password)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,verificationId,fullName,phoneNumber,password,createdAt);

@override
String toString() {
  return 'PendingOtpVerification(verificationId: $verificationId, fullName: $fullName, phoneNumber: $phoneNumber, password: $password, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PendingOtpVerificationCopyWith<$Res> implements $PendingOtpVerificationCopyWith<$Res> {
  factory _$PendingOtpVerificationCopyWith(_PendingOtpVerification value, $Res Function(_PendingOtpVerification) _then) = __$PendingOtpVerificationCopyWithImpl;
@override @useResult
$Res call({
 String verificationId, String fullName, String phoneNumber, String password,@DateTimeConverter() DateTime createdAt
});




}
/// @nodoc
class __$PendingOtpVerificationCopyWithImpl<$Res>
    implements _$PendingOtpVerificationCopyWith<$Res> {
  __$PendingOtpVerificationCopyWithImpl(this._self, this._then);

  final _PendingOtpVerification _self;
  final $Res Function(_PendingOtpVerification) _then;

/// Create a copy of PendingOtpVerification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? verificationId = null,Object? fullName = null,Object? phoneNumber = null,Object? password = null,Object? createdAt = null,}) {
  return _then(_PendingOtpVerification(
verificationId: null == verificationId ? _self.verificationId : verificationId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
