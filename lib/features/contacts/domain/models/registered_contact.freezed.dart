// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registered_contact.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegisteredContact {

 String get id; String get ownerUserId; String get linkedUserId; String get name; String? get phoneNumber; String? get note;@DateTimeConverter() DateTime get createdAt;@DateTimeConverter() DateTime get updatedAt;
/// Create a copy of RegisteredContact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisteredContactCopyWith<RegisteredContact> get copyWith => _$RegisteredContactCopyWithImpl<RegisteredContact>(this as RegisteredContact, _$identity);

  /// Serializes this RegisteredContact to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisteredContact&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.linkedUserId, linkedUserId) || other.linkedUserId == linkedUserId)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUserId,linkedUserId,name,phoneNumber,note,createdAt,updatedAt);

@override
String toString() {
  return 'RegisteredContact(id: $id, ownerUserId: $ownerUserId, linkedUserId: $linkedUserId, name: $name, phoneNumber: $phoneNumber, note: $note, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $RegisteredContactCopyWith<$Res>  {
  factory $RegisteredContactCopyWith(RegisteredContact value, $Res Function(RegisteredContact) _then) = _$RegisteredContactCopyWithImpl;
@useResult
$Res call({
 String id, String ownerUserId, String linkedUserId, String name, String? phoneNumber, String? note,@DateTimeConverter() DateTime createdAt,@DateTimeConverter() DateTime updatedAt
});




}
/// @nodoc
class _$RegisteredContactCopyWithImpl<$Res>
    implements $RegisteredContactCopyWith<$Res> {
  _$RegisteredContactCopyWithImpl(this._self, this._then);

  final RegisteredContact _self;
  final $Res Function(RegisteredContact) _then;

/// Create a copy of RegisteredContact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerUserId = null,Object? linkedUserId = null,Object? name = null,Object? phoneNumber = freezed,Object? note = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,linkedUserId: null == linkedUserId ? _self.linkedUserId : linkedUserId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RegisteredContact].
extension RegisteredContactPatterns on RegisteredContact {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisteredContact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisteredContact() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisteredContact value)  $default,){
final _that = this;
switch (_that) {
case _RegisteredContact():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisteredContact value)?  $default,){
final _that = this;
switch (_that) {
case _RegisteredContact() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerUserId,  String linkedUserId,  String name,  String? phoneNumber,  String? note, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisteredContact() when $default != null:
return $default(_that.id,_that.ownerUserId,_that.linkedUserId,_that.name,_that.phoneNumber,_that.note,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerUserId,  String linkedUserId,  String name,  String? phoneNumber,  String? note, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _RegisteredContact():
return $default(_that.id,_that.ownerUserId,_that.linkedUserId,_that.name,_that.phoneNumber,_that.note,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerUserId,  String linkedUserId,  String name,  String? phoneNumber,  String? note, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _RegisteredContact() when $default != null:
return $default(_that.id,_that.ownerUserId,_that.linkedUserId,_that.name,_that.phoneNumber,_that.note,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegisteredContact implements RegisteredContact {
  const _RegisteredContact({required this.id, required this.ownerUserId, required this.linkedUserId, required this.name, this.phoneNumber, this.note, @DateTimeConverter() required this.createdAt, @DateTimeConverter() required this.updatedAt});
  factory _RegisteredContact.fromJson(Map<String, dynamic> json) => _$RegisteredContactFromJson(json);

@override final  String id;
@override final  String ownerUserId;
@override final  String linkedUserId;
@override final  String name;
@override final  String? phoneNumber;
@override final  String? note;
@override@DateTimeConverter() final  DateTime createdAt;
@override@DateTimeConverter() final  DateTime updatedAt;

/// Create a copy of RegisteredContact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisteredContactCopyWith<_RegisteredContact> get copyWith => __$RegisteredContactCopyWithImpl<_RegisteredContact>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegisteredContactToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisteredContact&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.linkedUserId, linkedUserId) || other.linkedUserId == linkedUserId)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUserId,linkedUserId,name,phoneNumber,note,createdAt,updatedAt);

@override
String toString() {
  return 'RegisteredContact(id: $id, ownerUserId: $ownerUserId, linkedUserId: $linkedUserId, name: $name, phoneNumber: $phoneNumber, note: $note, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RegisteredContactCopyWith<$Res> implements $RegisteredContactCopyWith<$Res> {
  factory _$RegisteredContactCopyWith(_RegisteredContact value, $Res Function(_RegisteredContact) _then) = __$RegisteredContactCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerUserId, String linkedUserId, String name, String? phoneNumber, String? note,@DateTimeConverter() DateTime createdAt,@DateTimeConverter() DateTime updatedAt
});




}
/// @nodoc
class __$RegisteredContactCopyWithImpl<$Res>
    implements _$RegisteredContactCopyWith<$Res> {
  __$RegisteredContactCopyWithImpl(this._self, this._then);

  final _RegisteredContact _self;
  final $Res Function(_RegisteredContact) _then;

/// Create a copy of RegisteredContact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerUserId = null,Object? linkedUserId = null,Object? name = null,Object? phoneNumber = freezed,Object? note = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_RegisteredContact(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,linkedUserId: null == linkedUserId ? _self.linkedUserId : linkedUserId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
