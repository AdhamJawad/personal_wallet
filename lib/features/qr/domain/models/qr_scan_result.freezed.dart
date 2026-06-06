// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qr_scan_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QrScanResult {

 QrIdentity get identity; bool get isSelf; bool get isKnownContact; String? get existingContactId;
/// Create a copy of QrScanResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QrScanResultCopyWith<QrScanResult> get copyWith => _$QrScanResultCopyWithImpl<QrScanResult>(this as QrScanResult, _$identity);

  /// Serializes this QrScanResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QrScanResult&&(identical(other.identity, identity) || other.identity == identity)&&(identical(other.isSelf, isSelf) || other.isSelf == isSelf)&&(identical(other.isKnownContact, isKnownContact) || other.isKnownContact == isKnownContact)&&(identical(other.existingContactId, existingContactId) || other.existingContactId == existingContactId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,identity,isSelf,isKnownContact,existingContactId);

@override
String toString() {
  return 'QrScanResult(identity: $identity, isSelf: $isSelf, isKnownContact: $isKnownContact, existingContactId: $existingContactId)';
}


}

/// @nodoc
abstract mixin class $QrScanResultCopyWith<$Res>  {
  factory $QrScanResultCopyWith(QrScanResult value, $Res Function(QrScanResult) _then) = _$QrScanResultCopyWithImpl;
@useResult
$Res call({
 QrIdentity identity, bool isSelf, bool isKnownContact, String? existingContactId
});


$QrIdentityCopyWith<$Res> get identity;

}
/// @nodoc
class _$QrScanResultCopyWithImpl<$Res>
    implements $QrScanResultCopyWith<$Res> {
  _$QrScanResultCopyWithImpl(this._self, this._then);

  final QrScanResult _self;
  final $Res Function(QrScanResult) _then;

/// Create a copy of QrScanResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? identity = null,Object? isSelf = null,Object? isKnownContact = null,Object? existingContactId = freezed,}) {
  return _then(_self.copyWith(
identity: null == identity ? _self.identity : identity // ignore: cast_nullable_to_non_nullable
as QrIdentity,isSelf: null == isSelf ? _self.isSelf : isSelf // ignore: cast_nullable_to_non_nullable
as bool,isKnownContact: null == isKnownContact ? _self.isKnownContact : isKnownContact // ignore: cast_nullable_to_non_nullable
as bool,existingContactId: freezed == existingContactId ? _self.existingContactId : existingContactId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of QrScanResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QrIdentityCopyWith<$Res> get identity {
  
  return $QrIdentityCopyWith<$Res>(_self.identity, (value) {
    return _then(_self.copyWith(identity: value));
  });
}
}


/// Adds pattern-matching-related methods to [QrScanResult].
extension QrScanResultPatterns on QrScanResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QrScanResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QrScanResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QrScanResult value)  $default,){
final _that = this;
switch (_that) {
case _QrScanResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QrScanResult value)?  $default,){
final _that = this;
switch (_that) {
case _QrScanResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( QrIdentity identity,  bool isSelf,  bool isKnownContact,  String? existingContactId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QrScanResult() when $default != null:
return $default(_that.identity,_that.isSelf,_that.isKnownContact,_that.existingContactId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( QrIdentity identity,  bool isSelf,  bool isKnownContact,  String? existingContactId)  $default,) {final _that = this;
switch (_that) {
case _QrScanResult():
return $default(_that.identity,_that.isSelf,_that.isKnownContact,_that.existingContactId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( QrIdentity identity,  bool isSelf,  bool isKnownContact,  String? existingContactId)?  $default,) {final _that = this;
switch (_that) {
case _QrScanResult() when $default != null:
return $default(_that.identity,_that.isSelf,_that.isKnownContact,_that.existingContactId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QrScanResult implements QrScanResult {
  const _QrScanResult({required this.identity, required this.isSelf, required this.isKnownContact, this.existingContactId});
  factory _QrScanResult.fromJson(Map<String, dynamic> json) => _$QrScanResultFromJson(json);

@override final  QrIdentity identity;
@override final  bool isSelf;
@override final  bool isKnownContact;
@override final  String? existingContactId;

/// Create a copy of QrScanResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QrScanResultCopyWith<_QrScanResult> get copyWith => __$QrScanResultCopyWithImpl<_QrScanResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QrScanResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QrScanResult&&(identical(other.identity, identity) || other.identity == identity)&&(identical(other.isSelf, isSelf) || other.isSelf == isSelf)&&(identical(other.isKnownContact, isKnownContact) || other.isKnownContact == isKnownContact)&&(identical(other.existingContactId, existingContactId) || other.existingContactId == existingContactId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,identity,isSelf,isKnownContact,existingContactId);

@override
String toString() {
  return 'QrScanResult(identity: $identity, isSelf: $isSelf, isKnownContact: $isKnownContact, existingContactId: $existingContactId)';
}


}

/// @nodoc
abstract mixin class _$QrScanResultCopyWith<$Res> implements $QrScanResultCopyWith<$Res> {
  factory _$QrScanResultCopyWith(_QrScanResult value, $Res Function(_QrScanResult) _then) = __$QrScanResultCopyWithImpl;
@override @useResult
$Res call({
 QrIdentity identity, bool isSelf, bool isKnownContact, String? existingContactId
});


@override $QrIdentityCopyWith<$Res> get identity;

}
/// @nodoc
class __$QrScanResultCopyWithImpl<$Res>
    implements _$QrScanResultCopyWith<$Res> {
  __$QrScanResultCopyWithImpl(this._self, this._then);

  final _QrScanResult _self;
  final $Res Function(_QrScanResult) _then;

/// Create a copy of QrScanResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? identity = null,Object? isSelf = null,Object? isKnownContact = null,Object? existingContactId = freezed,}) {
  return _then(_QrScanResult(
identity: null == identity ? _self.identity : identity // ignore: cast_nullable_to_non_nullable
as QrIdentity,isSelf: null == isSelf ? _self.isSelf : isSelf // ignore: cast_nullable_to_non_nullable
as bool,isKnownContact: null == isKnownContact ? _self.isKnownContact : isKnownContact // ignore: cast_nullable_to_non_nullable
as bool,existingContactId: freezed == existingContactId ? _self.existingContactId : existingContactId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of QrScanResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QrIdentityCopyWith<$Res> get identity {
  
  return $QrIdentityCopyWith<$Res>(_self.identity, (value) {
    return _then(_self.copyWith(identity: value));
  });
}
}

// dart format on
