// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conflict_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConflictRecord {

 String get id; String get operationId; String get entityId; ConflictResolutionStrategy get recommendedStrategy; Map<String, dynamic> get localPayload; Map<String, dynamic>? get remotePayload; String? get summary;@DateTimeConverter() DateTime get createdAt;@DateTimeConverter() DateTime get updatedAt;
/// Create a copy of ConflictRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConflictRecordCopyWith<ConflictRecord> get copyWith => _$ConflictRecordCopyWithImpl<ConflictRecord>(this as ConflictRecord, _$identity);

  /// Serializes this ConflictRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConflictRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.recommendedStrategy, recommendedStrategy) || other.recommendedStrategy == recommendedStrategy)&&const DeepCollectionEquality().equals(other.localPayload, localPayload)&&const DeepCollectionEquality().equals(other.remotePayload, remotePayload)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,operationId,entityId,recommendedStrategy,const DeepCollectionEquality().hash(localPayload),const DeepCollectionEquality().hash(remotePayload),summary,createdAt,updatedAt);

@override
String toString() {
  return 'ConflictRecord(id: $id, operationId: $operationId, entityId: $entityId, recommendedStrategy: $recommendedStrategy, localPayload: $localPayload, remotePayload: $remotePayload, summary: $summary, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ConflictRecordCopyWith<$Res>  {
  factory $ConflictRecordCopyWith(ConflictRecord value, $Res Function(ConflictRecord) _then) = _$ConflictRecordCopyWithImpl;
@useResult
$Res call({
 String id, String operationId, String entityId, ConflictResolutionStrategy recommendedStrategy, Map<String, dynamic> localPayload, Map<String, dynamic>? remotePayload, String? summary,@DateTimeConverter() DateTime createdAt,@DateTimeConverter() DateTime updatedAt
});




}
/// @nodoc
class _$ConflictRecordCopyWithImpl<$Res>
    implements $ConflictRecordCopyWith<$Res> {
  _$ConflictRecordCopyWithImpl(this._self, this._then);

  final ConflictRecord _self;
  final $Res Function(ConflictRecord) _then;

/// Create a copy of ConflictRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? operationId = null,Object? entityId = null,Object? recommendedStrategy = null,Object? localPayload = null,Object? remotePayload = freezed,Object? summary = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,operationId: null == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,recommendedStrategy: null == recommendedStrategy ? _self.recommendedStrategy : recommendedStrategy // ignore: cast_nullable_to_non_nullable
as ConflictResolutionStrategy,localPayload: null == localPayload ? _self.localPayload : localPayload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,remotePayload: freezed == remotePayload ? _self.remotePayload : remotePayload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ConflictRecord].
extension ConflictRecordPatterns on ConflictRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConflictRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConflictRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConflictRecord value)  $default,){
final _that = this;
switch (_that) {
case _ConflictRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConflictRecord value)?  $default,){
final _that = this;
switch (_that) {
case _ConflictRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String operationId,  String entityId,  ConflictResolutionStrategy recommendedStrategy,  Map<String, dynamic> localPayload,  Map<String, dynamic>? remotePayload,  String? summary, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConflictRecord() when $default != null:
return $default(_that.id,_that.operationId,_that.entityId,_that.recommendedStrategy,_that.localPayload,_that.remotePayload,_that.summary,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String operationId,  String entityId,  ConflictResolutionStrategy recommendedStrategy,  Map<String, dynamic> localPayload,  Map<String, dynamic>? remotePayload,  String? summary, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ConflictRecord():
return $default(_that.id,_that.operationId,_that.entityId,_that.recommendedStrategy,_that.localPayload,_that.remotePayload,_that.summary,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String operationId,  String entityId,  ConflictResolutionStrategy recommendedStrategy,  Map<String, dynamic> localPayload,  Map<String, dynamic>? remotePayload,  String? summary, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ConflictRecord() when $default != null:
return $default(_that.id,_that.operationId,_that.entityId,_that.recommendedStrategy,_that.localPayload,_that.remotePayload,_that.summary,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConflictRecord implements ConflictRecord {
  const _ConflictRecord({required this.id, required this.operationId, required this.entityId, required this.recommendedStrategy, required final  Map<String, dynamic> localPayload, final  Map<String, dynamic>? remotePayload, this.summary, @DateTimeConverter() required this.createdAt, @DateTimeConverter() required this.updatedAt}): _localPayload = localPayload,_remotePayload = remotePayload;
  factory _ConflictRecord.fromJson(Map<String, dynamic> json) => _$ConflictRecordFromJson(json);

@override final  String id;
@override final  String operationId;
@override final  String entityId;
@override final  ConflictResolutionStrategy recommendedStrategy;
 final  Map<String, dynamic> _localPayload;
@override Map<String, dynamic> get localPayload {
  if (_localPayload is EqualUnmodifiableMapView) return _localPayload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_localPayload);
}

 final  Map<String, dynamic>? _remotePayload;
@override Map<String, dynamic>? get remotePayload {
  final value = _remotePayload;
  if (value == null) return null;
  if (_remotePayload is EqualUnmodifiableMapView) return _remotePayload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? summary;
@override@DateTimeConverter() final  DateTime createdAt;
@override@DateTimeConverter() final  DateTime updatedAt;

/// Create a copy of ConflictRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConflictRecordCopyWith<_ConflictRecord> get copyWith => __$ConflictRecordCopyWithImpl<_ConflictRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConflictRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConflictRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.recommendedStrategy, recommendedStrategy) || other.recommendedStrategy == recommendedStrategy)&&const DeepCollectionEquality().equals(other._localPayload, _localPayload)&&const DeepCollectionEquality().equals(other._remotePayload, _remotePayload)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,operationId,entityId,recommendedStrategy,const DeepCollectionEquality().hash(_localPayload),const DeepCollectionEquality().hash(_remotePayload),summary,createdAt,updatedAt);

@override
String toString() {
  return 'ConflictRecord(id: $id, operationId: $operationId, entityId: $entityId, recommendedStrategy: $recommendedStrategy, localPayload: $localPayload, remotePayload: $remotePayload, summary: $summary, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ConflictRecordCopyWith<$Res> implements $ConflictRecordCopyWith<$Res> {
  factory _$ConflictRecordCopyWith(_ConflictRecord value, $Res Function(_ConflictRecord) _then) = __$ConflictRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String operationId, String entityId, ConflictResolutionStrategy recommendedStrategy, Map<String, dynamic> localPayload, Map<String, dynamic>? remotePayload, String? summary,@DateTimeConverter() DateTime createdAt,@DateTimeConverter() DateTime updatedAt
});




}
/// @nodoc
class __$ConflictRecordCopyWithImpl<$Res>
    implements _$ConflictRecordCopyWith<$Res> {
  __$ConflictRecordCopyWithImpl(this._self, this._then);

  final _ConflictRecord _self;
  final $Res Function(_ConflictRecord) _then;

/// Create a copy of ConflictRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? operationId = null,Object? entityId = null,Object? recommendedStrategy = null,Object? localPayload = null,Object? remotePayload = freezed,Object? summary = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ConflictRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,operationId: null == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,recommendedStrategy: null == recommendedStrategy ? _self.recommendedStrategy : recommendedStrategy // ignore: cast_nullable_to_non_nullable
as ConflictResolutionStrategy,localPayload: null == localPayload ? _self._localPayload : localPayload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,remotePayload: freezed == remotePayload ? _self._remotePayload : remotePayload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
