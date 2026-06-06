// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_transfer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserTransfer {

 String get id; String get ownerUserId; TransactionReference get reference; String get senderUserId; String get senderDisplayName; String get recipientUserId; String get recipientDisplayName; String get senderWalletId; String get recipientWalletId; Currency get currency; String get amount; String? get note; String get ledgerTransactionId; String? get mirroredLedgerTransactionId; String? get linkedDebtSettlementId;@DateTimeConverter() DateTime get createdAt;
/// Create a copy of UserTransfer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserTransferCopyWith<UserTransfer> get copyWith => _$UserTransferCopyWithImpl<UserTransfer>(this as UserTransfer, _$identity);

  /// Serializes this UserTransfer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserTransfer&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.senderUserId, senderUserId) || other.senderUserId == senderUserId)&&(identical(other.senderDisplayName, senderDisplayName) || other.senderDisplayName == senderDisplayName)&&(identical(other.recipientUserId, recipientUserId) || other.recipientUserId == recipientUserId)&&(identical(other.recipientDisplayName, recipientDisplayName) || other.recipientDisplayName == recipientDisplayName)&&(identical(other.senderWalletId, senderWalletId) || other.senderWalletId == senderWalletId)&&(identical(other.recipientWalletId, recipientWalletId) || other.recipientWalletId == recipientWalletId)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.note, note) || other.note == note)&&(identical(other.ledgerTransactionId, ledgerTransactionId) || other.ledgerTransactionId == ledgerTransactionId)&&(identical(other.mirroredLedgerTransactionId, mirroredLedgerTransactionId) || other.mirroredLedgerTransactionId == mirroredLedgerTransactionId)&&(identical(other.linkedDebtSettlementId, linkedDebtSettlementId) || other.linkedDebtSettlementId == linkedDebtSettlementId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUserId,reference,senderUserId,senderDisplayName,recipientUserId,recipientDisplayName,senderWalletId,recipientWalletId,currency,amount,note,ledgerTransactionId,mirroredLedgerTransactionId,linkedDebtSettlementId,createdAt);

