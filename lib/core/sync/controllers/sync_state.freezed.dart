// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SyncState {

 bool get isLoading; List<SyncOperation> get operations; List<ConflictSummary> get conflicts; String? get errorMessage;
/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncStateCopyWith<SyncState> get copyWith => _$SyncStateCopyWithImpl<SyncState>(this as SyncState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.operations, operations)&&const DeepCollectionEquality().equals(other.conflicts, conflicts)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(operations),const DeepCollectionEquality().hash(conflicts),errorMessage);

@override
String toString() {
  return 'SyncState(isLoading: $isLoading, operations: $operations, conflicts: $conflicts, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SyncStateCopyWith<$Res>  {
  factory $SyncStateCopyWith(SyncState value, $Res Function(SyncState) _then) = _$SyncStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<SyncOperation> operations, List<ConflictSummary> conflicts, String? errorMessage
});




}
/// @nodoc
class _$SyncStateCopyWithImpl<$Res>
    implements $SyncStateCopyWith<$Res> {
  _$SyncStateCopyWithImpl(this._self, this._then);

  final SyncState _self;
  final $Res Function(SyncState) _then;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? operations = null,Object? conflicts = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,operations: null == operations ? _self.operations : operations // ignore: cast_nullable_to_non_nullable
as List<SyncOperation>,conflicts: null == conflicts ? _self.conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as List<ConflictSummary>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncState].
extension SyncStatePatterns on SyncState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncState value)  $default,){
final _that = this;
switch (_that) {
case _SyncState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncState value)?  $default,){
final _that = this;
switch (_that) {
case _SyncState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<SyncOperation> operations,  List<ConflictSummary> conflicts,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncState() when $default != null:
return $default(_that.isLoading,_that.operations,_that.conflicts,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<SyncOperation> operations,  List<ConflictSummary> conflicts,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _SyncState():
return $default(_that.isLoading,_that.operations,_that.conflicts,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<SyncOperation> operations,  List<ConflictSummary> conflicts,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _SyncState() when $default != null:
return $default(_that.isLoading,_that.operations,_that.conflicts,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _SyncState extends SyncState {
  const _SyncState({this.isLoading = false, final  List<SyncOperation> operations = const <SyncOperation>[], final  List<ConflictSummary> conflicts = const <ConflictSummary>[], this.errorMessage}): _operations = operations,_conflicts = conflicts,super._();
  

@override@JsonKey() final  bool isLoading;
 final  List<SyncOperation> _operations;
@override@JsonKey() List<SyncOperation> get operations {
  if (_operations is EqualUnmodifiableListView) return _operations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_operations);
}

 final  List<ConflictSummary> _conflicts;
@override@JsonKey() List<ConflictSummary> get conflicts {
  if (_conflicts is EqualUnmodifiableListView) return _conflicts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conflicts);
}

@override final  String? errorMessage;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncStateCopyWith<_SyncState> get copyWith => __$SyncStateCopyWithImpl<_SyncState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._operations, _operations)&&const DeepCollectionEquality().equals(other._conflicts, _conflicts)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_operations),const DeepCollectionEquality().hash(_conflicts),errorMessage);

@override
String toString() {
  return 'SyncState(isLoading: $isLoading, operations: $operations, conflicts: $conflicts, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$SyncStateCopyWith<$Res> implements $SyncStateCopyWith<$Res> {
  factory _$SyncStateCopyWith(_SyncState value, $Res Function(_SyncState) _then) = __$SyncStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<SyncOperation> operations, List<ConflictSummary> conflicts, String? errorMessage
});




}
/// @nodoc
class __$SyncStateCopyWithImpl<$Res>
    implements _$SyncStateCopyWith<$Res> {
  __$SyncStateCopyWithImpl(this._self, this._then);

  final _SyncState _self;
  final $Res Function(_SyncState) _then;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? operations = null,Object? conflicts = null,Object? errorMessage = freezed,}) {
  return _then(_SyncState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,operations: null == operations ? _self._operations : operations // ignore: cast_nullable_to_non_nullable
as List<SyncOperation>,conflicts: null == conflicts ? _self._conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as List<ConflictSummary>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
