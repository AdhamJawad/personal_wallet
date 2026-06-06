// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuditEvent {

 String get id; String get ownerUserId; AuditEventType get type; String get entityId; String get relatedEntityType; String? get deviceIdentifier; SyncOperationStatus get syncStatus; Map<String, dynamic> get metadata;@DateTimeConverter() DateTime get createdAt;
/// Create a copy of AuditEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditEventCopyWith<AuditEvent> get copyWith => _$AuditEventCopyWithImpl<AuditEvent>(this as AuditEvent, _$identity);

  /// Serializes this AuditEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.type, type) || other.type == type)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.relatedEntityType, relatedEntityType) || other.relatedEntityType == relatedEntityType)&&(identical(other.deviceIdentifier, deviceIdentifier) || other.deviceIdentifier == deviceIdentifier)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUserId,type,entityId,relatedEntityType,deviceIdentifier,syncStatus,const DeepCollectionEquality().hash(metadata),createdAt);

@override
String toString() {
  return 'AuditEvent(id: $id, ownerUserId: $ownerUserId, type: $type, entityId: $entityId, relatedEntityType: $relatedEntityType, deviceIdentifier: $deviceIdentifier, syncStatus: $syncStatus, metadata: $metadata, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AuditEventCopyWith<$Res>  {
  factory $AuditEventCopyWith(AuditEvent value, $Res Function(AuditEvent) _then) = _$AuditEventCopyWithImpl;
@useResult
$Res call({
 String id, String ownerUserId, AuditEventType type, String entityId, String relatedEntityType, String? deviceIdentifier, SyncOperationStatus syncStatus, Map<String, dynamic> metadata,@DateTimeConverter() DateTime createdAt
});




}
/// @nodoc
class _$AuditEventCopyWithImpl<$Res>
    implements $AuditEventCopyWith<$Res> {
  _$AuditEventCopyWithImpl(this._self, this._then);

  final AuditEvent _self;
  final $Res Function(AuditEvent) _then;

/// Create a copy of AuditEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerUserId = null,Object? type = null,Object? entityId = null,Object? relatedEntityType = null,Object? deviceIdentifier = freezed,Object? syncStatus = null,Object? metadata = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AuditEventType,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,relatedEntityType: null == relatedEntityType ? _self.relatedEntityType : relatedEntityType // ignore: cast_nullable_to_non_nullable
as String,deviceIdentifier: freezed == deviceIdentifier ? _self.deviceIdentifier : deviceIdentifier // ignore: cast_nullable_to_non_nullable
as String?,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncOperationStatus,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditEvent].
extension AuditEventPatterns on AuditEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditEvent value)  $default,){
final _that = this;
switch (_that) {
case _AuditEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditEvent value)?  $default,){
final _that = this;
switch (_that) {
case _AuditEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerUserId,  AuditEventType type,  String entityId,  String relatedEntityType,  String? deviceIdentifier,  SyncOperationStatus syncStatus,  Map<String, dynamic> metadata, @DateTimeConverter()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditEvent() when $default != null:
return $default(_that.id,_that.ownerUserId,_that.type,_that.entityId,_that.relatedEntityType,_that.deviceIdentifier,_that.syncStatus,_that.metadata,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerUserId,  AuditEventType type,  String entityId,  String relatedEntityType,  String? deviceIdentifier,  SyncOperationStatus syncStatus,  Map<String, dynamic> metadata, @DateTimeConverter()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AuditEvent():
return $default(_that.id,_that.ownerUserId,_that.type,_that.entityId,_that.relatedEntityType,_that.deviceIdentifier,_that.syncStatus,_that.metadata,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerUserId,  AuditEventType type,  String entityId,  String relatedEntityType,  String? deviceIdentifier,  SyncOperationStatus syncStatus,  Map<String, dynamic> metadata, @DateTimeConverter()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AuditEvent() when $default != null:
return $default(_that.id,_that.ownerUserId,_that.type,_that.entityId,_that.relatedEntityType,_that.deviceIdentifier,_that.syncStatus,_that.metadata,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditEvent implements AuditEvent {
  const _AuditEvent({required this.id, required this.ownerUserId, required this.type, required this.entityId, required this.relatedEntityType, this.deviceIdentifier, this.syncStatus = SyncOperationStatus.pending, final  Map<String, dynamic> metadata = const <String, dynamic>{}, @DateTimeConverter() required this.createdAt}): _metadata = metadata;
  factory _AuditEvent.fromJson(Map<String, dynamic> json) => _$AuditEventFromJson(json);

@override final  String id;
@override final  String ownerUserId;
@override final  AuditEventType type;
@override final  String entityId;
@override final  String relatedEntityType;
@override final  String? deviceIdentifier;
@override@JsonKey() final  SyncOperationStatus syncStatus;
 final  Map<String, dynamic> _metadata;
@override@JsonKey() Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}

@override@DateTimeConverter() final  DateTime createdAt;

/// Create a copy of AuditEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditEventCopyWith<_AuditEvent> get copyWith => __$AuditEventCopyWithImpl<_AuditEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.type, type) || other.type == type)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.relatedEntityType, relatedEntityType) || other.relatedEntityType == relatedEntityType)&&(identical(other.deviceIdentifier, deviceIdentifier) || other.deviceIdentifier == deviceIdentifier)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUserId,type,entityId,relatedEntityType,deviceIdentifier,syncStatus,const DeepCollectionEquality().hash(_metadata),createdAt);

@override
String toString() {
  return 'AuditEvent(id: $id, ownerUserId: $ownerUserId, type: $type, entityId: $entityId, relatedEntityType: $relatedEntityType, deviceIdentifier: $deviceIdentifier, syncStatus: $syncStatus, metadata: $metadata, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AuditEventCopyWith<$Res> implements $AuditEventCopyWith<$Res> {
  factory _$AuditEventCopyWith(_AuditEvent value, $Res Function(_AuditEvent) _then) = __$AuditEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerUserId, AuditEventType type, String entityId, String relatedEntityType, String? deviceIdentifier, SyncOperationStatus syncStatus, Map<String, dynamic> metadata,@DateTimeConverter() DateTime createdAt
});




}
/// @nodoc
class __$AuditEventCopyWithImpl<$Res>
    implements _$AuditEventCopyWith<$Res> {
  __$AuditEventCopyWithImpl(this._self, this._then);

  final _AuditEvent _self;
  final $Res Function(_AuditEvent) _then;

/// Create a copy of AuditEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerUserId = null,Object? type = null,Object? entityId = null,Object? relatedEntityType = null,Object? deviceIdentifier = freezed,Object? syncStatus = null,Object? metadata = null,Object? createdAt = null,}) {
  return _then(_AuditEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AuditEventType,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,relatedEntityType: null == relatedEntityType ? _self.relatedEntityType : relatedEntityType // ignore: cast_nullable_to_non_nullable
as String,deviceIdentifier: freezed == deviceIdentifier ? _self.deviceIdentifier : deviceIdentifier // ignore: cast_nullable_to_non_nullable
as String?,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncOperationStatus,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
