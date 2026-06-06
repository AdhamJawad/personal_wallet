// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {

 AuthStatus get status; bool get isBusy; AuthSession? get session; PendingOtpVerification? get pendingVerification; BiometricCapability get biometricCapability; bool get isBiometricLoginEnabled; bool get hasStoredCredential;
/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateCopyWith<AuthState> get copyWith => _$AuthStateCopyWithImpl<AuthState>(this as AuthState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState&&(identical(other.status, status) || other.status == status)&&(identical(other.isBusy, isBusy) || other.isBusy == isBusy)&&(identical(other.session, session) || other.session == session)&&(identical(other.pendingVerification, pendingVerification) || other.pendingVerification == pendingVerification)&&(identical(other.biometricCapability, biometricCapability) || other.biometricCapability == biometricCapability)&&(identical(other.isBiometricLoginEnabled, isBiometricLoginEnabled) || other.isBiometricLoginEnabled == isBiometricLoginEnabled)&&(identical(other.hasStoredCredential, hasStoredCredential) || other.hasStoredCredential == hasStoredCredential));
}


@override
int get hashCode => Object.hash(runtimeType,status,isBusy,session,pendingVerification,biometricCapability,isBiometricLoginEnabled,hasStoredCredential);

@override
String toString() {
  return 'AuthState(status: $status, isBusy: $isBusy, session: $session, pendingVerification: $pendingVerification, biometricCapability: $biometricCapability, isBiometricLoginEnabled: $isBiometricLoginEnabled, hasStoredCredential: $hasStoredCredential)';
}


}

/// @nodoc
abstract mixin class $AuthStateCopyWith<$Res>  {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) _then) = _$AuthStateCopyWithImpl;
@useResult
$Res call({
 AuthStatus status, bool isBusy, AuthSession? session, PendingOtpVerification? pendingVerification, BiometricCapability biometricCapability, bool isBiometricLoginEnabled, bool hasStoredCredential
});


$AuthSessionCopyWith<$Res>? get session;$PendingOtpVerificationCopyWith<$Res>? get pendingVerification;$BiometricCapabilityCopyWith<$Res> get biometricCapability;

}
/// @nodoc
class _$AuthStateCopyWithImpl<$Res>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._self, this._then);

  final AuthState _self;
  final $Res Function(AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? isBusy = null,Object? session = freezed,Object? pendingVerification = freezed,Object? biometricCapability = null,Object? isBiometricLoginEnabled = null,Object? hasStoredCredential = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AuthStatus,isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as AuthSession?,pendingVerification: freezed == pendingVerification ? _self.pendingVerification : pendingVerification // ignore: cast_nullable_to_non_nullable
as PendingOtpVerification?,biometricCapability: null == biometricCapability ? _self.biometricCapability : biometricCapability // ignore: cast_nullable_to_non_nullable
as BiometricCapability,isBiometricLoginEnabled: null == isBiometricLoginEnabled ? _self.isBiometricLoginEnabled : isBiometricLoginEnabled // ignore: cast_nullable_to_non_nullable
as bool,hasStoredCredential: null == hasStoredCredential ? _self.hasStoredCredential : hasStoredCredential // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthSessionCopyWith<$Res>? get session {
    if (_self.session == null) {
    return null;
  }

  return $AuthSessionCopyWith<$Res>(_self.session!, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PendingOtpVerificationCopyWith<$Res>? get pendingVerification {
    if (_self.pendingVerification == null) {
    return null;
  }

  return $PendingOtpVerificationCopyWith<$Res>(_self.pendingVerification!, (value) {
    return _then(_self.copyWith(pendingVerification: value));
  });
}/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BiometricCapabilityCopyWith<$Res> get biometricCapability {
  
  return $BiometricCapabilityCopyWith<$Res>(_self.biometricCapability, (value) {
    return _then(_self.copyWith(biometricCapability: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthState value)  $default,){
final _that = this;
switch (_that) {
case _AuthState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AuthStatus status,  bool isBusy,  AuthSession? session,  PendingOtpVerification? pendingVerification,  BiometricCapability biometricCapability,  bool isBiometricLoginEnabled,  bool hasStoredCredential)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.status,_that.isBusy,_that.session,_that.pendingVerification,_that.biometricCapability,_that.isBiometricLoginEnabled,_that.hasStoredCredential);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AuthStatus status,  bool isBusy,  AuthSession? session,  PendingOtpVerification? pendingVerification,  BiometricCapability biometricCapability,  bool isBiometricLoginEnabled,  bool hasStoredCredential)  $default,) {final _that = this;
switch (_that) {
case _AuthState():
return $default(_that.status,_that.isBusy,_that.session,_that.pendingVerification,_that.biometricCapability,_that.isBiometricLoginEnabled,_that.hasStoredCredential);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AuthStatus status,  bool isBusy,  AuthSession? session,  PendingOtpVerification? pendingVerification,  BiometricCapability biometricCapability,  bool isBiometricLoginEnabled,  bool hasStoredCredential)?  $default,) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.status,_that.isBusy,_that.session,_that.pendingVerification,_that.biometricCapability,_that.isBiometricLoginEnabled,_that.hasStoredCredential);case _:
  return null;

}
}

}