@override
String toString() {
  return 'UserTransfer(id: $id, ownerUserId: $ownerUserId, reference: $reference, senderUserId: $senderUserId, senderDisplayName: $senderDisplayName, recipientUserId: $recipientUserId, recipientDisplayName: $recipientDisplayName, senderWalletId: $senderWalletId, recipientWalletId: $recipientWalletId, currency: $currency, amount: $amount, note: $note, ledgerTransactionId: $ledgerTransactionId, mirroredLedgerTransactionId: $mirroredLedgerTransactionId, linkedDebtSettlementId: $linkedDebtSettlementId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $UserTransferCopyWith<$Res>  {
  factory $UserTransferCopyWith(UserTransfer value, $Res Function(UserTransfer) _then) = _$UserTransferCopyWithImpl;
@useResult
$Res call({
 String id, String ownerUserId, TransactionReference reference, String senderUserId, String senderDisplayName, String recipientUserId, String recipientDisplayName, String senderWalletId, String recipientWalletId, Currency currency, String amount, String? note, String ledgerTransactionId, String? mirroredLedgerTransactionId, String? linkedDebtSettlementId,@DateTimeConverter() DateTime createdAt
});


$TransactionReferenceCopyWith<$Res> get reference;

}
/// @nodoc
class _$UserTransferCopyWithImpl<$Res>
    implements $UserTransferCopyWith<$Res> {
  _$UserTransferCopyWithImpl(this._self, this._then);

  final UserTransfer _self;
  final $Res Function(UserTransfer) _then;

/// Create a copy of UserTransfer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerUserId = null,Object? reference = null,Object? senderUserId = null,Object? senderDisplayName = null,Object? recipientUserId = null,Object? recipientDisplayName = null,Object? senderWalletId = null,Object? recipientWalletId = null,Object? currency = null,Object? amount = null,Object? note = freezed,Object? ledgerTransactionId = null,Object? mirroredLedgerTransactionId = freezed,Object? linkedDebtSettlementId = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as TransactionReference,senderUserId: null == senderUserId ? _self.senderUserId : senderUserId // ignore: cast_nullable_to_non_nullable
as String,senderDisplayName: null == senderDisplayName ? _self.senderDisplayName : senderDisplayName // ignore: cast_nullable_to_non_nullable
as String,recipientUserId: null == recipientUserId ? _self.recipientUserId : recipientUserId // ignore: cast_nullable_to_non_nullable
as String,recipientDisplayName: null == recipientDisplayName ? _self.recipientDisplayName : recipientDisplayName // ignore: cast_nullable_to_non_nullable
as String,senderWalletId: null == senderWalletId ? _self.senderWalletId : senderWalletId // ignore: cast_nullable_to_non_nullable
as String,recipientWalletId: null == recipientWalletId ? _self.recipientWalletId : recipientWalletId // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,ledgerTransactionId: null == ledgerTransactionId ? _self.ledgerTransactionId : ledgerTransactionId // ignore: cast_nullable_to_non_nullable
as String,mirroredLedgerTransactionId: freezed == mirroredLedgerTransactionId ? _self.mirroredLedgerTransactionId : mirroredLedgerTransactionId // ignore: cast_nullable_to_non_nullable
as String?,linkedDebtSettlementId: freezed == linkedDebtSettlementId ? _self.linkedDebtSettlementId : linkedDebtSettlementId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of UserTransfer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionReferenceCopyWith<$Res> get reference {
  
  return $TransactionReferenceCopyWith<$Res>(_self.reference, (value) {
    return _then(_self.copyWith(reference: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserTransfer].
extension UserTransferPatterns on UserTransfer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserTransfer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserTransfer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserTransfer value)  $default,){
final _that = this;
switch (_that) {
case _UserTransfer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserTransfer value)?  $default,){
final _that = this;
switch (_that) {
case _UserTransfer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerUserId,  TransactionReference reference,  String senderUserId,  String senderDisplayName,  String recipientUserId,  String recipientDisplayName,  String senderWalletId,  String recipientWalletId,  Currency currency,  String amount,  String? note,  String ledgerTransactionId,  String? mirroredLedgerTransactionId,  String? linkedDebtSettlementId, @DateTimeConverter()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserTransfer() when $default != null:
return $default(_that.id,_that.ownerUserId,_that.reference,_that.senderUserId,_that.senderDisplayName,_that.recipientUserId,_that.recipientDisplayName,_that.senderWalletId,_that.recipientWalletId,_that.currency,_that.amount,_that.note,_that.ledgerTransactionId,_that.mirroredLedgerTransactionId,_that.linkedDebtSettlementId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerUserId,  TransactionReference reference,  String senderUserId,  String senderDisplayName,  String recipientUserId,  String recipientDisplayName,  String senderWalletId,  String recipientWalletId,  Currency currency,  String amount,  String? note,  String ledgerTransactionId,  String? mirroredLedgerTransactionId,  String? linkedDebtSettlementId, @DateTimeConverter()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _UserTransfer():
return $default(_that.id,_that.ownerUserId,_that.reference,_that.senderUserId,_that.senderDisplayName,_that.recipientUserId,_that.recipientDisplayName,_that.senderWalletId,_that.recipientWalletId,_that.currency,_that.amount,_that.note,_that.ledgerTransactionId,_that.mirroredLedgerTransactionId,_that.linkedDebtSettlementId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerUserId,  TransactionReference reference,  String senderUserId,  String senderDisplayName,  String recipientUserId,  String recipientDisplayName,  String senderWalletId,  String recipientWalletId,  Currency currency,  String amount,  String? note,  String ledgerTransactionId,  String? mirroredLedgerTransactionId,  String? linkedDebtSettlementId, @DateTimeConverter()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _UserTransfer() when $default != null:
return $default(_that.id,_that.ownerUserId,_that.reference,_that.senderUserId,_that.senderDisplayName,_that.recipientUserId,_that.recipientDisplayName,_that.senderWalletId,_that.recipientWalletId,_that.currency,_that.amount,_that.note,_that.ledgerTransactionId,_that.mirroredLedgerTransactionId,_that.linkedDebtSettlementId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserTransfer implements UserTransfer {
  const _UserTransfer({required this.id, required this.ownerUserId, required this.reference, required this.senderUserId, required this.senderDisplayName, required this.recipientUserId, required this.recipientDisplayName, required this.senderWalletId, required this.recipientWalletId, required this.currency, required this.amount, this.note, required this.ledgerTransactionId, this.mirroredLedgerTransactionId, this.linkedDebtSettlementId, @DateTimeConverter() required this.createdAt});
  factory _UserTransfer.fromJson(Map<String, dynamic> json) => _$UserTransferFromJson(json);

@override final  String id;
@override final  String ownerUserId;
@override final  TransactionReference reference;
@override final  String senderUserId;
@override final  String senderDisplayName;
@override final  String recipientUserId;
@override final  String recipientDisplayName;
@override final  String senderWalletId;
@override final  String recipientWalletId;
@override final  Currency currency;
@override final  String amount;
@override final  String? note;
@override final  String ledgerTransactionId;
@override final  String? mirroredLedgerTransactionId;
@override final  String? linkedDebtSettlementId;
@override@DateTimeConverter() final  DateTime createdAt;

/// Create a copy of UserTransfer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserTransferCopyWith<_UserTransfer> get copyWith => __$UserTransferCopyWithImpl<_UserTransfer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserTransferToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserTransfer&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.senderUserId, senderUserId) || other.senderUserId == senderUserId)&&(identical(other.senderDisplayName, senderDisplayName) || other.senderDisplayName == senderDisplayName)&&(identical(other.recipientUserId, recipientUserId) || other.recipientUserId == recipientUserId)&&(identical(other.recipientDisplayName, recipientDisplayName) || other.recipientDisplayName == recipientDisplayName)&&(identical(other.senderWalletId, senderWalletId) || other.senderWalletId == senderWalletId)&&(identical(other.recipientWalletId, recipientWalletId) || other.recipientWalletId == recipientWalletId)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.note, note) || other.note == note)&&(identical(other.ledgerTransactionId, ledgerTransactionId) || other.ledgerTransactionId == ledgerTransactionId)&&(identical(other.mirroredLedgerTransactionId, mirroredLedgerTransactionId) || other.mirroredLedgerTransactionId == mirroredLedgerTransactionId)&&(identical(other.linkedDebtSettlementId, linkedDebtSettlementId) || other.linkedDebtSettlementId == linkedDebtSettlementId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUserId,reference,senderUserId,senderDisplayName,recipientUserId,recipientDisplayName,senderWalletId,recipientWalletId,currency,amount,note,ledgerTransactionId,mirroredLedgerTransactionId,linkedDebtSettlementId,createdAt);

@override
String toString() {
  return 'UserTransfer(id: $id, ownerUserId: $ownerUserId, reference: $reference, senderUserId: $senderUserId, senderDisplayName: $senderDisplayName, recipientUserId: $recipientUserId, recipientDisplayName: $recipientDisplayName, senderWalletId: $senderWalletId, recipientWalletId: $recipientWalletId, currency: $currency, amount: $amount, note: $note, ledgerTransactionId: $ledgerTransactionId, mirroredLedgerTransactionId: $mirroredLedgerTransactionId, linkedDebtSettlementId: $linkedDebtSettlementId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UserTransferCopyWith<$Res> implements $UserTransferCopyWith<$Res> {
  factory _$UserTransferCopyWith(_UserTransfer value, $Res Function(_UserTransfer) _then) = __$UserTransferCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerUserId, TransactionReference reference, String senderUserId, String senderDisplayName, String recipientUserId, String recipientDisplayName, String senderWalletId, String recipientWalletId, Currency currency, String amount, String? note, String ledgerTransactionId, String? mirroredLedgerTransactionId, String? linkedDebtSettlementId,@DateTimeConverter() DateTime createdAt
});


@override $TransactionReferenceCopyWith<$Res> get reference;

}
/// @nodoc
class __$UserTransferCopyWithImpl<$Res>
    implements _$UserTransferCopyWith<$Res> {
  __$UserTransferCopyWithImpl(this._self, this._then);

  final _UserTransfer _self;
  final $Res Function(_UserTransfer) _then;

/// Create a copy of UserTransfer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerUserId = null,Object? reference = null,Object? senderUserId = null,Object? senderDisplayName = null,Object? recipientUserId = null,Object? recipientDisplayName = null,Object? senderWalletId = null,Object? recipientWalletId = null,Object? currency = null,Object? amount = null,Object? note = freezed,Object? ledgerTransactionId = null,Object? mirroredLedgerTransactionId = freezed,Object? linkedDebtSettlementId = freezed,Object? createdAt = null,}) {
  return _then(_UserTransfer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as TransactionReference,senderUserId: null == senderUserId ? _self.senderUserId : senderUserId // ignore: cast_nullable_to_non_nullable
as String,senderDisplayName: null == senderDisplayName ? _self.senderDisplayName : senderDisplayName // ignore: cast_nullable_to_non_nullable
as String,recipientUserId: null == recipientUserId ? _self.recipientUserId : recipientUserId // ignore: cast_nullable_to_non_nullable
as String,recipientDisplayName: null == recipientDisplayName ? _self.recipientDisplayName : recipientDisplayName // ignore: cast_nullable_to_non_nullable
as String,senderWalletId: null == senderWalletId ? _self.senderWalletId : senderWalletId // ignore: cast_nullable_to_non_nullable
as String,recipientWalletId: null == recipientWalletId ? _self.recipientWalletId : recipientWalletId // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,ledgerTransactionId: null == ledgerTransactionId ? _self.ledgerTransactionId : ledgerTransactionId // ignore: cast_nullable_to_non_nullable
as String,mirroredLedgerTransactionId: freezed == mirroredLedgerTransactionId ? _self.mirroredLedgerTransactionId : mirroredLedgerTransactionId // ignore: cast_nullable_to_non_nullable
as String?,linkedDebtSettlementId: freezed == linkedDebtSettlementId ? _self.linkedDebtSettlementId : linkedDebtSettlementId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of UserTransfer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionReferenceCopyWith<$Res> get reference {
  
  return $TransactionReferenceCopyWith<$Res>(_self.reference, (value) {
    return _then(_self.copyWith(reference: value));
  });
}
}

// dart format on
