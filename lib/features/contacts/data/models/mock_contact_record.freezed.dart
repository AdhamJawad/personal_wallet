// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mock_contact_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MockContactRecord {

 Contact get contact;
/// Create a copy of MockContactRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MockContactRecordCopyWith<MockContactRecord> get copyWith => _$MockContactRecordCopyWithImpl<MockContactRecord>(this as MockContactRecord, _$identity);

  /// Serializes this MockContactRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MockContactRecord&&(identical(other.contact, contact) || other.contact == contact));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contact);

@override
String toString() {
  return 'MockContactRecord(contact: $contact)';
}


}

/// @nodoc
abstract mixin class $MockContactRecordCopyWith<$Res>  {
  factory $MockContactRecordCopyWith(MockContactRecord value, $Res Function(MockContactRecord) _then) = _$MockContactRecordCopyWithImpl;
@useResult
$Res call({
 Contact contact
});


$ContactCopyWith<$Res> get contact;

}
/// @nodoc
class _$MockContactRecordCopyWithImpl<$Res>
    implements $MockContactRecordCopyWith<$Res> {
  _$MockContactRecordCopyWithImpl(this._self, this._then);

  final MockContactRecord _self;
  final $Res Function(MockContactRecord) _then;

/// Create a copy of MockContactRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contact = null,}) {
  return _then(_self.copyWith(
contact: null == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as Contact,
  ));
}
/// Create a copy of MockContactRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactCopyWith<$Res> get contact {
  
  return $ContactCopyWith<$Res>(_self.contact, (value) {
    return _then(_self.copyWith(contact: value));
  });
}
}


/// Adds pattern-matching-related methods to [MockContactRecord].
extension MockContactRecordPatterns on MockContactRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MockContactRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MockContactRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MockContactRecord value)  $default,){
final _that = this;
switch (_that) {
case _MockContactRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MockContactRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MockContactRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Contact contact)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MockContactRecord() when $default != null:
return $default(_that.contact);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Contact contact)  $default,) {final _that = this;
switch (_that) {
case _MockContactRecord():
return $default(_that.contact);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Contact contact)?  $default,) {final _that = this;
switch (_that) {
case _MockContactRecord() when $default != null:
return $default(_that.contact);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MockContactRecord implements MockContactRecord {
  const _MockContactRecord({required this.contact});
  factory _MockContactRecord.fromJson(Map<String, dynamic> json) => _$MockContactRecordFromJson(json);

@override final  Contact contact;

/// Create a copy of MockContactRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MockContactRecordCopyWith<_MockContactRecord> get copyWith => __$MockContactRecordCopyWithImpl<_MockContactRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MockContactRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MockContactRecord&&(identical(other.contact, contact) || other.contact == contact));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contact);

@override
String toString() {
  return 'MockContactRecord(contact: $contact)';
}


}

/// @nodoc
abstract mixin class _$MockContactRecordCopyWith<$Res> implements $MockContactRecordCopyWith<$Res> {
  factory _$MockContactRecordCopyWith(_MockContactRecord value, $Res Function(_MockContactRecord) _then) = __$MockContactRecordCopyWithImpl;
@override @useResult
$Res call({
 Contact contact
});


@override $ContactCopyWith<$Res> get contact;

}
/// @nodoc
class __$MockContactRecordCopyWithImpl<$Res>
    implements _$MockContactRecordCopyWith<$Res> {
  __$MockContactRecordCopyWithImpl(this._self, this._then);

  final _MockContactRecord _self;
  final $Res Function(_MockContactRecord) _then;

/// Create a copy of MockContactRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contact = null,}) {
  return _then(_MockContactRecord(
contact: null == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as Contact,
  ));
}

/// Create a copy of MockContactRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactCopyWith<$Res> get contact {
  
  return $ContactCopyWith<$Res>(_self.contact, (value) {
    return _then(_self.copyWith(contact: value));
  });
}
}

// dart format on