/// @nodoc


class _AuthState extends AuthState {
  const _AuthState({this.status = AuthStatus.initializing, this.isBusy = false, this.session, this.pendingVerification, this.biometricCapability = const BiometricCapability(), this.isBiometricLoginEnabled = false, this.hasStoredCredential = false}): super._();
  

@override@JsonKey() final  AuthStatus status;
@override@JsonKey() final  bool isBusy;
@override final  AuthSession? session;
@override final  PendingOtpVerification? pendingVerification;
@override@JsonKey() final  BiometricCapability biometricCapability;
@override@JsonKey() final  bool isBiometricLoginEnabled;
@override@JsonKey() final  bool hasStoredCredential;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthStateCopyWith<_AuthState> get copyWith => __$AuthStateCopyWithImpl<_AuthState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthState&&(identical(other.status, status) || other.status == status)&&(identical(other.isBusy, isBusy) || other.isBusy == isBusy)&&(identical(other.session, session) || other.session == session)&&(identical(other.pendingVerification, pendingVerification) || other.pendingVerification == pendingVerification)&&(identical(other.biometricCapability, biometricCapability) || other.biometricCapability == biometricCapability)&&(identical(other.isBiometricLoginEnabled, isBiometricLoginEnabled) || other.isBiometricLoginEnabled == isBiometricLoginEnabled)&&(identical(other.hasStoredCredential, hasStoredCredential) || other.hasStoredCredential == hasStoredCredential));
}


@override
int get hashCode => Object.hash(runtimeType,status,isBusy,session,pendingVerification,biometricCapability,isBiometricLoginEnabled,hasStoredCredential);

@override
String toString() {
  return 'AuthState(status: $status, isBusy: $isBusy, session: $session, pendingVerification: $pendingVerification, biometricCapability: $biometricCapability, isBiometricLoginEnabled: $isBiometricLoginEnabled, hasStoredCredential: $hasStoredCredential)';
}


}

/// @nodoc
abstract mixin class _$AuthStateCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthStateCopyWith(_AuthState value, $Res Function(_AuthState) _then) = __$AuthStateCopyWithImpl;
@override @useResult
$Res call({
 AuthStatus status, bool isBusy, AuthSession? session, PendingOtpVerification? pendingVerification, BiometricCapability biometricCapability, bool isBiometricLoginEnabled, bool hasStoredCredential
});


@override $AuthSessionCopyWith<$Res>? get session;@override $PendingOtpVerificationCopyWith<$Res>? get pendingVerification;@override $BiometricCapabilityCopyWith<$Res> get biometricCapability;

}
/// @nodoc
class __$AuthStateCopyWithImpl<$Res>
    implements _$AuthStateCopyWith<$Res> {
  __$AuthStateCopyWithImpl(this._self, this._then);

  final _AuthState _self;
  final $Res Function(_AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? isBusy = null,Object? session = freezed,Object? pendingVerification = freezed,Object? biometricCapability = null,Object? isBiometricLoginEnabled = null,Object? hasStoredCredential = null,}) {
  return _then(_AuthState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AuthStatus,isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as AuthSession?,pendingVerification: freezed == pendingVerification ? _self.pendingVerification : pendingVerification // ignore: cast_nullable_to_non_nullable
as PendingOtpVerification?,biometricCapability: null == biometricCapability ? _self.biometricCapability : biometricCapability // ignore: cast_nullable_to_non_nullable
as BiometricCapability,isBiometricLoginEnabled: null == isBiometricLoginEnabled ? _self.isBiometricLoginEnabled : isBiometricLoginEnabled // ignore: cast_nullable_to_non_nullable
as bool,hasStoredCredential: null == hasStoredCredential ? _self.hasStoredCredential : hasStoredCredential // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthSessionCopyWith<$Res>? get session {
    if (_self.session == null) {
    return null;
  }

  return $AuthSessionCopyWith<$Res>(_self.session!, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PendingOtpVerificationCopyWith<$Res>? get pendingVerification {
    if (_self.pendingVerification == null) {
    return null;
  }

  return $PendingOtpVerificationCopyWith<$Res>(_self.pendingVerification!, (value) {
    return _then(_self.copyWith(pendingVerification: value));
  });
}/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BiometricCapabilityCopyWith<$Res> get biometricCapability {
  
  return $BiometricCapabilityCopyWith<$Res>(_self.biometricCapability, (value) {
    return _then(_self.copyWith(biometricCapability: value));
  });
}
}

// dart format on
