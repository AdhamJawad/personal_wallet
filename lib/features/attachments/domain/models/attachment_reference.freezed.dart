// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attachment_reference.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttachmentReference {

 AttachmentReferenceType get type; String get entityId; String? get label;
/// Create a copy of AttachmentReference
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttachmentReferenceCopyWith<AttachmentReference> get copyWith => _$AttachmentReferenceCopyWithImpl<AttachmentReference>(this as AttachmentReference, _$identity);

  /// Serializes this AttachmentReference to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttachmentReference&&(identical(other.type, type) || other.type == type)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,entityId,label);

@override
String toString() {
  return 'AttachmentReference(type: $type, entityId: $entityId, label: $label)';
}


}

/// @nodoc
abstract mixin class $AttachmentReferenceCopyWith<$Res>  {
  factory $AttachmentReferenceCopyWith(AttachmentReference value, $Res Function(AttachmentReference) _then) = _$AttachmentReferenceCopyWithImpl;
@useResult
$Res call({
 AttachmentReferenceType type, String entityId, String? label
});




}
/// @nodoc
class _$AttachmentReferenceCopyWithImpl<$Res>
    implements $AttachmentReferenceCopyWith<$Res> {
  _$AttachmentReferenceCopyWithImpl(this._self, this._then);

  final AttachmentReference _self;
  final $Res Function(AttachmentReference) _then;

/// Create a copy of AttachmentReference
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? entityId = null,Object? label = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AttachmentReferenceType,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttachmentReference].
extension AttachmentReferencePatterns on AttachmentReference {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttachmentReference value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttachmentReference() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttachmentReference value)  $default,){
final _that = this;
switch (_that) {
case _AttachmentReference():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttachmentReference value)?  $default,){
final _that = this;
switch (_that) {
case _AttachmentReference() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AttachmentReferenceType type,  String entityId,  String? label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttachmentReference() when $default != null:
return $default(_that.type,_that.entityId,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AttachmentReferenceType type,  String entityId,  String? label)  $default,) {final _that = this;
switch (_that) {
case _AttachmentReference():
return $default(_that.type,_that.entityId,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AttachmentReferenceType type,  String entityId,  String? label)?  $default,) {final _that = this;
switch (_that) {
case _AttachmentReference() when $default != null:
return $default(_that.type,_that.entityId,_that.label);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttachmentReference implements AttachmentReference {
  const _AttachmentReference({required this.type, required this.entityId, this.label});
  factory _AttachmentReference.fromJson(Map<String, dynamic> json) => _$AttachmentReferenceFromJson(json);

@override final  AttachmentReferenceType type;
@override final  String entityId;
@override final  String? label;

/// Create a copy of AttachmentReference
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttachmentReferenceCopyWith<_AttachmentReference> get copyWith => __$AttachmentReferenceCopyWithImpl<_AttachmentReference>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttachmentReferenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttachmentReference&&(identical(other.type, type) || other.type == type)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,entityId,label);

@override
String toString() {
  return 'AttachmentReference(type: $type, entityId: $entityId, label: $label)';
}


}

/// @nodoc
abstract mixin class _$AttachmentReferenceCopyWith<$Res> implements $AttachmentReferenceCopyWith<$Res> {
  factory _$AttachmentReferenceCopyWith(_AttachmentReference value, $Res Function(_AttachmentReference) _then) = __$AttachmentReferenceCopyWithImpl;
@override @useResult
$Res call({
 AttachmentReferenceType type, String entityId, String? label
});




}
/// @nodoc
class __$AttachmentReferenceCopyWithImpl<$Res>
    implements _$AttachmentReferenceCopyWith<$Res> {
  __$AttachmentReferenceCopyWithImpl(this._self, this._then);

  final _AttachmentReference _self;
  final $Res Function(_AttachmentReference) _then;

/// Create a copy of AttachmentReference
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? entityId = null,Object? label = freezed,}) {
  return _then(_AttachmentReference(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AttachmentReferenceType,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
