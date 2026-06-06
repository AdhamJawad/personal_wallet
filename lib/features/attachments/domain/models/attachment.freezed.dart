// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attachment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Attachment {

 String get id; String get ownerUserId; AttachmentReference get reference; AttachmentKind get kind; String get fileName; String get localUri; String? get mimeType; int? get byteSize; String? get checksum;@DateTimeConverter() DateTime get createdAt;@DateTimeConverter() DateTime get updatedAt;
/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttachmentCopyWith<Attachment> get copyWith => _$AttachmentCopyWithImpl<Attachment>(this as Attachment, _$identity);

  /// Serializes this Attachment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Attachment&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.localUri, localUri) || other.localUri == localUri)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.byteSize, byteSize) || other.byteSize == byteSize)&&(identical(other.checksum, checksum) || other.checksum == checksum)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUserId,reference,kind,fileName,localUri,mimeType,byteSize,checksum,createdAt,updatedAt);

@override
String toString() {
  return 'Attachment(id: $id, ownerUserId: $ownerUserId, reference: $reference, kind: $kind, fileName: $fileName, localUri: $localUri, mimeType: $mimeType, byteSize: $byteSize, checksum: $checksum, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AttachmentCopyWith<$Res>  {
  factory $AttachmentCopyWith(Attachment value, $Res Function(Attachment) _then) = _$AttachmentCopyWithImpl;
@useResult
$Res call({
 String id, String ownerUserId, AttachmentReference reference, AttachmentKind kind, String fileName, String localUri, String? mimeType, int? byteSize, String? checksum,@DateTimeConverter() DateTime createdAt,@DateTimeConverter() DateTime updatedAt
});


$AttachmentReferenceCopyWith<$Res> get reference;

}
/// @nodoc
class _$AttachmentCopyWithImpl<$Res>
    implements $AttachmentCopyWith<$Res> {
  _$AttachmentCopyWithImpl(this._self, this._then);

  final Attachment _self;
  final $Res Function(Attachment) _then;

/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerUserId = null,Object? reference = null,Object? kind = null,Object? fileName = null,Object? localUri = null,Object? mimeType = freezed,Object? byteSize = freezed,Object? checksum = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as AttachmentReference,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as AttachmentKind,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,localUri: null == localUri ? _self.localUri : localUri // ignore: cast_nullable_to_non_nullable
as String,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,byteSize: freezed == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int?,checksum: freezed == checksum ? _self.checksum : checksum // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttachmentReferenceCopyWith<$Res> get reference {
  
  return $AttachmentReferenceCopyWith<$Res>(_self.reference, (value) {
    return _then(_self.copyWith(reference: value));
  });
}
}


/// Adds pattern-matching-related methods to [Attachment].
extension AttachmentPatterns on Attachment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Attachment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Attachment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Attachment value)  $default,){
final _that = this;
switch (_that) {
case _Attachment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Attachment value)?  $default,){
final _that = this;
switch (_that) {
case _Attachment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerUserId,  AttachmentReference reference,  AttachmentKind kind,  String fileName,  String localUri,  String? mimeType,  int? byteSize,  String? checksum, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Attachment() when $default != null:
return $default(_that.id,_that.ownerUserId,_that.reference,_that.kind,_that.fileName,_that.localUri,_that.mimeType,_that.byteSize,_that.checksum,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerUserId,  AttachmentReference reference,  AttachmentKind kind,  String fileName,  String localUri,  String? mimeType,  int? byteSize,  String? checksum, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Attachment():
return $default(_that.id,_that.ownerUserId,_that.reference,_that.kind,_that.fileName,_that.localUri,_that.mimeType,_that.byteSize,_that.checksum,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerUserId,  AttachmentReference reference,  AttachmentKind kind,  String fileName,  String localUri,  String? mimeType,  int? byteSize,  String? checksum, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Attachment() when $default != null:
return $default(_that.id,_that.ownerUserId,_that.reference,_that.kind,_that.fileName,_that.localUri,_that.mimeType,_that.byteSize,_that.checksum,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Attachment implements Attachment {
  const _Attachment({required this.id, required this.ownerUserId, required this.reference, required this.kind, required this.fileName, required this.localUri, this.mimeType, this.byteSize, this.checksum, @DateTimeConverter() required this.createdAt, @DateTimeConverter() required this.updatedAt});
  factory _Attachment.fromJson(Map<String, dynamic> json) => _$AttachmentFromJson(json);

@override final  String id;
@override final  String ownerUserId;
@override final  AttachmentReference reference;
@override final  AttachmentKind kind;
@override final  String fileName;
@override final  String localUri;
@override final  String? mimeType;
@override final  int? byteSize;
@override final  String? checksum;
@override@DateTimeConverter() final  DateTime createdAt;
@override@DateTimeConverter() final  DateTime updatedAt;

/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttachmentCopyWith<_Attachment> get copyWith => __$AttachmentCopyWithImpl<_Attachment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttachmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Attachment&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.localUri, localUri) || other.localUri == localUri)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.byteSize, byteSize) || other.byteSize == byteSize)&&(identical(other.checksum, checksum) || other.checksum == checksum)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUserId,reference,kind,fileName,localUri,mimeType,byteSize,checksum,createdAt,updatedAt);

@override
String toString() {
  return 'Attachment(id: $id, ownerUserId: $ownerUserId, reference: $reference, kind: $kind, fileName: $fileName, localUri: $localUri, mimeType: $mimeType, byteSize: $byteSize, checksum: $checksum, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AttachmentCopyWith<$Res> implements $AttachmentCopyWith<$Res> {
  factory _$AttachmentCopyWith(_Attachment value, $Res Function(_Attachment) _then) = __$AttachmentCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerUserId, AttachmentReference reference, AttachmentKind kind, String fileName, String localUri, String? mimeType, int? byteSize, String? checksum,@DateTimeConverter() DateTime createdAt,@DateTimeConverter() DateTime updatedAt
});


@override $AttachmentReferenceCopyWith<$Res> get reference;

}
/// @nodoc
class __$AttachmentCopyWithImpl<$Res>
    implements _$AttachmentCopyWith<$Res> {
  __$AttachmentCopyWithImpl(this._self, this._then);

  final _Attachment _self;
  final $Res Function(_Attachment) _then;

/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerUserId = null,Object? reference = null,Object? kind = null,Object? fileName = null,Object? localUri = null,Object? mimeType = freezed,Object? byteSize = freezed,Object? checksum = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Attachment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as AttachmentReference,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as AttachmentKind,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,localUri: null == localUri ? _self.localUri : localUri // ignore: cast_nullable_to_non_nullable
as String,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,byteSize: freezed == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int?,checksum: freezed == checksum ? _self.checksum : checksum // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttachmentReferenceCopyWith<$Res> get reference {
  
  return $AttachmentReferenceCopyWith<$Res>(_self.reference, (value) {
    return _then(_self.copyWith(reference: value));
  });
}
}

// dart format on
