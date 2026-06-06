// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt_settlement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DebtSettlement {

 String get id; String get debtId; String get ownerUserId; String get transferId; String get ledgerTransactionId; String get transferReference; Currency get currency; String get amount; String? get note;@DateTimeConverter() DateTime get createdAt;
/// Create a copy of DebtSettlement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtSettlementCopyWith<DebtSettlement> get copyWith => _$DebtSettlementCopyWithImpl<DebtSettlement>(this as DebtSettlement, _$identity);

  /// Serializes this DebtSettlement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtSettlement&&(identical(other.id, id) || other.id == id)&&(identical(other.debtId, debtId) || other.debtId == debtId)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.transferId, transferId) || other.transferId == transferId)&&(identical(other.ledgerTransactionId, ledgerTransactionId) || other.ledgerTransactionId == ledgerTransactionId)&&(identical(other.transferReference, transferReference) || other.transferReference == transferReference)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,debtId,ownerUserId,transferId,ledgerTransactionId,transferReference,currency,amount,note,createdAt);

@override
String toString() {
  return 'DebtSettlement(id: $id, debtId: $debtId, ownerUserId: $ownerUserId, transferId: $transferId, ledgerTransactionId: $ledgerTransactionId, transferReference: $transferReference, currency: $currency, amount: $amount, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DebtSettlementCopyWith<$Res>  {
  factory $DebtSettlementCopyWith(DebtSettlement value, $Res Function(DebtSettlement) _then) = _$DebtSettlementCopyWithImpl;
@useResult
$Res call({
 String id, String debtId, String ownerUserId, String transferId, String ledgerTransactionId, String transferReference, Currency currency, String amount, String? note,@DateTimeConverter() DateTime createdAt
});




}
/// @nodoc
class _$DebtSettlementCopyWithImpl<$Res>
    implements $DebtSettlementCopyWith<$Res> {
  _$DebtSettlementCopyWithImpl(this._self, this._then);

  final DebtSettlement _self;
  final $Res Function(DebtSettlement) _then;

/// Create a copy of DebtSettlement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? debtId = null,Object? ownerUserId = null,Object? transferId = null,Object? ledgerTransactionId = null,Object? transferReference = null,Object? currency = null,Object? amount = null,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,debtId: null == debtId ? _self.debtId : debtId // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,transferId: null == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as String,ledgerTransactionId: null == ledgerTransactionId ? _self.ledgerTransactionId : ledgerTransactionId // ignore: cast_nullable_to_non_nullable
as String,transferReference: null == transferReference ? _self.transferReference : transferReference // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DebtSettlement].
extension DebtSettlementPatterns on DebtSettlement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DebtSettlement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DebtSettlement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DebtSettlement value)  $default,){
final _that = this;
switch (_that) {
case _DebtSettlement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DebtSettlement value)?  $default,){
final _that = this;
switch (_that) {
case _DebtSettlement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String debtId,  String ownerUserId,  String transferId,  String ledgerTransactionId,  String transferReference,  Currency currency,  String amount,  String? note, @DateTimeConverter()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DebtSettlement() when $default != null:
return $default(_that.id,_that.debtId,_that.ownerUserId,_that.transferId,_that.ledgerTransactionId,_that.transferReference,_that.currency,_that.amount,_that.note,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String debtId,  String ownerUserId,  String transferId,  String ledgerTransactionId,  String transferReference,  Currency currency,  String amount,  String? note, @DateTimeConverter()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _DebtSettlement():
return $default(_that.id,_that.debtId,_that.ownerUserId,_that.transferId,_that.ledgerTransactionId,_that.transferReference,_that.currency,_that.amount,_that.note,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String debtId,  String ownerUserId,  String transferId,  String ledgerTransactionId,  String transferReference,  Currency currency,  String amount,  String? note, @DateTimeConverter()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DebtSettlement() when $default != null:
return $default(_that.id,_that.debtId,_that.ownerUserId,_that.transferId,_that.ledgerTransactionId,_that.transferReference,_that.currency,_that.amount,_that.note,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DebtSettlement implements DebtSettlement {
  const _DebtSettlement({required this.id, required this.debtId, required this.ownerUserId, required this.transferId, required this.ledgerTransactionId, required this.transferReference, required this.currency, required this.amount, this.note, @DateTimeConverter() required this.createdAt});
  factory _DebtSettlement.fromJson(Map<String, dynamic> json) => _$DebtSettlementFromJson(json);

@override final  String id;
@override final  String debtId;
@override final  String ownerUserId;
@override final  String transferId;
@override final  String ledgerTransactionId;
@override final  String transferReference;
@override final  Currency currency;
@override final  String amount;
@override final  String? note;
@override@DateTimeConverter() final  DateTime createdAt;

/// Create a copy of DebtSettlement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtSettlementCopyWith<_DebtSettlement> get copyWith => __$DebtSettlementCopyWithImpl<_DebtSettlement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DebtSettlementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DebtSettlement&&(identical(other.id, id) || other.id == id)&&(identical(other.debtId, debtId) || other.debtId == debtId)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.transferId, transferId) || other.transferId == transferId)&&(identical(other.ledgerTransactionId, ledgerTransactionId) || other.ledgerTransactionId == ledgerTransactionId)&&(identical(other.transferReference, transferReference) || other.transferReference == transferReference)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,debtId,ownerUserId,transferId,ledgerTransactionId,transferReference,currency,amount,note,createdAt);

@override
String toString() {
  return 'DebtSettlement(id: $id, debtId: $debtId, ownerUserId: $ownerUserId, transferId: $transferId, ledgerTransactionId: $ledgerTransactionId, transferReference: $transferReference, currency: $currency, amount: $amount, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DebtSettlementCopyWith<$Res> implements $DebtSettlementCopyWith<$Res> {
  factory _$DebtSettlementCopyWith(_DebtSettlement value, $Res Function(_DebtSettlement) _then) = __$DebtSettlementCopyWithImpl;
@override @useResult
$Res call({
 String id, String debtId, String ownerUserId, String transferId, String ledgerTransactionId, String transferReference, Currency currency, String amount, String? note,@DateTimeConverter() DateTime createdAt
});




}
/// @nodoc
class __$DebtSettlementCopyWithImpl<$Res>
    implements _$DebtSettlementCopyWith<$Res> {
  __$DebtSettlementCopyWithImpl(this._self, this._then);

  final _DebtSettlement _self;
  final $Res Function(_DebtSettlement) _then;

/// Create a copy of DebtSettlement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? debtId = null,Object? ownerUserId = null,Object? transferId = null,Object? ledgerTransactionId = null,Object? transferReference = null,Object? currency = null,Object? amount = null,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_DebtSettlement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,debtId: null == debtId ? _self.debtId : debtId // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,transferId: null == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as String,ledgerTransactionId: null == ledgerTransactionId ? _self.ledgerTransactionId : ledgerTransactionId // ignore: cast_nullable_to_non_nullable
as String,transferReference: null == transferReference ? _self.transferReference : transferReference // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
