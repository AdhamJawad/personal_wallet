// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt_repayment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DebtRepayment {

 String get id; String get debtId; String get amount; String? get note;@DateTimeConverter() DateTime get createdAt;
/// Create a copy of DebtRepayment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtRepaymentCopyWith<DebtRepayment> get copyWith => _$DebtRepaymentCopyWithImpl<DebtRepayment>(this as DebtRepayment, _$identity);

  /// Serializes this DebtRepayment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtRepayment&&(identical(other.id, id) || other.id == id)&&(identical(other.debtId, debtId) || other.debtId == debtId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,debtId,amount,note,createdAt);

@override
String toString() {
  return 'DebtRepayment(id: $id, debtId: $debtId, amount: $amount, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DebtRepaymentCopyWith<$Res>  {
  factory $DebtRepaymentCopyWith(DebtRepayment value, $Res Function(DebtRepayment) _then) = _$DebtRepaymentCopyWithImpl;
@useResult
$Res call({
 String id, String debtId, String amount, String? note,@DateTimeConverter() DateTime createdAt
});




}
/// @nodoc
class _$DebtRepaymentCopyWithImpl<$Res>
    implements $DebtRepaymentCopyWith<$Res> {
  _$DebtRepaymentCopyWithImpl(this._self, this._then);

  final DebtRepayment _self;
  final $Res Function(DebtRepayment) _then;

/// Create a copy of DebtRepayment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? debtId = null,Object? amount = null,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,debtId: null == debtId ? _self.debtId : debtId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DebtRepayment].
extension DebtRepaymentPatterns on DebtRepayment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DebtRepayment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DebtRepayment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DebtRepayment value)  $default,){
final _that = this;
switch (_that) {
case _DebtRepayment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DebtRepayment value)?  $default,){
final _that = this;
switch (_that) {
case _DebtRepayment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String debtId,  String amount,  String? note, @DateTimeConverter()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DebtRepayment() when $default != null:
return $default(_that.id,_that.debtId,_that.amount,_that.note,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String debtId,  String amount,  String? note, @DateTimeConverter()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _DebtRepayment():
return $default(_that.id,_that.debtId,_that.amount,_that.note,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String debtId,  String amount,  String? note, @DateTimeConverter()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DebtRepayment() when $default != null:
return $default(_that.id,_that.debtId,_that.amount,_that.note,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DebtRepayment implements DebtRepayment {
  const _DebtRepayment({required this.id, required this.debtId, required this.amount, this.note, @DateTimeConverter() required this.createdAt});
  factory _DebtRepayment.fromJson(Map<String, dynamic> json) => _$DebtRepaymentFromJson(json);

@override final  String id;
@override final  String debtId;
@override final  String amount;
@override final  String? note;
@override@DateTimeConverter() final  DateTime createdAt;

/// Create a copy of DebtRepayment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtRepaymentCopyWith<_DebtRepayment> get copyWith => __$DebtRepaymentCopyWithImpl<_DebtRepayment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DebtRepaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DebtRepayment&&(identical(other.id, id) || other.id == id)&&(identical(other.debtId, debtId) || other.debtId == debtId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,debtId,amount,note,createdAt);

@override
String toString() {
  return 'DebtRepayment(id: $id, debtId: $debtId, amount: $amount, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DebtRepaymentCopyWith<$Res> implements $DebtRepaymentCopyWith<$Res> {
  factory _$DebtRepaymentCopyWith(_DebtRepayment value, $Res Function(_DebtRepayment) _then) = __$DebtRepaymentCopyWithImpl;
@override @useResult
$Res call({
 String id, String debtId, String amount, String? note,@DateTimeConverter() DateTime createdAt
});




}
/// @nodoc
class __$DebtRepaymentCopyWithImpl<$Res>
    implements _$DebtRepaymentCopyWith<$Res> {
  __$DebtRepaymentCopyWithImpl(this._self, this._then);

  final _DebtRepayment _self;
  final $Res Function(_DebtRepayment) _then;

/// Create a copy of DebtRepayment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? debtId = null,Object? amount = null,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_DebtRepayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,debtId: null == debtId ? _self.debtId : debtId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
