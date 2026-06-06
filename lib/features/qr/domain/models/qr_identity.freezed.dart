// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qr_identity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QrIdentity {

 String get userId; String get displayName; String get publicReferenceIdentifier; String get payload;
/// Create a copy of QrIdentity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QrIdentityCopyWith<QrIdentity> get copyWith => _$QrIdentityCopyWithImpl<QrIdentity>(this as QrIdentity, _$identity);

  /// Serializes this QrIdentity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QrIdentity&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.publicReferenceIdentifier, publicReferenceIdentifier) || other.publicReferenceIdentifier == publicReferenceIdentifier)&&(identical(other.payload, payload) || other.payload == payload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,displayName,publicReferenceIdentifier,payload);

@override
String toString() {
  return 'QrIdentity(userId: $userId, displayName: $displayName, publicReferenceIdentifier: $publicReferenceIdentifier, payload: $payload)';
}


}

/// @nodoc
abstract mixin class $QrIdentityCopyWith<$Res>  {
  factory $QrIdentityCopyWith(QrIdentity value, $Res Function(QrIdentity) _then) = _$QrIdentityCopyWithImpl;
@useResult
$Res call({
 String userId, String displayName, String publicReferenceIdentifier, String payload
});




}
/// @nodoc
class _$QrIdentityCopyWithImpl<$Res>
    implements $QrIdentityCopyWith<$Res> {
  _$QrIdentityCopyWithImpl(this._self, this._then);

  final QrIdentity _self;
  final $Res Function(QrIdentity) _then;

/// Create a copy of QrIdentity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? displayName = null,Object? publicReferenceIdentifier = null,Object? payload = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,publicReferenceIdentifier: null == publicReferenceIdentifier ? _self.publicReferenceIdentifier : publicReferenceIdentifier // ignore: cast_nullable_to_non_nullable
as String,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [QrIdentity].
extension QrIdentityPatterns on QrIdentity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QrIdentity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QrIdentity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QrIdentity value)  $default,){
final _that = this;
switch (_that) {
case _QrIdentity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QrIdentity value)?  $default,){
final _that = this;
switch (_that) {
case _QrIdentity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String displayName,  String publicReferenceIdentifier,  String payload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QrIdentity() when $default != null:
return $default(_that.userId,_that.displayName,_that.publicReferenceIdentifier,_that.payload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String displayName,  String publicReferenceIdentifier,  String payload)  $default,) {final _that = this;
switch (_that) {
case _QrIdentity():
return $default(_that.userId,_that.displayName,_that.publicReferenceIdentifier,_that.payload);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String displayName,  String publicReferenceIdentifier,  String payload)?  $default,) {final _that = this;
switch (_that) {
case _QrIdentity() when $default != null:
return $default(_that.userId,_that.displayName,_that.publicReferenceIdentifier,_that.payload);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QrIdentity implements QrIdentity {
  const _QrIdentity({required this.userId, required this.displayName, required this.publicReferenceIdentifier, required this.payload});
  factory _QrIdentity.fromJson(Map<String, dynamic> json) => _$QrIdentityFromJson(json);

@override final  String userId;
@override final  String displayName;
@override final  String publicReferenceIdentifier;
@override final  String payload;

/// Create a copy of QrIdentity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QrIdentityCopyWith<_QrIdentity> get copyWith => __$QrIdentityCopyWithImpl<_QrIdentity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QrIdentityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QrIdentity&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.publicReferenceIdentifier, publicReferenceIdentifier) || other.publicReferenceIdentifier == publicReferenceIdentifier)&&(identical(other.payload, payload) || other.payload == payload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,displayName,publicReferenceIdentifier,payload);

@override
String toString() {
  return 'QrIdentity(userId: $userId, displayName: $displayName, publicReferenceIdentifier: $publicReferenceIdentifier, payload: $payload)';
}


}

/// @nodoc
abstract mixin class _$QrIdentityCopyWith<$Res> implements $QrIdentityCopyWith<$Res> {
  factory _$QrIdentityCopyWith(_QrIdentity value, $Res Function(_QrIdentity) _then) = __$QrIdentityCopyWithImpl;
@override @useResult
$Res call({
 String userId, String displayName, String publicReferenceIdentifier, String payload
});




}
/// @nodoc
class __$QrIdentityCopyWithImpl<$Res>
    implements _$QrIdentityCopyWith<$Res> {
  __$QrIdentityCopyWithImpl(this._self, this._then);

  final _QrIdentity _self;
  final $Res Function(_QrIdentity) _then;

/// Create a copy of QrIdentity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? displayName = null,Object? publicReferenceIdentifier = null,Object? payload = null,}) {
  return _then(_QrIdentity(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,publicReferenceIdentifier: null == publicReferenceIdentifier ? _self.publicReferenceIdentifier : publicReferenceIdentifier // ignore: cast_nullable_to_non_nullable
as String,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
