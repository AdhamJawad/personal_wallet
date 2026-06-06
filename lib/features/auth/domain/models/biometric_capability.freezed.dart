// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'biometric_capability.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BiometricCapability {

 bool get isDeviceSupported; bool get hasEnrolledBiometrics; bool get hasFaceId; bool get hasFingerprint;
/// Create a copy of BiometricCapability
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BiometricCapabilityCopyWith<BiometricCapability> get copyWith => _$BiometricCapabilityCopyWithImpl<BiometricCapability>(this as BiometricCapability, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BiometricCapability&&(identical(other.isDeviceSupported, isDeviceSupported) || other.isDeviceSupported == isDeviceSupported)&&(identical(other.hasEnrolledBiometrics, hasEnrolledBiometrics) || other.hasEnrolledBiometrics == hasEnrolledBiometrics)&&(identical(other.hasFaceId, hasFaceId) || other.hasFaceId == hasFaceId)&&(identical(other.hasFingerprint, hasFingerprint) || other.hasFingerprint == hasFingerprint));
}


@override
int get hashCode => Object.hash(runtimeType,isDeviceSupported,hasEnrolledBiometrics,hasFaceId,hasFingerprint);

@override
String toString() {
  return 'BiometricCapability(isDeviceSupported: $isDeviceSupported, hasEnrolledBiometrics: $hasEnrolledBiometrics, hasFaceId: $hasFaceId, hasFingerprint: $hasFingerprint)';
}


}

/// @nodoc
abstract mixin class $BiometricCapabilityCopyWith<$Res>  {
  factory $BiometricCapabilityCopyWith(BiometricCapability value, $Res Function(BiometricCapability) _then) = _$BiometricCapabilityCopyWithImpl;
@useResult
$Res call({
 bool isDeviceSupported, bool hasEnrolledBiometrics, bool hasFaceId, bool hasFingerprint
});




}
/// @nodoc
class _$BiometricCapabilityCopyWithImpl<$Res>
    implements $BiometricCapabilityCopyWith<$Res> {
  _$BiometricCapabilityCopyWithImpl(this._self, this._then);

  final BiometricCapability _self;
  final $Res Function(BiometricCapability) _then;

/// Create a copy of BiometricCapability
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isDeviceSupported = null,Object? hasEnrolledBiometrics = null,Object? hasFaceId = null,Object? hasFingerprint = null,}) {
  return _then(_self.copyWith(
isDeviceSupported: null == isDeviceSupported ? _self.isDeviceSupported : isDeviceSupported // ignore: cast_nullable_to_non_nullable
as bool,hasEnrolledBiometrics: null == hasEnrolledBiometrics ? _self.hasEnrolledBiometrics : hasEnrolledBiometrics // ignore: cast_nullable_to_non_nullable
as bool,hasFaceId: null == hasFaceId ? _self.hasFaceId : hasFaceId // ignore: cast_nullable_to_non_nullable
as bool,hasFingerprint: null == hasFingerprint ? _self.hasFingerprint : hasFingerprint // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BiometricCapability].
extension BiometricCapabilityPatterns on BiometricCapability {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BiometricCapability value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BiometricCapability() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BiometricCapability value)  $default,){
final _that = this;
switch (_that) {
case _BiometricCapability():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BiometricCapability value)?  $default,){
final _that = this;
switch (_that) {
case _BiometricCapability() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isDeviceSupported,  bool hasEnrolledBiometrics,  bool hasFaceId,  bool hasFingerprint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BiometricCapability() when $default != null:
return $default(_that.isDeviceSupported,_that.hasEnrolledBiometrics,_that.hasFaceId,_that.hasFingerprint);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isDeviceSupported,  bool hasEnrolledBiometrics,  bool hasFaceId,  bool hasFingerprint)  $default,) {final _that = this;
switch (_that) {
case _BiometricCapability():
return $default(_that.isDeviceSupported,_that.hasEnrolledBiometrics,_that.hasFaceId,_that.hasFingerprint);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isDeviceSupported,  bool hasEnrolledBiometrics,  bool hasFaceId,  bool hasFingerprint)?  $default,) {final _that = this;
switch (_that) {
case _BiometricCapability() when $default != null:
return $default(_that.isDeviceSupported,_that.hasEnrolledBiometrics,_that.hasFaceId,_that.hasFingerprint);case _:
  return null;

}
}

}

/// @nodoc


class _BiometricCapability extends BiometricCapability {
  const _BiometricCapability({this.isDeviceSupported = false, this.hasEnrolledBiometrics = false, this.hasFaceId = false, this.hasFingerprint = false}): super._();
  

@override@JsonKey() final  bool isDeviceSupported;
@override@JsonKey() final  bool hasEnrolledBiometrics;
@override@JsonKey() final  bool hasFaceId;
@override@JsonKey() final  bool hasFingerprint;

/// Create a copy of BiometricCapability
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BiometricCapabilityCopyWith<_BiometricCapability> get copyWith => __$BiometricCapabilityCopyWithImpl<_BiometricCapability>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BiometricCapability&&(identical(other.isDeviceSupported, isDeviceSupported) || other.isDeviceSupported == isDeviceSupported)&&(identical(other.hasEnrolledBiometrics, hasEnrolledBiometrics) || other.hasEnrolledBiometrics == hasEnrolledBiometrics)&&(identical(other.hasFaceId, hasFaceId) || other.hasFaceId == hasFaceId)&&(identical(other.hasFingerprint, hasFingerprint) || other.hasFingerprint == hasFingerprint));
}


@override
int get hashCode => Object.hash(runtimeType,isDeviceSupported,hasEnrolledBiometrics,hasFaceId,hasFingerprint);

@override
String toString() {
  return 'BiometricCapability(isDeviceSupported: $isDeviceSupported, hasEnrolledBiometrics: $hasEnrolledBiometrics, hasFaceId: $hasFaceId, hasFingerprint: $hasFingerprint)';
}


}

/// @nodoc
abstract mixin class _$BiometricCapabilityCopyWith<$Res> implements $BiometricCapabilityCopyWith<$Res> {
  factory _$BiometricCapabilityCopyWith(_BiometricCapability value, $Res Function(_BiometricCapability) _then) = __$BiometricCapabilityCopyWithImpl;
@override @useResult
$Res call({
 bool isDeviceSupported, bool hasEnrolledBiometrics, bool hasFaceId, bool hasFingerprint
});




}
/// @nodoc
class __$BiometricCapabilityCopyWithImpl<$Res>
    implements _$BiometricCapabilityCopyWith<$Res> {
  __$BiometricCapabilityCopyWithImpl(this._self, this._then);

  final _BiometricCapability _self;
  final $Res Function(_BiometricCapability) _then;

/// Create a copy of BiometricCapability
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isDeviceSupported = null,Object? hasEnrolledBiometrics = null,Object? hasFaceId = null,Object? hasFingerprint = null,}) {
  return _then(_BiometricCapability(
isDeviceSupported: null == isDeviceSupported ? _self.isDeviceSupported : isDeviceSupported // ignore: cast_nullable_to_non_nullable
as bool,hasEnrolledBiometrics: null == hasEnrolledBiometrics ? _self.hasEnrolledBiometrics : hasEnrolledBiometrics // ignore: cast_nullable_to_non_nullable
as bool,hasFaceId: null == hasFaceId ? _self.hasFaceId : hasFaceId // ignore: cast_nullable_to_non_nullable
as bool,hasFingerprint: null == hasFingerprint ? _self.hasFingerprint : hasFingerprint // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
