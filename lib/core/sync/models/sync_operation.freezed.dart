// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_operation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncOperation {

 String get id; String get ownerUserId; String get entityId; SyncOperationType get type; SyncOperationStatus get status; Map<String, dynamic> get payload; int get retryCount; String? get errorMessage; ConflictRecord? get conflictRecord;@DateTimeConverter() DateTime? get lastAttemptedAt;@DateTimeConverter() DateTime? get syncedAt;@DateTimeConverter() DateTime get createdAt;@DateTimeConverter() DateTime get updatedAt;
/// Create a copy of SyncOperation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncOperationCopyWith<SyncOperation> get copyWith => _$SyncOperationCopyWithImpl<SyncOperation>(this as SyncOperation, _$identity);

  /// Serializes this SyncOperation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncOperation&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.payload, payload)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.conflictRecord, conflictRecord) || other.conflictRecord == conflictRecord)&&(identical(other.lastAttemptedAt, lastAttemptedAt) || other.lastAttemptedAt == lastAttemptedAt)&&(identical(other.syncedAt, syncedAt) || other.syncedAt == syncedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUserId,entityId,type,status,const DeepCollectionEquality().hash(payload),retryCount,errorMessage,conflictRecord,lastAttemptedAt,syncedAt,createdAt,updatedAt);

@override
String toString() {
  return 'SyncOperation(id: $id, ownerUserId: $ownerUserId, entityId: $entityId, type: $type, status: $status, payload: $payload, retryCount: $retryCount, errorMessage: $errorMessage, conflictRecord: $conflictRecord, lastAttemptedAt: $lastAttemptedAt, syncedAt: $syncedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SyncOperationCopyWith<$Res>  {
  factory $SyncOperationCopyWith(SyncOperation value, $Res Function(SyncOperation) _then) = _$SyncOperationCopyWithImpl;
@useResult
$Res call({
 String id, String ownerUserId, String entityId, SyncOperationType type, SyncOperationStatus status, Map<String, dynamic> payload, int retryCount, String? errorMessage, ConflictRecord? conflictRecord,@DateTimeConverter() DateTime? lastAttemptedAt,@DateTimeConverter() DateTime? syncedAt,@DateTimeConverter() DateTime createdAt,@DateTimeConverter() DateTime updatedAt
});


$ConflictRecordCopyWith<$Res>? get conflictRecord;

}
/// @nodoc
class _$SyncOperationCopyWithImpl<$Res>
    implements $SyncOperationCopyWith<$Res> {
  _$SyncOperationCopyWithImpl(this._self, this._then);

  final SyncOperation _self;
  final $Res Function(SyncOperation) _then;

/// Create a copy of SyncOperation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerUserId = null,Object? entityId = null,Object? type = null,Object? status = null,Object? payload = null,Object? retryCount = null,Object? errorMessage = freezed,Object? conflictRecord = freezed,Object? lastAttemptedAt = freezed,Object? syncedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SyncOperationType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SyncOperationStatus,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,conflictRecord: freezed == conflictRecord ? _self.conflictRecord : conflictRecord // ignore: cast_nullable_to_non_nullable
as ConflictRecord?,lastAttemptedAt: freezed == lastAttemptedAt ? _self.lastAttemptedAt : lastAttemptedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncedAt: freezed == syncedAt ? _self.syncedAt : syncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of SyncOperation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConflictRecordCopyWith<$Res>? get conflictRecord {
    if (_self.conflictRecord == null) {
    return null;
  }

  return $ConflictRecordCopyWith<$Res>(_self.conflictRecord!, (value) {
    return _then(_self.copyWith(conflictRecord: value));
  });
}
}


