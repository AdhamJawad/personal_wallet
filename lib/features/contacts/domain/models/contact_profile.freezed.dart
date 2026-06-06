// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContactProfile {

 String get id; String get ownerUserId; ContactKind get kind; String get displayName; String? get linkedUserId; String? get phoneNumber; String? get qrToken; bool get dualApprovalRequired;@DateTimeConverter() DateTime get createdAt;@DateTimeConverter() DateTime get updatedAt;
/// Create a copy of ContactProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactProfileCopyWith<ContactProfile> get copyWith => _$ContactProfileCopyWithImpl<ContactProfile>(this as ContactProfile, _$identity);

  /// Serializes this ContactProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.linkedUserId, linkedUserId) || other.linkedUserId == linkedUserId)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.qrToken, qrToken) || other.qrToken == qrToken)&&(identical(other.dualApprovalRequired, dualApprovalRequired) || other.dualApprovalRequired == dualApprovalRequired)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUserId,kind,displayName,linkedUserId,phoneNumber,qrToken,dualApprovalRequired,createdAt,updatedAt);

@override
String toString() {
  return 'ContactProfile(id: $id, ownerUserId: $ownerUserId, kind: $kind, displayName: $displayName, linkedUserId: $linkedUserId, phoneNumber: $phoneNumber, qrToken: $qrToken, dualApprovalRequired: $dualApprovalRequired, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ContactProfileCopyWith<$Res>  {
  factory $ContactProfileCopyWith(ContactProfile value, $Res Function(ContactProfile) _then) = _$ContactProfileCopyWithImpl;
@useResult
$Res call({
 String id, String ownerUserId, ContactKind kind, String displayName, String? linkedUserId, String? phoneNumber, String? qrToken, bool dualApprovalRequired,@DateTimeConverter() DateTime createdAt,@DateTimeConverter() DateTime updatedAt
});




}
/// @nodoc
class _$ContactProfileCopyWithImpl<$Res>
    implements $ContactProfileCopyWith<$Res> {
  _$ContactProfileCopyWithImpl(this._self, this._then);

  final ContactProfile _self;
  final $Res Function(ContactProfile) _then;

/// Create a copy of ContactProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerUserId = null,Object? kind = null,Object? displayName = null,Object? linkedUserId = freezed,Object? phoneNumber = freezed,Object? qrToken = freezed,Object? dualApprovalRequired = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ContactKind,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,linkedUserId: freezed == linkedUserId ? _self.linkedUserId : linkedUserId // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,qrToken: freezed == qrToken ? _self.qrToken : qrToken // ignore: cast_nullable_to_non_nullable
as String?,dualApprovalRequired: null == dualApprovalRequired ? _self.dualApprovalRequired : dualApprovalRequired // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactProfile].
extension ContactProfilePatterns on ContactProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactProfile value)  $default,){
final _that = this;
switch (_that) {
case _ContactProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactProfile value)?  $default,){
final _that = this;
switch (_that) {
case _ContactProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerUserId,  ContactKind kind,  String displayName,  String? linkedUserId,  String? phoneNumber,  String? qrToken,  bool dualApprovalRequired, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactProfile() when $default != null:
return $default(_that.id,_that.ownerUserId,_that.kind,_that.displayName,_that.linkedUserId,_that.phoneNumber,_that.qrToken,_that.dualApprovalRequired,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerUserId,  ContactKind kind,  String displayName,  String? linkedUserId,  String? phoneNumber,  String? qrToken,  bool dualApprovalRequired, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ContactProfile():
return $default(_that.id,_that.ownerUserId,_that.kind,_that.displayName,_that.linkedUserId,_that.phoneNumber,_that.qrToken,_that.dualApprovalRequired,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerUserId,  ContactKind kind,  String displayName,  String? linkedUserId,  String? phoneNumber,  String? qrToken,  bool dualApprovalRequired, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ContactProfile() when $default != null:
return $default(_that.id,_that.ownerUserId,_that.kind,_that.displayName,_that.linkedUserId,_that.phoneNumber,_that.qrToken,_that.dualApprovalRequired,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContactProfile implements ContactProfile {
  const _ContactProfile({required this.id, required this.ownerUserId, required this.kind, required this.displayName, this.linkedUserId, this.phoneNumber, this.qrToken, required this.dualApprovalRequired, @DateTimeConverter() required this.createdAt, @DateTimeConverter() required this.updatedAt});
  factory _ContactProfile.fromJson(Map<String, dynamic> json) => _$ContactProfileFromJson(json);

@override final  String id;
@override final  String ownerUserId;
@override final  ContactKind kind;
@override final  String displayName;
@override final  String? linkedUserId;
@override final  String? phoneNumber;
@override final  String? qrToken;
@override final  bool dualApprovalRequired;
@override@DateTimeConverter() final  DateTime createdAt;
@override@DateTimeConverter() final  DateTime updatedAt;

/// Create a copy of ContactProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactProfileCopyWith<_ContactProfile> get copyWith => __$ContactProfileCopyWithImpl<_ContactProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.linkedUserId, linkedUserId) || other.linkedUserId == linkedUserId)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.qrToken, qrToken) || other.qrToken == qrToken)&&(identical(other.dualApprovalRequired, dualApprovalRequired) || other.dualApprovalRequired == dualApprovalRequired)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUserId,kind,displayName,linkedUserId,phoneNumber,qrToken,dualApprovalRequired,createdAt,updatedAt);

@override
String toString() {
  return 'ContactProfile(id: $id, ownerUserId: $ownerUserId, kind: $kind, displayName: $displayName, linkedUserId: $linkedUserId, phoneNumber: $phoneNumber, qrToken: $qrToken, dualApprovalRequired: $dualApprovalRequired, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ContactProfileCopyWith<$Res> implements $ContactProfileCopyWith<$Res> {
  factory _$ContactProfileCopyWith(_ContactProfile value, $Res Function(_ContactProfile) _then) = __$ContactProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerUserId, ContactKind kind, String displayName, String? linkedUserId, String? phoneNumber, String? qrToken, bool dualApprovalRequired,@DateTimeConverter() DateTime createdAt,@DateTimeConverter() DateTime updatedAt
});




}
/// @nodoc
class __$ContactProfileCopyWithImpl<$Res>
    implements _$ContactProfileCopyWith<$Res> {
  __$ContactProfileCopyWithImpl(this._self, this._then);

  final _ContactProfile _self;
  final $Res Function(_ContactProfile) _then;

/// Create a copy of ContactProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerUserId = null,Object? kind = null,Object? displayName = null,Object? linkedUserId = freezed,Object? phoneNumber = freezed,Object? qrToken = freezed,Object? dualApprovalRequired = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ContactProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ContactKind,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,linkedUserId: freezed == linkedUserId ? _self.linkedUserId : linkedUserId // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,qrToken: freezed == qrToken ? _self.qrToken : qrToken // ignore: cast_nullable_to_non_nullable
as String?,dualApprovalRequired: null == dualApprovalRequired ? _self.dualApprovalRequired : dualApprovalRequired // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
