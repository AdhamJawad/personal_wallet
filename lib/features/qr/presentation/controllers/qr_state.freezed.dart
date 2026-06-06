// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qr_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QrState {

 bool get isLoading; QrIdentity? get myIdentity; List<QrIdentity> get knownIdentities; QrScanResult? get scanResult; String? get errorMessage;
/// Create a copy of QrState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QrStateCopyWith<QrState> get copyWith => _$QrStateCopyWithImpl<QrState>(this as QrState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QrState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.myIdentity, myIdentity) || other.myIdentity == myIdentity)&&const DeepCollectionEquality().equals(other.knownIdentities, knownIdentities)&&(identical(other.scanResult, scanResult) || other.scanResult == scanResult)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,myIdentity,const DeepCollectionEquality().hash(knownIdentities),scanResult,errorMessage);

@override
String toString() {
  return 'QrState(isLoading: $isLoading, myIdentity: $myIdentity, knownIdentities: $knownIdentities, scanResult: $scanResult, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $QrStateCopyWith<$Res>  {
  factory $QrStateCopyWith(QrState value, $Res Function(QrState) _then) = _$QrStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, QrIdentity? myIdentity, List<QrIdentity> knownIdentities, QrScanResult? scanResult, String? errorMessage
});


$QrIdentityCopyWith<$Res>? get myIdentity;$QrScanResultCopyWith<$Res>? get scanResult;

}
/// @nodoc
class _$QrStateCopyWithImpl<$Res>
    implements $QrStateCopyWith<$Res> {
  _$QrStateCopyWithImpl(this._self, this._then);

  final QrState _self;
  final $Res Function(QrState) _then;

/// Create a copy of QrState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? myIdentity = freezed,Object? knownIdentities = null,Object? scanResult = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,myIdentity: freezed == myIdentity ? _self.myIdentity : myIdentity // ignore: cast_nullable_to_non_nullable
as QrIdentity?,knownIdentities: null == knownIdentities ? _self.knownIdentities : knownIdentities // ignore: cast_nullable_to_non_nullable
as List<QrIdentity>,scanResult: freezed == scanResult ? _self.scanResult : scanResult // ignore: cast_nullable_to_non_nullable
as QrScanResult?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of QrState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QrIdentityCopyWith<$Res>? get myIdentity {
    if (_self.myIdentity == null) {
    return null;
  }

  return $QrIdentityCopyWith<$Res>(_self.myIdentity!, (value) {
    return _then(_self.copyWith(myIdentity: value));
  });
}/// Create a copy of QrState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QrScanResultCopyWith<$Res>? get scanResult {
    if (_self.scanResult == null) {
    return null;
  }

  return $QrScanResultCopyWith<$Res>(_self.scanResult!, (value) {
    return _then(_self.copyWith(scanResult: value));
  });
}
}


/// Adds pattern-matching-related methods to [QrState].
extension QrStatePatterns on QrState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QrState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QrState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QrState value)  $default,){
final _that = this;
switch (_that) {
case _QrState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QrState value)?  $default,){
final _that = this;
switch (_that) {
case _QrState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  QrIdentity? myIdentity,  List<QrIdentity> knownIdentities,  QrScanResult? scanResult,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QrState() when $default != null:
return $default(_that.isLoading,_that.myIdentity,_that.knownIdentities,_that.scanResult,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  QrIdentity? myIdentity,  List<QrIdentity> knownIdentities,  QrScanResult? scanResult,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _QrState():
return $default(_that.isLoading,_that.myIdentity,_that.knownIdentities,_that.scanResult,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  QrIdentity? myIdentity,  List<QrIdentity> knownIdentities,  QrScanResult? scanResult,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _QrState() when $default != null:
return $default(_that.isLoading,_that.myIdentity,_that.knownIdentities,_that.scanResult,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _QrState implements QrState {
  const _QrState({this.isLoading = false, this.myIdentity, final  List<QrIdentity> knownIdentities = const <QrIdentity>[], this.scanResult, this.errorMessage}): _knownIdentities = knownIdentities;
  

@override@JsonKey() final  bool isLoading;
@override final  QrIdentity? myIdentity;
 final  List<QrIdentity> _knownIdentities;
@override@JsonKey() List<QrIdentity> get knownIdentities {
  if (_knownIdentities is EqualUnmodifiableListView) return _knownIdentities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_knownIdentities);
}

@override final  QrScanResult? scanResult;
@override final  String? errorMessage;

/// Create a copy of QrState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QrStateCopyWith<_QrState> get copyWith => __$QrStateCopyWithImpl<_QrState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QrState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.myIdentity, myIdentity) || other.myIdentity == myIdentity)&&const DeepCollectionEquality().equals(other._knownIdentities, _knownIdentities)&&(identical(other.scanResult, scanResult) || other.scanResult == scanResult)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,myIdentity,const DeepCollectionEquality().hash(_knownIdentities),scanResult,errorMessage);

@override
String toString() {
  return 'QrState(isLoading: $isLoading, myIdentity: $myIdentity, knownIdentities: $knownIdentities, scanResult: $scanResult, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$QrStateCopyWith<$Res> implements $QrStateCopyWith<$Res> {
  factory _$QrStateCopyWith(_QrState value, $Res Function(_QrState) _then) = __$QrStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, QrIdentity? myIdentity, List<QrIdentity> knownIdentities, QrScanResult? scanResult, String? errorMessage
});


@override $QrIdentityCopyWith<$Res>? get myIdentity;@override $QrScanResultCopyWith<$Res>? get scanResult;

}
/// @nodoc
class __$QrStateCopyWithImpl<$Res>
    implements _$QrStateCopyWith<$Res> {
  __$QrStateCopyWithImpl(this._self, this._then);

  final _QrState _self;
  final $Res Function(_QrState) _then;

/// Create a copy of QrState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? myIdentity = freezed,Object? knownIdentities = null,Object? scanResult = freezed,Object? errorMessage = freezed,}) {
  return _then(_QrState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,myIdentity: freezed == myIdentity ? _self.myIdentity : myIdentity // ignore: cast_nullable_to_non_nullable
as QrIdentity?,knownIdentities: null == knownIdentities ? _self._knownIdentities : knownIdentities // ignore: cast_nullable_to_non_nullable
as List<QrIdentity>,scanResult: freezed == scanResult ? _self.scanResult : scanResult // ignore: cast_nullable_to_non_nullable
as QrScanResult?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of QrState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QrIdentityCopyWith<$Res>? get myIdentity {
    if (_self.myIdentity == null) {
    return null;
  }

  return $QrIdentityCopyWith<$Res>(_self.myIdentity!, (value) {
    return _then(_self.copyWith(myIdentity: value));
  });
}/// Create a copy of QrState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QrScanResultCopyWith<$Res>? get scanResult {
    if (_self.scanResult == null) {
    return null;
  }

  return $QrScanResultCopyWith<$Res>(_self.scanResult!, (value) {
    return _then(_self.copyWith(scanResult: value));
  });
}
}

// dart format on
