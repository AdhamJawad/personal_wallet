// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'future_link_candidate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FutureLinkCandidate {

 String get externalContactId; String? get matchingRegisteredUserId; bool get ownerApprovalRequired; bool get contactApprovalRequired;@DateTimeConverter() DateTime get detectedAt;
/// Create a copy of FutureLinkCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FutureLinkCandidateCopyWith<FutureLinkCandidate> get copyWith => _$FutureLinkCandidateCopyWithImpl<FutureLinkCandidate>(this as FutureLinkCandidate, _$identity);

  /// Serializes this FutureLinkCandidate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FutureLinkCandidate&&(identical(other.externalContactId, externalContactId) || other.externalContactId == externalContactId)&&(identical(other.matchingRegisteredUserId, matchingRegisteredUserId) || other.matchingRegisteredUserId == matchingRegisteredUserId)&&(identical(other.ownerApprovalRequired, ownerApprovalRequired) || other.ownerApprovalRequired == ownerApprovalRequired)&&(identical(other.contactApprovalRequired, contactApprovalRequired) || other.contactApprovalRequired == contactApprovalRequired)&&(identical(other.detectedAt, detectedAt) || other.detectedAt == detectedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,externalContactId,matchingRegisteredUserId,ownerApprovalRequired,contactApprovalRequired,detectedAt);

@override
String toString() {
  return 'FutureLinkCandidate(externalContactId: $externalContactId, matchingRegisteredUserId: $matchingRegisteredUserId, ownerApprovalRequired: $ownerApprovalRequired, contactApprovalRequired: $contactApprovalRequired, detectedAt: $detectedAt)';
}


}

