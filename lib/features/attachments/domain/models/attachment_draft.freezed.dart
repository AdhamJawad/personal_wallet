// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attachment_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttachmentDraft {

 AttachmentKind get kind; String get fileName; String get localUri; String? get mimeType; int? get byteSize;
/// Create a copy of AttachmentDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttachmentDraftCopyWith<AttachmentDraft> get copyWith => _$AttachmentDraftCopyWithImpl<AttachmentDraft>(this as AttachmentDraft, _$identity);

  /// Serializes this AttachmentDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttachmentDraft&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.localUri, localUri) || other.localUri == localUri)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.byteSize, byteSize) || other.byteSize == byteSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,fileName,localUri,mimeType,byteSize);

@override
String toString() {
  return 'AttachmentDraft(kind: $kind, fileName: $fileName, localUri: $localUri, mimeType: $mimeType, byteSize: $byteSize)';
}


}

/// @nodoc
abstract mixin class $AttachmentDraftCopyWith<$Res>  {
  factory $AttachmentDraftCopyWith(AttachmentDraft value, $Res Function(AttachmentDraft) _then) = _$AttachmentDraftCopyWithImpl;
@useResult
$Res call({
 AttachmentKind kind, String fileName, String localUri, String? mimeType, int? byteSize
});




}
/// @nodoc
class _$AttachmentDraftCopyWithImpl<$Res>
    implements $AttachmentDraftCopyWith<$Res> {
  _$AttachmentDraftCopyWithImpl(this._self, this._then);

  final AttachmentDraft _self;
  final $Res Function(AttachmentDraft) _then;

/// Create a copy of AttachmentDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? fileName = null,Object? localUri = null,Object? mimeType = freezed,Object? byteSize = freezed,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as AttachmentKind,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,localUri: null == localUri ? _self.localUri : localUri // ignore: cast_nullable_to_non_nullable
as String,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,byteSize: freezed == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttachmentDraft].
extension AttachmentDraftPatterns on AttachmentDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttachmentDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttachmentDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttachmentDraft value)  $default,){
final _that = this;
switch (_that) {
case _AttachmentDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttachmentDraft value)?  $default,){
final _that = this;
switch (_that) {
case _AttachmentDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AttachmentKind kind,  String fileName,  String localUri,  String? mimeType,  int? byteSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttachmentDraft() when $default != null:
return $default(_that.kind,_that.fileName,_that.localUri,_that.mimeType,_that.byteSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AttachmentKind kind,  String fileName,  String localUri,  String? mimeType,  int? byteSize)  $default,) {final _that = this;
switch (_that) {
case _AttachmentDraft():
return $default(_that.kind,_that.fileName,_that.localUri,_that.mimeType,_that.byteSize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AttachmentKind kind,  String fileName,  String localUri,  String? mimeType,  int? byteSize)?  $default,) {final _that = this;
switch (_that) {
case _AttachmentDraft() when $default != null:
return $default(_that.kind,_that.fileName,_that.localUri,_that.mimeType,_that.byteSize);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttachmentDraft implements AttachmentDraft {
  const _AttachmentDraft({required this.kind, required this.fileName, required this.localUri, this.mimeType, this.byteSize});
  factory _AttachmentDraft.fromJson(Map<String, dynamic> json) => _$AttachmentDraftFromJson(json);

@override final  AttachmentKind kind;
@override final  String fileName;
@override final  String localUri;
@override final  String? mimeType;
@override final  int? byteSize;

/// Create a copy of AttachmentDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttachmentDraftCopyWith<_AttachmentDraft> get copyWith => __$AttachmentDraftCopyWithImpl<_AttachmentDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttachmentDraftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttachmentDraft&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.localUri, localUri) || other.localUri == localUri)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.byteSize, byteSize) || other.byteSize == byteSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,fileName,localUri,mimeType,byteSize);

@override
String toString() {
  return 'AttachmentDraft(kind: $kind, fileName: $fileName, localUri: $localUri, mimeType: $mimeType, byteSize: $byteSize)';
}


}

/// @nodoc
abstract mixin class _$AttachmentDraftCopyWith<$Res> implements $AttachmentDraftCopyWith<$Res> {
  factory _$AttachmentDraftCopyWith(_AttachmentDraft value, $Res Function(_AttachmentDraft) _then) = __$AttachmentDraftCopyWithImpl;
@override @useResult
$Res call({
 AttachmentKind kind, String fileName, String localUri, String? mimeType, int? byteSize
});




}
/// @nodoc
class __$AttachmentDraftCopyWithImpl<$Res>
    implements _$AttachmentDraftCopyWith<$Res> {
  __$AttachmentDraftCopyWithImpl(this._self, this._then);

  final _AttachmentDraft _self;
  final $Res Function(_AttachmentDraft) _then;

/// Create a copy of AttachmentDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? fileName = null,Object? localUri = null,Object? mimeType = freezed,Object? byteSize = freezed,}) {
  return _then(_AttachmentDraft(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as AttachmentKind,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,localUri: null == localUri ? _self.localUri : localUri // ignore: cast_nullable_to_non_nullable
as String,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,byteSize: freezed == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
