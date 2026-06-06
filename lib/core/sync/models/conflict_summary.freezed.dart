// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conflict_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConflictSummary {

 SyncOperation get operation; ConflictRecord get record; ConflictResolutionStrategy get recommendedStrategy;
/// Create a copy of ConflictSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConflictSummaryCopyWith<ConflictSummary> get copyWith => _$ConflictSummaryCopyWithImpl<ConflictSummary>(this as ConflictSummary, _$identity);

  /// Serializes this ConflictSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConflictSummary&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.record, record) || other.record == record)&&(identical(other.recommendedStrategy, recommendedStrategy) || other.recommendedStrategy == recommendedStrategy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,operation,record,recommendedStrategy);

@override
String toString() {
  return 'ConflictSummary(operation: $operation, record: $record, recommendedStrategy: $recommendedStrategy)';
}


}

/// @nodoc
abstract mixin class $ConflictSummaryCopyWith<$Res>  {
  factory $ConflictSummaryCopyWith(ConflictSummary value, $Res Function(ConflictSummary) _then) = _$ConflictSummaryCopyWithImpl;
@useResult
$Res call({
 SyncOperation operation, ConflictRecord record, ConflictResolutionStrategy recommendedStrategy
});


$SyncOperationCopyWith<$Res> get operation;$ConflictRecordCopyWith<$Res> get record;

}
/// @nodoc
class _$ConflictSummaryCopyWithImpl<$Res>
    implements $ConflictSummaryCopyWith<$Res> {
  _$ConflictSummaryCopyWithImpl(this._self, this._then);

  final ConflictSummary _self;
  final $Res Function(ConflictSummary) _then;

/// Create a copy of ConflictSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? operation = null,Object? record = null,Object? recommendedStrategy = null,}) {
  return _then(_self.copyWith(
operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as SyncOperation,record: null == record ? _self.record : record // ignore: cast_nullable_to_non_nullable
as ConflictRecord,recommendedStrategy: null == recommendedStrategy ? _self.recommendedStrategy : recommendedStrategy // ignore: cast_nullable_to_non_nullable
as ConflictResolutionStrategy,
  ));
}
/// Create a copy of ConflictSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncOperationCopyWith<$Res> get operation {
  
  return $SyncOperationCopyWith<$Res>(_self.operation, (value) {
    return _then(_self.copyWith(operation: value));
  });
}/// Create a copy of ConflictSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConflictRecordCopyWith<$Res> get record {
  
  return $ConflictRecordCopyWith<$Res>(_self.record, (value) {
    return _then(_self.copyWith(record: value));
  });
}
}


/// Adds pattern-matching-related methods to [ConflictSummary].
extension ConflictSummaryPatterns on ConflictSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConflictSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConflictSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConflictSummary value)  $default,){
final _that = this;
switch (_that) {
case _ConflictSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConflictSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ConflictSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SyncOperation operation,  ConflictRecord record,  ConflictResolutionStrategy recommendedStrategy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConflictSummary() when $default != null:
return $default(_that.operation,_that.record,_that.recommendedStrategy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SyncOperation operation,  ConflictRecord record,  ConflictResolutionStrategy recommendedStrategy)  $default,) {final _that = this;
switch (_that) {
case _ConflictSummary():
return $default(_that.operation,_that.record,_that.recommendedStrategy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SyncOperation operation,  ConflictRecord record,  ConflictResolutionStrategy recommendedStrategy)?  $default,) {final _that = this;
switch (_that) {
case _ConflictSummary() when $default != null:
return $default(_that.operation,_that.record,_that.recommendedStrategy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConflictSummary implements ConflictSummary {
  const _ConflictSummary({required this.operation, required this.record, required this.recommendedStrategy});
  factory _ConflictSummary.fromJson(Map<String, dynamic> json) => _$ConflictSummaryFromJson(json);

@override final  SyncOperation operation;
@override final  ConflictRecord record;
@override final  ConflictResolutionStrategy recommendedStrategy;

/// Create a copy of ConflictSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConflictSummaryCopyWith<_ConflictSummary> get copyWith => __$ConflictSummaryCopyWithImpl<_ConflictSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConflictSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConflictSummary&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.record, record) || other.record == record)&&(identical(other.recommendedStrategy, recommendedStrategy) || other.recommendedStrategy == recommendedStrategy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,operation,record,recommendedStrategy);

@override
String toString() {
  return 'ConflictSummary(operation: $operation, record: $record, recommendedStrategy: $recommendedStrategy)';
}


}

/// @nodoc
abstract mixin class _$ConflictSummaryCopyWith<$Res> implements $ConflictSummaryCopyWith<$Res> {
  factory _$ConflictSummaryCopyWith(_ConflictSummary value, $Res Function(_ConflictSummary) _then) = __$ConflictSummaryCopyWithImpl;
@override @useResult
$Res call({
 SyncOperation operation, ConflictRecord record, ConflictResolutionStrategy recommendedStrategy
});


@override $SyncOperationCopyWith<$Res> get operation;@override $ConflictRecordCopyWith<$Res> get record;

}
/// @nodoc
class __$ConflictSummaryCopyWithImpl<$Res>
    implements _$ConflictSummaryCopyWith<$Res> {
  __$ConflictSummaryCopyWithImpl(this._self, this._then);

  final _ConflictSummary _self;
  final $Res Function(_ConflictSummary) _then;

/// Create a copy of ConflictSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? operation = null,Object? record = null,Object? recommendedStrategy = null,}) {
  return _then(_ConflictSummary(
operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as SyncOperation,record: null == record ? _self.record : record // ignore: cast_nullable_to_non_nullable
as ConflictRecord,recommendedStrategy: null == recommendedStrategy ? _self.recommendedStrategy : recommendedStrategy // ignore: cast_nullable_to_non_nullable
as ConflictResolutionStrategy,
  ));
}

/// Create a copy of ConflictSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncOperationCopyWith<$Res> get operation {
  
  return $SyncOperationCopyWith<$Res>(_self.operation, (value) {
    return _then(_self.copyWith(operation: value));
  });
}/// Create a copy of ConflictSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConflictRecordCopyWith<$Res> get record {
  
  return $ConflictRecordCopyWith<$Res>(_self.record, (value) {
    return _then(_self.copyWith(record: value));
  });
}
}

// dart format on
