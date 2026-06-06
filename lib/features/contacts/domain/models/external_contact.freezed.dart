// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'external_contact.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExternalContact {

 String get id; String get ownerUserId; String get name; String? get phoneNumber; String? get note; FutureLinkCandidate? get futureLinkCandidate;@DateTimeConverter() DateTime get createdAt;@DateTimeConverter() DateTime get updatedAt;
/// Create a copy of ExternalContact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExternalContactCopyWith<ExternalContact> get copyWith => _$ExternalContactCopyWithImpl<ExternalContact>(this as ExternalContact, _$identity);

  /// Serializes this ExternalContact to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExternalContact&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.note, note) || other.note == note)&&(identical(other.futureLinkCandidate, futureLinkCandidate) || other.futureLinkCandidate == futureLinkCandidate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUserId,name,phoneNumber,note,futureLinkCandidate,createdAt,updatedAt);

@override
String toString() {
  return 'ExternalContact(id: $id, ownerUserId: $ownerUserId, name: $name, phoneNumber: $phoneNumber, note: $note, futureLinkCandidate: $futureLinkCandidate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ExternalContactCopyWith<$Res>  {
  factory $ExternalContactCopyWith(ExternalContact value, $Res Function(ExternalContact) _then) = _$ExternalContactCopyWithImpl;
@useResult
$Res call({
 String id, String ownerUserId, String name, String? phoneNumber, String? note, FutureLinkCandidate? futureLinkCandidate,@DateTimeConverter() DateTime createdAt,@DateTimeConverter() DateTime updatedAt
});


$FutureLinkCandidateCopyWith<$Res>? get futureLinkCandidate;

}
/// @nodoc
class _$ExternalContactCopyWithImpl<$Res>
    implements $ExternalContactCopyWith<$Res> {
  _$ExternalContactCopyWithImpl(this._self, this._then);

  final ExternalContact _self;
  final $Res Function(ExternalContact) _then;

/// Create a copy of ExternalContact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerUserId = null,Object? name = null,Object? phoneNumber = freezed,Object? note = freezed,Object? futureLinkCandidate = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,futureLinkCandidate: freezed == futureLinkCandidate ? _self.futureLinkCandidate : futureLinkCandidate // ignore: cast_nullable_to_non_nullable
as FutureLinkCandidate?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of ExternalContact
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


/// Adds pattern-matching-related methods to [ExternalContact].
extension ExternalContactPatterns on ExternalContact {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExternalContact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExternalContact() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExternalContact value)  $default,){
final _that = this;
switch (_that) {
case _ExternalContact():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExternalContact value)?  $default,){
final _that = this;
switch (_that) {
case _ExternalContact() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerUserId,  String name,  String? phoneNumber,  String? note,  FutureLinkCandidate? futureLinkCandidate, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExternalContact() when $default != null:
return $default(_that.id,_that.ownerUserId,_that.name,_that.phoneNumber,_that.note,_that.futureLinkCandidate,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerUserId,  String name,  String? phoneNumber,  String? note,  FutureLinkCandidate? futureLinkCandidate, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ExternalContact():
return $default(_that.id,_that.ownerUserId,_that.name,_that.phoneNumber,_that.note,_that.futureLinkCandidate,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerUserId,  String name,  String? phoneNumber,  String? note,  FutureLinkCandidate? futureLinkCandidate, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ExternalContact() when $default != null:
return $default(_that.id,_that.ownerUserId,_that.name,_that.phoneNumber,_that.note,_that.futureLinkCandidate,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExternalContact implements ExternalContact {
  const _ExternalContact({required this.id, required this.ownerUserId, required this.name, this.phoneNumber, this.note, this.futureLinkCandidate, @DateTimeConverter() required this.createdAt, @DateTimeConverter() required this.updatedAt});
  factory _ExternalContact.fromJson(Map<String, dynamic> json) => _$ExternalContactFromJson(json);

@override final  String id;
@override final  String ownerUserId;
@override final  String name;
@override final  String? phoneNumber;
@override final  String? note;
@override final  FutureLinkCandidate? futureLinkCandidate;
@override@DateTimeConverter() final  DateTime createdAt;
@override@DateTimeConverter() final  DateTime updatedAt;

/// Create a copy of ExternalContact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExternalContactCopyWith<_ExternalContact> get copyWith => __$ExternalContactCopyWithImpl<_ExternalContact>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExternalContactToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExternalContact&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.note, note) || other.note == note)&&(identical(other.futureLinkCandidate, futureLinkCandidate) || other.futureLinkCandidate == futureLinkCandidate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUserId,name,phoneNumber,note,futureLinkCandidate,createdAt,updatedAt);

@override
String toString() {
  return 'ExternalContact(id: $id, ownerUserId: $ownerUserId, name: $name, phoneNumber: $phoneNumber, note: $note, futureLinkCandidate: $futureLinkCandidate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ExternalContactCopyWith<$Res> implements $ExternalContactCopyWith<$Res> {
  factory _$ExternalContactCopyWith(_ExternalContact value, $Res Function(_ExternalContact) _then) = __$ExternalContactCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerUserId, String name, String? phoneNumber, String? note, FutureLinkCandidate? futureLinkCandidate,@DateTimeConverter() DateTime createdAt,@DateTimeConverter() DateTime updatedAt
});


@override $FutureLinkCandidateCopyWith<$Res>? get futureLinkCandidate;

}
/// @nodoc
class __$ExternalContactCopyWithImpl<$Res>
    implements _$ExternalContactCopyWith<$Res> {
  __$ExternalContactCopyWithImpl(this._self, this._then);

  final _ExternalContact _self;
  final $Res Function(_ExternalContact) _then;

/// Create a copy of ExternalContact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerUserId = null,Object? name = null,Object? phoneNumber = freezed,Object? note = freezed,Object? futureLinkCandidate = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ExternalContact(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,futureLinkCandidate: freezed == futureLinkCandidate ? _self.futureLinkCandidate : futureLinkCandidate // ignore: cast_nullable_to_non_nullable
as FutureLinkCandidate?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of ExternalContact
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
