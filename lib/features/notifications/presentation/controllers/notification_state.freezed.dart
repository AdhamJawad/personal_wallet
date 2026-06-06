// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationState {

 bool get isLoading; List<NotificationItem> get notifications; NotificationType? get filter; String? get errorMessage;
/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationStateCopyWith<NotificationState> get copyWith => _$NotificationStateCopyWithImpl<NotificationState>(this as NotificationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.notifications, notifications)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(notifications),filter,errorMessage);

@override
String toString() {
  return 'NotificationState(isLoading: $isLoading, notifications: $notifications, filter: $filter, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $NotificationStateCopyWith<$Res>  {
  factory $NotificationStateCopyWith(NotificationState value, $Res Function(NotificationState) _then) = _$NotificationStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<NotificationItem> notifications, NotificationType? filter, String? errorMessage
});




}
/// @nodoc
class _$NotificationStateCopyWithImpl<$Res>
    implements $NotificationStateCopyWith<$Res> {
  _$NotificationStateCopyWithImpl(this._self, this._then);

  final NotificationState _self;
  final $Res Function(NotificationState) _then;

/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? notifications = null,Object? filter = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,notifications: null == notifications ? _self.notifications : notifications // ignore: cast_nullable_to_non_nullable
as List<NotificationItem>,filter: freezed == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as NotificationType?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationState].
extension NotificationStatePatterns on NotificationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationState value)  $default,){
final _that = this;
switch (_that) {
case _NotificationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationState value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<NotificationItem> notifications,  NotificationType? filter,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationState() when $default != null:
return $default(_that.isLoading,_that.notifications,_that.filter,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<NotificationItem> notifications,  NotificationType? filter,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _NotificationState():
return $default(_that.isLoading,_that.notifications,_that.filter,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<NotificationItem> notifications,  NotificationType? filter,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _NotificationState() when $default != null:
return $default(_that.isLoading,_that.notifications,_that.filter,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationState extends NotificationState {
  const _NotificationState({this.isLoading = false, final  List<NotificationItem> notifications = const <NotificationItem>[], this.filter, this.errorMessage}): _notifications = notifications,super._();
  

@override@JsonKey() final  bool isLoading;
 final  List<NotificationItem> _notifications;
@override@JsonKey() List<NotificationItem> get notifications {
  if (_notifications is EqualUnmodifiableListView) return _notifications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notifications);
}

@override final  NotificationType? filter;
@override final  String? errorMessage;

/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationStateCopyWith<_NotificationState> get copyWith => __$NotificationStateCopyWithImpl<_NotificationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._notifications, _notifications)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_notifications),filter,errorMessage);

@override
String toString() {
  return 'NotificationState(isLoading: $isLoading, notifications: $notifications, filter: $filter, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$NotificationStateCopyWith<$Res> implements $NotificationStateCopyWith<$Res> {
  factory _$NotificationStateCopyWith(_NotificationState value, $Res Function(_NotificationState) _then) = __$NotificationStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<NotificationItem> notifications, NotificationType? filter, String? errorMessage
});




}
/// @nodoc
class __$NotificationStateCopyWithImpl<$Res>
    implements _$NotificationStateCopyWith<$Res> {
  __$NotificationStateCopyWithImpl(this._self, this._then);

  final _NotificationState _self;
  final $Res Function(_NotificationState) _then;

/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? notifications = null,Object? filter = freezed,Object? errorMessage = freezed,}) {
  return _then(_NotificationState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,notifications: null == notifications ? _self._notifications : notifications // ignore: cast_nullable_to_non_nullable
as List<NotificationItem>,filter: freezed == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as NotificationType?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
