// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_reference.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionReference {

 String get value; int get year; int get sequence;
/// Create a copy of TransactionReference
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionReferenceCopyWith<TransactionReference> get copyWith => _$TransactionReferenceCopyWithImpl<TransactionReference>(this as TransactionReference, _$identity);

  /// Serializes this TransactionReference to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionReference&&(identical(other.value, value) || other.value == value)&&(identical(other.year, year) || other.year == year)&&(identical(other.sequence, sequence) || other.sequence == sequence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,year,sequence);

@override
String toString() {
  return 'TransactionReference(value: $value, year: $year, sequence: $sequence)';
}


}

/// @nodoc
abstract mixin class $TransactionReferenceCopyWith<$Res>  {
  factory $TransactionReferenceCopyWith(TransactionReference value, $Res Function(TransactionReference) _then) = _$TransactionReferenceCopyWithImpl;
@useResult
$Res call({
 String value, int year, int sequence
});




}
/// @nodoc
class _$TransactionReferenceCopyWithImpl<$Res>
    implements $TransactionReferenceCopyWith<$Res> {
  _$TransactionReferenceCopyWithImpl(this._self, this._then);

  final TransactionReference _self;
  final $Res Function(TransactionReference) _then;

/// Create a copy of TransactionReference
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? year = null,Object? sequence = null,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionReference].
extension TransactionReferencePatterns on TransactionReference {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionReference value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionReference() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionReference value)  $default,){
final _that = this;
switch (_that) {
case _TransactionReference():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionReference value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionReference() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String value,  int year,  int sequence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionReference() when $default != null:
return $default(_that.value,_that.year,_that.sequence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String value,  int year,  int sequence)  $default,) {final _that = this;
switch (_that) {
case _TransactionReference():
return $default(_that.value,_that.year,_that.sequence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String value,  int year,  int sequence)?  $default,) {final _that = this;
switch (_that) {
case _TransactionReference() when $default != null:
return $default(_that.value,_that.year,_that.sequence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionReference implements TransactionReference {
  const _TransactionReference({required this.value, required this.year, required this.sequence});
  factory _TransactionReference.fromJson(Map<String, dynamic> json) => _$TransactionReferenceFromJson(json);

@override final  String value;
@override final  int year;
@override final  int sequence;

/// Create a copy of TransactionReference
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionReferenceCopyWith<_TransactionReference> get copyWith => __$TransactionReferenceCopyWithImpl<_TransactionReference>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionReferenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionReference&&(identical(other.value, value) || other.value == value)&&(identical(other.year, year) || other.year == year)&&(identical(other.sequence, sequence) || other.sequence == sequence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,year,sequence);

@override
String toString() {
  return 'TransactionReference(value: $value, year: $year, sequence: $sequence)';
}


}

/// @nodoc
abstract mixin class _$TransactionReferenceCopyWith<$Res> implements $TransactionReferenceCopyWith<$Res> {
  factory _$TransactionReferenceCopyWith(_TransactionReference value, $Res Function(_TransactionReference) _then) = __$TransactionReferenceCopyWithImpl;
@override @useResult
$Res call({
 String value, int year, int sequence
});




}
/// @nodoc
class __$TransactionReferenceCopyWithImpl<$Res>
    implements _$TransactionReferenceCopyWith<$Res> {
  __$TransactionReferenceCopyWithImpl(this._self, this._then);

  final _TransactionReference _self;
  final $Res Function(_TransactionReference) _then;

/// Create a copy of TransactionReference
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? year = null,Object? sequence = null,}) {
  return _then(_TransactionReference(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
