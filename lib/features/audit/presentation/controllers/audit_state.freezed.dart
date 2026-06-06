// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuditState {

 bool get isLoading; List<AuditEvent> get events; String? get errorMessage;
/// Create a copy of AuditState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditStateCopyWith<AuditState> get copyWith => _$AuditStateCopyWithImpl<AuditState>(this as AuditState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.events, events)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(events),errorMessage);

@override
String toString() {
  return 'AuditState(isLoading: $isLoading, events: $events, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $AuditStateCopyWith<$Res>  {
  factory $AuditStateCopyWith(AuditState value, $Res Function(AuditState) _then) = _$AuditStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<AuditEvent> events, String? errorMessage
});




}
/// @nodoc
class _$AuditStateCopyWithImpl<$Res>
    implements $AuditStateCopyWith<$Res> {
  _$AuditStateCopyWithImpl(this._self, this._then);

  final AuditState _self;
  final $Res Function(AuditState) _then;

/// Create a copy of AuditState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? events = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<AuditEvent>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditState].
extension AuditStatePatterns on AuditState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditState value)  $default,){
final _that = this;
switch (_that) {
case _AuditState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditState value)?  $default,){
final _that = this;
switch (_that) {
case _AuditState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<AuditEvent> events,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditState() when $default != null:
return $default(_that.isLoading,_that.events,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<AuditEvent> events,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _AuditState():
return $default(_that.isLoading,_that.events,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<AuditEvent> events,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _AuditState() when $default != null:
return $default(_that.isLoading,_that.events,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _AuditState implements AuditState {
  const _AuditState({this.isLoading = false, final  List<AuditEvent> events = const <AuditEvent>[], this.errorMessage}): _events = events;
  

@override@JsonKey() final  bool isLoading;
 final  List<AuditEvent> _events;
@override@JsonKey() List<AuditEvent> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}

@override final  String? errorMessage;

/// Create a copy of AuditState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditStateCopyWith<_AuditState> get copyWith => __$AuditStateCopyWithImpl<_AuditState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._events, _events)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_events),errorMessage);

@override
String toString() {
  return 'AuditState(isLoading: $isLoading, events: $events, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$AuditStateCopyWith<$Res> implements $AuditStateCopyWith<$Res> {
  factory _$AuditStateCopyWith(_AuditState value, $Res Function(_AuditState) _then) = __$AuditStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<AuditEvent> events, String? errorMessage
});




}
/// @nodoc
class __$AuditStateCopyWithImpl<$Res>
    implements _$AuditStateCopyWith<$Res> {
  __$AuditStateCopyWithImpl(this._self, this._then);

  final _AuditState _self;
  final $Res Function(_AuditState) _then;

/// Create a copy of AuditState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? events = null,Object? errorMessage = freezed,}) {
  return _then(_AuditState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<AuditEvent>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
