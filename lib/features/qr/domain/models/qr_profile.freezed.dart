// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qr_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QrProfile {

 String get userId; String get transferToken; String get contactToken;@DateTimeConverter() DateTime get createdAt;@DateTimeConverter() DateTime get updatedAt;
/// Create a copy of QrProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QrProfileCopyWith<QrProfile> get copyWith => _$QrProfileCopyWithImpl<QrProfile>(this as QrProfile, _$identity);

  /// Serializes this QrProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QrProfile&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.transferToken, transferToken) || other.transferToken == transferToken)&&(identical(other.contactToken, contactToken) || other.contactToken == contactToken)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,transferToken,contactToken,createdAt,updatedAt);

@override
String toString() {
  return 'QrProfile(userId: $userId, transferToken: $transferToken, contactToken: $contactToken, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $QrProfileCopyWith<$Res>  {
  factory $QrProfileCopyWith(QrProfile value, $Res Function(QrProfile) _then) = _$QrProfileCopyWithImpl;
@useResult
$Res call({
 String userId, String transferToken, String contactToken,@DateTimeConverter() DateTime createdAt,@DateTimeConverter() DateTime updatedAt
});




}
/// @nodoc
class _$QrProfileCopyWithImpl<$Res>
    implements $QrProfileCopyWith<$Res> {
  _$QrProfileCopyWithImpl(this._self, this._then);

  final QrProfile _self;
  final $Res Function(QrProfile) _then;

/// Create a copy of QrProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? transferToken = null,Object? contactToken = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,transferToken: null == transferToken ? _self.transferToken : transferToken // ignore: cast_nullable_to_non_nullable
as String,contactToken: null == contactToken ? _self.contactToken : contactToken // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [QrProfile].
extension QrProfilePatterns on QrProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QrProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QrProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QrProfile value)  $default,){
final _that = this;
switch (_that) {
case _QrProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QrProfile value)?  $default,){
final _that = this;
switch (_that) {
case _QrProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String transferToken,  String contactToken, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QrProfile() when $default != null:
return $default(_that.userId,_that.transferToken,_that.contactToken,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String transferToken,  String contactToken, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _QrProfile():
return $default(_that.userId,_that.transferToken,_that.contactToken,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String transferToken,  String contactToken, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _QrProfile() when $default != null:
return $default(_that.userId,_that.transferToken,_that.contactToken,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QrProfile implements QrProfile {
  const _QrProfile({required this.userId, required this.transferToken, required this.contactToken, @DateTimeConverter() required this.createdAt, @DateTimeConverter() required this.updatedAt});
  factory _QrProfile.fromJson(Map<String, dynamic> json) => _$QrProfileFromJson(json);

@override final  String userId;
@override final  String transferToken;
@override final  String contactToken;
@override@DateTimeConverter() final  DateTime createdAt;
@override@DateTimeConverter() final  DateTime updatedAt;

/// Create a copy of QrProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QrProfileCopyWith<_QrProfile> get copyWith => __$QrProfileCopyWithImpl<_QrProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QrProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QrProfile&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.transferToken, transferToken) || other.transferToken == transferToken)&&(identical(other.contactToken, contactToken) || other.contactToken == contactToken)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,transferToken,contactToken,createdAt,updatedAt);

@override
String toString() {
  return 'QrProfile(userId: $userId, transferToken: $transferToken, contactToken: $contactToken, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$QrProfileCopyWith<$Res> implements $QrProfileCopyWith<$Res> {
  factory _$QrProfileCopyWith(_QrProfile value, $Res Function(_QrProfile) _then) = __$QrProfileCopyWithImpl;
@override @useResult
$Res call({
 String userId, String transferToken, String contactToken,@DateTimeConverter() DateTime createdAt,@DateTimeConverter() DateTime updatedAt
});




}
/// @nodoc
class __$QrProfileCopyWithImpl<$Res>
    implements _$QrProfileCopyWith<$Res> {
  __$QrProfileCopyWithImpl(this._self, this._then);

  final _QrProfile _self;
  final $Res Function(_QrProfile) _then;

/// Create a copy of QrProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? transferToken = null,Object? contactToken = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_QrProfile(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,transferToken: null == transferToken ? _self.transferToken : transferToken // ignore: cast_nullable_to_non_nullable
as String,contactToken: null == contactToken ? _self.contactToken : contactToken // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