/// Adds pattern-matching-related methods to [SyncOperation].
extension SyncOperationPatterns on SyncOperation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncOperation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncOperation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncOperation value)  $default,){
final _that = this;
switch (_that) {
case _SyncOperation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncOperation value)?  $default,){
final _that = this;
switch (_that) {
case _SyncOperation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerUserId,  String entityId,  SyncOperationType type,  SyncOperationStatus status,  Map<String, dynamic> payload,  int retryCount,  String? errorMessage,  ConflictRecord? conflictRecord, @DateTimeConverter()  DateTime? lastAttemptedAt, @DateTimeConverter()  DateTime? syncedAt, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncOperation() when $default != null:
return $default(_that.id,_that.ownerUserId,_that.entityId,_that.type,_that.status,_that.payload,_that.retryCount,_that.errorMessage,_that.conflictRecord,_that.lastAttemptedAt,_that.syncedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerUserId,  String entityId,  SyncOperationType type,  SyncOperationStatus status,  Map<String, dynamic> payload,  int retryCount,  String? errorMessage,  ConflictRecord? conflictRecord, @DateTimeConverter()  DateTime? lastAttemptedAt, @DateTimeConverter()  DateTime? syncedAt, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SyncOperation():
return $default(_that.id,_that.ownerUserId,_that.entityId,_that.type,_that.status,_that.payload,_that.retryCount,_that.errorMessage,_that.conflictRecord,_that.lastAttemptedAt,_that.syncedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerUserId,  String entityId,  SyncOperationType type,  SyncOperationStatus status,  Map<String, dynamic> payload,  int retryCount,  String? errorMessage,  ConflictRecord? conflictRecord, @DateTimeConverter()  DateTime? lastAttemptedAt, @DateTimeConverter()  DateTime? syncedAt, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SyncOperation() when $default != null:
return $default(_that.id,_that.ownerUserId,_that.entityId,_that.type,_that.status,_that.payload,_that.retryCount,_that.errorMessage,_that.conflictRecord,_that.lastAttemptedAt,_that.syncedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncOperation implements SyncOperation {
  const _SyncOperation({required this.id, required this.ownerUserId, required this.entityId, required this.type, required this.status, required final  Map<String, dynamic> payload, this.retryCount = 0, this.errorMessage, this.conflictRecord, @DateTimeConverter() this.lastAttemptedAt, @DateTimeConverter() this.syncedAt, @DateTimeConverter() required this.createdAt, @DateTimeConverter() required this.updatedAt}): _payload = payload;
  factory _SyncOperation.fromJson(Map<String, dynamic> json) => _$SyncOperationFromJson(json);

@override final  String id;
@override final  String ownerUserId;
@override final  String entityId;
@override final  SyncOperationType type;
@override final  SyncOperationStatus status;
 final  Map<String, dynamic> _payload;
@override Map<String, dynamic> get payload {
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_payload);
}

@override@JsonKey() final  int retryCount;
@override final  String? errorMessage;
@override final  ConflictRecord? conflictRecord;
@override@DateTimeConverter() final  DateTime? lastAttemptedAt;
@override@DateTimeConverter() final  DateTime? syncedAt;
@override@DateTimeConverter() final  DateTime createdAt;
@override@DateTimeConverter() final  DateTime updatedAt;

/// Create a copy of SyncOperation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncOperationCopyWith<_SyncOperation> get copyWith => __$SyncOperationCopyWithImpl<_SyncOperation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncOperationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncOperation&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._payload, _payload)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.conflictRecord, conflictRecord) || other.conflictRecord == conflictRecord)&&(identical(other.lastAttemptedAt, lastAttemptedAt) || other.lastAttemptedAt == lastAttemptedAt)&&(identical(other.syncedAt, syncedAt) || other.syncedAt == syncedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUserId,entityId,type,status,const DeepCollectionEquality().hash(_payload),retryCount,errorMessage,conflictRecord,lastAttemptedAt,syncedAt,createdAt,updatedAt);

@override
String toString() {
  return 'SyncOperation(id: $id, ownerUserId: $ownerUserId, entityId: $entityId, type: $type, status: $status, payload: $payload, retryCount: $retryCount, errorMessage: $errorMessage, conflictRecord: $conflictRecord, lastAttemptedAt: $lastAttemptedAt, syncedAt: $syncedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SyncOperationCopyWith<$Res> implements $SyncOperationCopyWith<$Res> {
  factory _$SyncOperationCopyWith(_SyncOperation value, $Res Function(_SyncOperation) _then) = __$SyncOperationCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerUserId, String entityId, SyncOperationType type, SyncOperationStatus status, Map<String, dynamic> payload, int retryCount, String? errorMessage, ConflictRecord? conflictRecord,@DateTimeConverter() DateTime? lastAttemptedAt,@DateTimeConverter() DateTime? syncedAt,@DateTimeConverter() DateTime createdAt,@DateTimeConverter() DateTime updatedAt
});


@override $ConflictRecordCopyWith<$Res>? get conflictRecord;

}
/// @nodoc
class __$SyncOperationCopyWithImpl<$Res>
    implements _$SyncOperationCopyWith<$Res> {
  __$SyncOperationCopyWithImpl(this._self, this._then);

  final _SyncOperation _self;
  final $Res Function(_SyncOperation) _then;

/// Create a copy of SyncOperation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerUserId = null,Object? entityId = null,Object? type = null,Object? status = null,Object? payload = null,Object? retryCount = null,Object? errorMessage = freezed,Object? conflictRecord = freezed,Object? lastAttemptedAt = freezed,Object? syncedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_SyncOperation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SyncOperationType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SyncOperationStatus,payload: null == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,conflictRecord: freezed == conflictRecord ? _self.conflictRecord : conflictRecord // ignore: cast_nullable_to_non_nullable
as ConflictRecord?,lastAttemptedAt: freezed == lastAttemptedAt ? _self.lastAttemptedAt : lastAttemptedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncedAt: freezed == syncedAt ? _self.syncedAt : syncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of SyncOperation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConflictRecordCopyWith<$Res>? get conflictRecord {
    if (_self.conflictRecord == null) {
    return null;
  }

  return $ConflictRecordCopyWith<$Res>(_self.conflictRecord!, (value) {
    return _then(_self.copyWith(conflictRecord: value));
  });
}
}

// dart format on
