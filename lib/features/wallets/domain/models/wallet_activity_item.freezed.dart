// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_activity_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletActivityItem {

 String get id; String get title; String get subtitle; String get walletId; String get walletName;@DateTimeConverter() DateTime get occurredAt;
/// Create a copy of WalletActivityItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletActivityItemCopyWith<WalletActivityItem> get copyWith => _$WalletActivityItemCopyWithImpl<WalletActivityItem>(this as WalletActivityItem, _$identity);

  /// Serializes this WalletActivityItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletActivityItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.walletName, walletName) || other.walletName == walletName)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,walletId,walletName,occurredAt);

@override
String toString() {
  return 'WalletActivityItem(id: $id, title: $title, subtitle: $subtitle, walletId: $walletId, walletName: $walletName, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class $WalletActivityItemCopyWith<$Res>  {
  factory $WalletActivityItemCopyWith(WalletActivityItem value, $Res Function(WalletActivityItem) _then) = _$WalletActivityItemCopyWithImpl;
@useResult
$Res call({
 String id, String title, String subtitle, String walletId, String walletName,@DateTimeConverter() DateTime occurredAt
});




}
/// @nodoc
class _$WalletActivityItemCopyWithImpl<$Res>
    implements $WalletActivityItemCopyWith<$Res> {
  _$WalletActivityItemCopyWithImpl(this._self, this._then);

  final WalletActivityItem _self;
  final $Res Function(WalletActivityItem) _then;

/// Create a copy of WalletActivityItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? walletId = null,Object? walletName = null,Object? occurredAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,walletName: null == walletName ? _self.walletName : walletName // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletActivityItem].
extension WalletActivityItemPatterns on WalletActivityItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletActivityItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletActivityItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletActivityItem value)  $default,){
final _that = this;
switch (_that) {
case _WalletActivityItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletActivityItem value)?  $default,){
final _that = this;
switch (_that) {
case _WalletActivityItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String subtitle,  String walletId,  String walletName, @DateTimeConverter()  DateTime occurredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletActivityItem() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.walletId,_that.walletName,_that.occurredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String subtitle,  String walletId,  String walletName, @DateTimeConverter()  DateTime occurredAt)  $default,) {final _that = this;
switch (_that) {
case _WalletActivityItem():
return $default(_that.id,_that.title,_that.subtitle,_that.walletId,_that.walletName,_that.occurredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String subtitle,  String walletId,  String walletName, @DateTimeConverter()  DateTime occurredAt)?  $default,) {final _that = this;
switch (_that) {
case _WalletActivityItem() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.walletId,_that.walletName,_that.occurredAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalletActivityItem implements WalletActivityItem {
  const _WalletActivityItem({required this.id, required this.title, required this.subtitle, required this.walletId, required this.walletName, @DateTimeConverter() required this.occurredAt});
  factory _WalletActivityItem.fromJson(Map<String, dynamic> json) => _$WalletActivityItemFromJson(json);

@override final  String id;
@override final  String title;
@override final  String subtitle;
@override final  String walletId;
@override final  String walletName;
@override@DateTimeConverter() final  DateTime occurredAt;

/// Create a copy of WalletActivityItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletActivityItemCopyWith<_WalletActivityItem> get copyWith => __$WalletActivityItemCopyWithImpl<_WalletActivityItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletActivityItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletActivityItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.walletName, walletName) || other.walletName == walletName)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,walletId,walletName,occurredAt);

@override
String toString() {
  return 'WalletActivityItem(id: $id, title: $title, subtitle: $subtitle, walletId: $walletId, walletName: $walletName, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class _$WalletActivityItemCopyWith<$Res> implements $WalletActivityItemCopyWith<$Res> {
  factory _$WalletActivityItemCopyWith(_WalletActivityItem value, $Res Function(_WalletActivityItem) _then) = __$WalletActivityItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String subtitle, String walletId, String walletName,@DateTimeConverter() DateTime occurredAt
});




}
/// @nodoc
class __$WalletActivityItemCopyWithImpl<$Res>
    implements _$WalletActivityItemCopyWith<$Res> {
  __$WalletActivityItemCopyWithImpl(this._self, this._then);

  final _WalletActivityItem _self;
  final $Res Function(_WalletActivityItem) _then;

/// Create a copy of WalletActivityItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? walletId = null,Object? walletName = null,Object? occurredAt = null,}) {
  return _then(_WalletActivityItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,walletName: null == walletName ? _self.walletName : walletName // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