/// @nodoc
abstract mixin class $FutureLinkCandidateCopyWith<$Res>  {
  factory $FutureLinkCandidateCopyWith(FutureLinkCandidate value, $Res Function(FutureLinkCandidate) _then) = _$FutureLinkCandidateCopyWithImpl;
@useResult
$Res call({
 String externalContactId, String? matchingRegisteredUserId, bool ownerApprovalRequired, bool contactApprovalRequired,@DateTimeConverter() DateTime detectedAt
});




}
/// @nodoc
class _$FutureLinkCandidateCopyWithImpl<$Res>
    implements $FutureLinkCandidateCopyWith<$Res> {
  _$FutureLinkCandidateCopyWithImpl(this._self, this._then);

  final FutureLinkCandidate _self;
  final $Res Function(FutureLinkCandidate) _then;

/// Create a copy of FutureLinkCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? externalContactId = null,Object? matchingRegisteredUserId = freezed,Object? ownerApprovalRequired = null,Object? contactApprovalRequired = null,Object? detectedAt = null,}) {
  return _then(_self.copyWith(
externalContactId: null == externalContactId ? _self.externalContactId : externalContactId // ignore: cast_nullable_to_non_nullable
as String,matchingRegisteredUserId: freezed == matchingRegisteredUserId ? _self.matchingRegisteredUserId : matchingRegisteredUserId // ignore: cast_nullable_to_non_nullable
as String?,ownerApprovalRequired: null == ownerApprovalRequired ? _self.ownerApprovalRequired : ownerApprovalRequired // ignore: cast_nullable_to_non_nullable
as bool,contactApprovalRequired: null == contactApprovalRequired ? _self.contactApprovalRequired : contactApprovalRequired // ignore: cast_nullable_to_non_nullable
as bool,detectedAt: null == detectedAt ? _self.detectedAt : detectedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FutureLinkCandidate].
extension FutureLinkCandidatePatterns on FutureLinkCandidate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FutureLinkCandidate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FutureLinkCandidate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FutureLinkCandidate value)  $default,){
final _that = this;
switch (_that) {
case _FutureLinkCandidate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FutureLinkCandidate value)?  $default,){
final _that = this;
switch (_that) {
case _FutureLinkCandidate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String externalContactId,  String? matchingRegisteredUserId,  bool ownerApprovalRequired,  bool contactApprovalRequired, @DateTimeConverter()  DateTime detectedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FutureLinkCandidate() when $default != null:
return $default(_that.externalContactId,_that.matchingRegisteredUserId,_that.ownerApprovalRequired,_that.contactApprovalRequired,_that.detectedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String externalContactId,  String? matchingRegisteredUserId,  bool ownerApprovalRequired,  bool contactApprovalRequired, @DateTimeConverter()  DateTime detectedAt)  $default,) {final _that = this;
switch (_that) {
case _FutureLinkCandidate():
return $default(_that.externalContactId,_that.matchingRegisteredUserId,_that.ownerApprovalRequired,_that.contactApprovalRequired,_that.detectedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String externalContactId,  String? matchingRegisteredUserId,  bool ownerApprovalRequired,  bool contactApprovalRequired, @DateTimeConverter()  DateTime detectedAt)?  $default,) {final _that = this;
switch (_that) {
case _FutureLinkCandidate() when $default != null:
return $default(_that.externalContactId,_that.matchingRegisteredUserId,_that.ownerApprovalRequired,_that.contactApprovalRequired,_that.detectedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FutureLinkCandidate implements FutureLinkCandidate {
  const _FutureLinkCandidate({required this.externalContactId, this.matchingRegisteredUserId, required this.ownerApprovalRequired, required this.contactApprovalRequired, @DateTimeConverter() required this.detectedAt});
  factory _FutureLinkCandidate.fromJson(Map<String, dynamic> json) => _$FutureLinkCandidateFromJson(json);

@override final  String externalContactId;
@override final  String? matchingRegisteredUserId;
@override final  bool ownerApprovalRequired;
@override final  bool contactApprovalRequired;
@override@DateTimeConverter() final  DateTime detectedAt;

/// Create a copy of FutureLinkCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FutureLinkCandidateCopyWith<_FutureLinkCandidate> get copyWith => __$FutureLinkCandidateCopyWithImpl<_FutureLinkCandidate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FutureLinkCandidateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FutureLinkCandidate&&(identical(other.externalContactId, externalContactId) || other.externalContactId == externalContactId)&&(identical(other.matchingRegisteredUserId, matchingRegisteredUserId) || other.matchingRegisteredUserId == matchingRegisteredUserId)&&(identical(other.ownerApprovalRequired, ownerApprovalRequired) || other.ownerApprovalRequired == ownerApprovalRequired)&&(identical(other.contactApprovalRequired, contactApprovalRequired) || other.contactApprovalRequired == contactApprovalRequired)&&(identical(other.detectedAt, detectedAt) || other.detectedAt == detectedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,externalContactId,matchingRegisteredUserId,ownerApprovalRequired,contactApprovalRequired,detectedAt);

@override
String toString() {
  return 'FutureLinkCandidate(externalContactId: $externalContactId, matchingRegisteredUserId: $matchingRegisteredUserId, ownerApprovalRequired: $ownerApprovalRequired, contactApprovalRequired: $contactApprovalRequired, detectedAt: $detectedAt)';
}


}

/// @nodoc
abstract mixin class _$FutureLinkCandidateCopyWith<$Res> implements $FutureLinkCandidateCopyWith<$Res> {
  factory _$FutureLinkCandidateCopyWith(_FutureLinkCandidate value, $Res Function(_FutureLinkCandidate) _then) = __$FutureLinkCandidateCopyWithImpl;
@override @useResult
$Res call({
 String externalContactId, String? matchingRegisteredUserId, bool ownerApprovalRequired, bool contactApprovalRequired,@DateTimeConverter() DateTime detectedAt
});




}
/// @nodoc
class __$FutureLinkCandidateCopyWithImpl<$Res>
    implements _$FutureLinkCandidateCopyWith<$Res> {
  __$FutureLinkCandidateCopyWithImpl(this._self, this._then);

  final _FutureLinkCandidate _self;
  final $Res Function(_FutureLinkCandidate) _then;

/// Create a copy of FutureLinkCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? externalContactId = null,Object? matchingRegisteredUserId = freezed,Object? ownerApprovalRequired = null,Object? contactApprovalRequired = null,Object? detectedAt = null,}) {
  return _then(_FutureLinkCandidate(
externalContactId: null == externalContactId ? _self.externalContactId : externalContactId // ignore: cast_nullable_to_non_nullable
as String,matchingRegisteredUserId: freezed == matchingRegisteredUserId ? _self.matchingRegisteredUserId : matchingRegisteredUserId // ignore: cast_nullable_to_non_nullable
as String?,ownerApprovalRequired: null == ownerApprovalRequired ? _self.ownerApprovalRequired : ownerApprovalRequired // ignore: cast_nullable_to_non_nullable
as bool,contactApprovalRequired: null == contactApprovalRequired ? _self.contactApprovalRequired : contactApprovalRequired // ignore: cast_nullable_to_non_nullable
as bool,detectedAt: null == detectedAt ? _self.detectedAt : detectedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
