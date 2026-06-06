// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attachment_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AttachmentState {

 bool get isLoading; List<Attachment> get attachments; AttachmentReference? get activeReference; String? get errorMessage;
/// Create a copy of AttachmentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttachmentStateCopyWith<AttachmentState> get copyWith => _$AttachmentStateCopyWithImpl<AttachmentState>(this as AttachmentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttachmentState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&(identical(other.activeReference, activeReference) || other.activeReference == activeReference)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(attachments),activeReference,errorMessage);

@override
String toString() {
  return 'AttachmentState(isLoading: $isLoading, attachments: $attachments, activeReference: $activeReference, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $AttachmentStateCopyWith<$Res>  {
  factory $AttachmentStateCopyWith(AttachmentState value, $Res Function(AttachmentState) _then) = _$AttachmentStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<Attachment> attachments, AttachmentReference? activeReference, String? errorMessage
});


$AttachmentReferenceCopyWith<$Res>? get activeReference;

}
/// @nodoc
class _$AttachmentStateCopyWithImpl<$Res>
    implements $AttachmentStateCopyWith<$Res> {
  _$AttachmentStateCopyWithImpl(this._self, this._then);

  final AttachmentState _self;
  final $Res Function(AttachmentState) _then;

/// Create a copy of AttachmentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? attachments = null,Object? activeReference = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<Attachment>,activeReference: freezed == activeReference ? _self.activeReference : activeReference // ignore: cast_nullable_to_non_nullable
as AttachmentReference?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AttachmentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttachmentReferenceCopyWith<$Res>? get activeReference {
    if (_self.activeReference == null) {
    return null;
  }

  return $AttachmentReferenceCopyWith<$Res>(_self.activeReference!, (value) {
    return _then(_self.copyWith(activeReference: value));
  });
}
}


/// Adds pattern-matching-related methods to [AttachmentState].
extension AttachmentStatePatterns on AttachmentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttachmentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttachmentState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttachmentState value)  $default,){
final _that = this;
switch (_that) {
case _AttachmentState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttachmentState value)?  $default,){
final _that = this;
switch (_that) {
case _AttachmentState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<Attachment> attachments,  AttachmentReference? activeReference,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttachmentState() when $default != null:
return $default(_that.isLoading,_that.attachments,_that.activeReference,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<Attachment> attachments,  AttachmentReference? activeReference,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _AttachmentState():
return $default(_that.isLoading,_that.attachments,_that.activeReference,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<Attachment> attachments,  AttachmentReference? activeReference,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _AttachmentState() when $default != null:
return $default(_that.isLoading,_that.attachments,_that.activeReference,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _AttachmentState implements AttachmentState {
  const _AttachmentState({this.isLoading = false, final  List<Attachment> attachments = const <Attachment>[], this.activeReference, this.errorMessage}): _attachments = attachments;
  

@override@JsonKey() final  bool isLoading;
 final  List<Attachment> _attachments;
@override@JsonKey() List<Attachment> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}

@override final  AttachmentReference? activeReference;
@override final  String? errorMessage;

/// Create a copy of AttachmentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttachmentStateCopyWith<_AttachmentState> get copyWith => __$AttachmentStateCopyWithImpl<_AttachmentState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttachmentState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._attachments, _attachments)&&(identical(other.activeReference, activeReference) || other.activeReference == activeReference)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_attachments),activeReference,errorMessage);

@override
String toString() {
  return 'AttachmentState(isLoading: $isLoading, attachments: $attachments, activeReference: $activeReference, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$AttachmentStateCopyWith<$Res> implements $AttachmentStateCopyWith<$Res> {
  factory _$AttachmentStateCopyWith(_AttachmentState value, $Res Function(_AttachmentState) _then) = __$AttachmentStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<Attachment> attachments, AttachmentReference? activeReference, String? errorMessage
});


@override $AttachmentReferenceCopyWith<$Res>? get activeReference;

}
/// @nodoc
class __$AttachmentStateCopyWithImpl<$Res>
    implements _$AttachmentStateCopyWith<$Res> {
  __$AttachmentStateCopyWithImpl(this._self, this._then);

  final _AttachmentState _self;
  final $Res Function(_AttachmentState) _then;

/// Create a copy of AttachmentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? attachments = null,Object? activeReference = freezed,Object? errorMessage = freezed,}) {
  return _then(_AttachmentState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<Attachment>,activeReference: freezed == activeReference ? _self.activeReference : activeReference // ignore: cast_nullable_to_non_nullable
as AttachmentReference?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AttachmentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttachmentReferenceCopyWith<$Res>? get activeReference {
    if (_self.activeReference == null) {
    return null;
  }

  return $AttachmentReferenceCopyWith<$Res>(_self.activeReference!, (value) {
    return _then(_self.copyWith(activeReference: value));
  });
}
}

// dart format on
