// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Contact {

 String get id; String get ownerUserId; ContactKind get kind; String get name; String? get phoneNumber; String? get note; String? get linkedUserId; FutureLinkCandidate? get futureLinkCandidate;@DateTimeConverter() DateTime get createdAt;@DateTimeConverter() DateTime get updatedAt;
/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactCopyWith<Contact> get copyWith => _$ContactCopyWithImpl<Contact>(this as Contact, _$identity);

  /// Serializes this Contact to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Contact&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.note, note) || other.note == note)&&(identical(other.linkedUserId, linkedUserId) || other.linkedUserId == linkedUserId)&&(identical(other.futureLinkCandidate, futureLinkCandidate) || other.futureLinkCandidate == futureLinkCandidate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUserId,kind,name,phoneNumber,note,linkedUserId,futureLinkCandidate,createdAt,updatedAt);

@override
String toString() {
  return 'Contact(id: $id, ownerUserId: $ownerUserId, kind: $kind, name: $name, phoneNumber: $phoneNumber, note: $note, linkedUserId: $linkedUserId, futureLinkCandidate: $futureLinkCandidate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ContactCopyWith<$Res>  {
  factory $ContactCopyWith(Contact value, $Res Function(Contact) _then) = _$ContactCopyWithImpl;
@useResult
$Res call({
 String id, String ownerUserId, ContactKind kind, String name, String? phoneNumber, String? note, String? linkedUserId, FutureLinkCandidate? futureLinkCandidate,@DateTimeConverter() DateTime createdAt,@DateTimeConverter() DateTime updatedAt
});


$FutureLinkCandidateCopyWith<$Res>? get futureLinkCandidate;

}
/// @nodoc
class _$ContactCopyWithImpl<$Res>
    implements $ContactCopyWith<$Res> {
  _$ContactCopyWithImpl(this._self, this._then);

  final Contact _self;
  final $Res Function(Contact) _then;

/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerUserId = null,Object? kind = null,Object? name = null,Object? phoneNumber = freezed,Object? note = freezed,Object? linkedUserId = freezed,Object? futureLinkCandidate = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ContactKind,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,linkedUserId: freezed == linkedUserId ? _self.linkedUserId : linkedUserId // ignore: cast_nullable_to_non_nullable
as String?,futureLinkCandidate: freezed == futureLinkCandidate ? _self.futureLinkCandidate : futureLinkCandidate // ignore: cast_nullable_to_non_nullable
as FutureLinkCandidate?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FutureLinkCandidateCopyWith<$Res>? get futureLinkCandidate {
    if (_self.futureLinkCandidate == null) {
    return null;
  }

  return $FutureLinkCandidateCopyWith<$Res>(_self.futureLinkCandidate!, (value) {
    return _then(_self.copyWith(futureLinkCandidate: value));
  });
}
}


/// Adds pattern-matching-related methods to [Contact].
extension ContactPatterns on Contact {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Contact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Contact() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Contact value)  $default,){
final _that = this;
switch (_that) {
case _Contact():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Contact value)?  $default,){
final _that = this;
switch (_that) {
case _Contact() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerUserId,  ContactKind kind,  String name,  String? phoneNumber,  String? note,  String? linkedUserId,  FutureLinkCandidate? futureLinkCandidate, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Contact() when $default != null:
return $default(_that.id,_that.ownerUserId,_that.kind,_that.name,_that.phoneNumber,_that.note,_that.linkedUserId,_that.futureLinkCandidate,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerUserId,  ContactKind kind,  String name,  String? phoneNumber,  String? note,  String? linkedUserId,  FutureLinkCandidate? futureLinkCandidate, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Contact():
return $default(_that.id,_that.ownerUserId,_that.kind,_that.name,_that.phoneNumber,_that.note,_that.linkedUserId,_that.futureLinkCandidate,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerUserId,  ContactKind kind,  String name,  String? phoneNumber,  String? note,  String? linkedUserId,  FutureLinkCandidate? futureLinkCandidate, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Contact() when $default != null:
return $default(_that.id,_that.ownerUserId,_that.kind,_that.name,_that.phoneNumber,_that.note,_that.linkedUserId,_that.futureLinkCandidate,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Contact implements Contact {
  const _Contact({required this.id, required this.ownerUserId, required this.kind, required this.name, this.phoneNumber, this.note, this.linkedUserId, this.futureLinkCandidate, @DateTimeConverter() required this.createdAt, @DateTimeConverter() required this.updatedAt});
  factory _Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);

@override final  String id;
@override final  String ownerUserId;
@override final  ContactKind kind;
@override final  String name;
@override final  String? phoneNumber;
@override final  String? note;
@override final  String? linkedUserId;
@override final  FutureLinkCandidate? futureLinkCandidate;
@override@DateTimeConverter() final  DateTime createdAt;
@override@DateTimeConverter() final  DateTime updatedAt;

/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactCopyWith<_Contact> get copyWith => __$ContactCopyWithImpl<_Contact>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Contact&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.note, note) || other.note == note)&&(identical(other.linkedUserId, linkedUserId) || other.linkedUserId == linkedUserId)&&(identical(other.futureLinkCandidate, futureLinkCandidate) || other.futureLinkCandidate == futureLinkCandidate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUserId,kind,name,phoneNumber,note,linkedUserId,futureLinkCandidate,createdAt,updatedAt);

@override
String toString() {
  return 'Contact(id: $id, ownerUserId: $ownerUserId, kind: $kind, name: $name, phoneNumber: $phoneNumber, note: $note, linkedUserId: $linkedUserId, futureLinkCandidate: $futureLinkCandidate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ContactCopyWith<$Res> implements $ContactCopyWith<$Res> {
  factory _$ContactCopyWith(_Contact value, $Res Function(_Contact) _then) = __$ContactCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerUserId, ContactKind kind, String name, String? phoneNumber, String? note, String? linkedUserId, FutureLinkCandidate? futureLinkCandidate,@DateTimeConverter() DateTime createdAt,@DateTimeConverter() DateTime updatedAt
});


@override $FutureLinkCandidateCopyWith<$Res>? get futureLinkCandidate;

}
/// @nodoc
class __$ContactCopyWithImpl<$Res>
    implements _$ContactCopyWith<$Res> {
  __$ContactCopyWithImpl(this._self, this._then);

  final _Contact _self;
  final $Res Function(_Contact) _then;

/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerUserId = null,Object? kind = null,Object? name = null,Object? phoneNumber = freezed,Object? note = freezed,Object? linkedUserId = freezed,Object? futureLinkCandidate = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Contact(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ContactKind,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,linkedUserId: freezed == linkedUserId ? _self.linkedUserId : linkedUserId // ignore: cast_nullable_to_non_nullable
as String?,futureLinkCandidate: freezed == futureLinkCandidate ? _self.futureLinkCandidate : futureLinkCandidate // ignore: cast_nullable_to_non_nullable
as FutureLinkCandidate?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FutureLinkCandidateCopyWith<$Res>? get futureLinkCandidate {
    if (_self.futureLinkCandidate == null) {
    return null;
  }

  return $FutureLinkCandidateCopyWith<$Res>(_self.futureLinkCandidate!, (value) {
    return _then(_self.copyWith(futureLinkCandidate: value));
  });
}
}

// dart format on
