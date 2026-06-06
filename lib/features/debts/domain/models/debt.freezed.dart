// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Debt {

 String get id; String get ownerUserId; String get counterpartyContactId; bool get isOwedToMe; Currency get currency; String get originalAmount; String? get note;@DateTimeConverter() DateTime get createdAt;@DateTimeConverter() DateTime get updatedAt;@DateTimeConverter() DateTime? get completedAt;
/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtCopyWith<Debt> get copyWith => _$DebtCopyWithImpl<Debt>(this as Debt, _$identity);

  /// Serializes this Debt to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Debt&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.counterpartyContactId, counterpartyContactId) || other.counterpartyContactId == counterpartyContactId)&&(identical(other.isOwedToMe, isOwedToMe) || other.isOwedToMe == isOwedToMe)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.originalAmount, originalAmount) || other.originalAmount == originalAmount)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUserId,counterpartyContactId,isOwedToMe,currency,originalAmount,note,createdAt,updatedAt,completedAt);

@override
String toString() {
  return 'Debt(id: $id, ownerUserId: $ownerUserId, counterpartyContactId: $counterpartyContactId, isOwedToMe: $isOwedToMe, currency: $currency, originalAmount: $originalAmount, note: $note, createdAt: $createdAt, updatedAt: $updatedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $DebtCopyWith<$Res>  {
  factory $DebtCopyWith(Debt value, $Res Function(Debt) _then) = _$DebtCopyWithImpl;
@useResult
$Res call({
 String id, String ownerUserId, String counterpartyContactId, bool isOwedToMe, Currency currency, String originalAmount, String? note,@DateTimeConverter() DateTime createdAt,@DateTimeConverter() DateTime updatedAt,@DateTimeConverter() DateTime? completedAt
});




}
/// @nodoc
class _$DebtCopyWithImpl<$Res>
    implements $DebtCopyWith<$Res> {
  _$DebtCopyWithImpl(this._self, this._then);

  final Debt _self;
  final $Res Function(Debt) _then;

/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerUserId = null,Object? counterpartyContactId = null,Object? isOwedToMe = null,Object? currency = null,Object? originalAmount = null,Object? note = freezed,Object? createdAt = null,Object? updatedAt = null,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,counterpartyContactId: null == counterpartyContactId ? _self.counterpartyContactId : counterpartyContactId // ignore: cast_nullable_to_non_nullable
as String,isOwedToMe: null == isOwedToMe ? _self.isOwedToMe : isOwedToMe // ignore: cast_nullable_to_non_nullable
as bool,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,originalAmount: null == originalAmount ? _self.originalAmount : originalAmount // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Debt].
extension DebtPatterns on Debt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Debt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Debt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Debt value)  $default,){
final _that = this;
switch (_that) {
case _Debt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Debt value)?  $default,){
final _that = this;
switch (_that) {
case _Debt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerUserId,  String counterpartyContactId,  bool isOwedToMe,  Currency currency,  String originalAmount,  String? note, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt, @DateTimeConverter()  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Debt() when $default != null:
return $default(_that.id,_that.ownerUserId,_that.counterpartyContactId,_that.isOwedToMe,_that.currency,_that.originalAmount,_that.note,_that.createdAt,_that.updatedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerUserId,  String counterpartyContactId,  bool isOwedToMe,  Currency currency,  String originalAmount,  String? note, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt, @DateTimeConverter()  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _Debt():
return $default(_that.id,_that.ownerUserId,_that.counterpartyContactId,_that.isOwedToMe,_that.currency,_that.originalAmount,_that.note,_that.createdAt,_that.updatedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerUserId,  String counterpartyContactId,  bool isOwedToMe,  Currency currency,  String originalAmount,  String? note, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt, @DateTimeConverter()  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _Debt() when $default != null:
return $default(_that.id,_that.ownerUserId,_that.counterpartyContactId,_that.isOwedToMe,_that.currency,_that.originalAmount,_that.note,_that.createdAt,_that.updatedAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Debt implements Debt {
  const _Debt({required this.id, required this.ownerUserId, required this.counterpartyContactId, required this.isOwedToMe, required this.currency, required this.originalAmount, this.note, @DateTimeConverter() required this.createdAt, @DateTimeConverter() required this.updatedAt, @DateTimeConverter() this.completedAt});
  factory _Debt.fromJson(Map<String, dynamic> json) => _$DebtFromJson(json);

@override final  String id;
@override final  String ownerUserId;
@override final  String counterpartyContactId;
@override final  bool isOwedToMe;
@override final  Currency currency;
@override final  String originalAmount;
@override final  String? note;
@override@DateTimeConverter() final  DateTime createdAt;
@override@DateTimeConverter() final  DateTime updatedAt;
@override@DateTimeConverter() final  DateTime? completedAt;

/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtCopyWith<_Debt> get copyWith => __$DebtCopyWithImpl<_Debt>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DebtToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Debt&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.counterpartyContactId, counterpartyContactId) || other.counterpartyContactId == counterpartyContactId)&&(identical(other.isOwedToMe, isOwedToMe) || other.isOwedToMe == isOwedToMe)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.originalAmount, originalAmount) || other.originalAmount == originalAmount)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUserId,counterpartyContactId,isOwedToMe,currency,originalAmount,note,createdAt,updatedAt,completedAt);

@override
String toString() {
  return 'Debt(id: $id, ownerUserId: $ownerUserId, counterpartyContactId: $counterpartyContactId, isOwedToMe: $isOwedToMe, currency: $currency, originalAmount: $originalAmount, note: $note, createdAt: $createdAt, updatedAt: $updatedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$DebtCopyWith<$Res> implements $DebtCopyWith<$Res> {
  factory _$DebtCopyWith(_Debt value, $Res Function(_Debt) _then) = __$DebtCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerUserId, String counterpartyContactId, bool isOwedToMe, Currency currency, String originalAmount, String? note,@DateTimeConverter() DateTime createdAt,@DateTimeConverter() DateTime updatedAt,@DateTimeConverter() DateTime? completedAt
});




}
/// @nodoc
class __$DebtCopyWithImpl<$Res>
    implements _$DebtCopyWith<$Res> {
  __$DebtCopyWithImpl(this._self, this._then);

  final _Debt _self;
  final $Res Function(_Debt) _then;

/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerUserId = null,Object? counterpartyContactId = null,Object? isOwedToMe = null,Object? currency = null,Object? originalAmount = null,Object? note = freezed,Object? createdAt = null,Object? updatedAt = null,Object? completedAt = freezed,}) {
  return _then(_Debt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,counterpartyContactId: null == counterpartyContactId ? _self.counterpartyContactId : counterpartyContactId // ignore: cast_nullable_to_non_nullable
as String,isOwedToMe: null == isOwedToMe ? _self.isOwedToMe : isOwedToMe // ignore: cast_nullable_to_non_nullable
as bool,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,originalAmount: null == originalAmount ? _self.originalAmount : originalAmount // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
