// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ledger_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LedgerTransaction {

 String get id; TransactionReference get reference; TransactionType get type; String get initiatedByUserId; String? get senderDisplayName; String? get recipientUserId; String? get recipientDisplayName; String? get sourceWalletId; String? get destinationWalletId; Currency get sourceCurrency; Currency? get destinationCurrency; String get sourceAmount; String? get destinationAmount; String? get exchangeRate; String? get note; String? get attachmentLabel; String? get transferRecordId; String? get debtSettlementId; String? get relatedTransactionId;@DateTimeConverter() DateTime get createdAt;
/// Create a copy of LedgerTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LedgerTransactionCopyWith<LedgerTransaction> get copyWith => _$LedgerTransactionCopyWithImpl<LedgerTransaction>(this as LedgerTransaction, _$identity);

  /// Serializes this LedgerTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LedgerTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.type, type) || other.type == type)&&(identical(other.initiatedByUserId, initiatedByUserId) || other.initiatedByUserId == initiatedByUserId)&&(identical(other.senderDisplayName, senderDisplayName) || other.senderDisplayName == senderDisplayName)&&(identical(other.recipientUserId, recipientUserId) || other.recipientUserId == recipientUserId)&&(identical(other.recipientDisplayName, recipientDisplayName) || other.recipientDisplayName == recipientDisplayName)&&(identical(other.sourceWalletId, sourceWalletId) || other.sourceWalletId == sourceWalletId)&&(identical(other.destinationWalletId, destinationWalletId) || other.destinationWalletId == destinationWalletId)&&(identical(other.sourceCurrency, sourceCurrency) || other.sourceCurrency == sourceCurrency)&&(identical(other.destinationCurrency, destinationCurrency) || other.destinationCurrency == destinationCurrency)&&(identical(other.sourceAmount, sourceAmount) || other.sourceAmount == sourceAmount)&&(identical(other.destinationAmount, destinationAmount) || other.destinationAmount == destinationAmount)&&(identical(other.exchangeRate, exchangeRate) || other.exchangeRate == exchangeRate)&&(identical(other.note, note) || other.note == note)&&(identical(other.attachmentLabel, attachmentLabel) || other.attachmentLabel == attachmentLabel)&&(identical(other.transferRecordId, transferRecordId) || other.transferRecordId == transferRecordId)&&(identical(other.debtSettlementId, debtSettlementId) || other.debtSettlementId == debtSettlementId)&&(identical(other.relatedTransactionId, relatedTransactionId) || other.relatedTransactionId == relatedTransactionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,reference,type,initiatedByUserId,senderDisplayName,recipientUserId,recipientDisplayName,sourceWalletId,destinationWalletId,sourceCurrency,destinationCurrency,sourceAmount,destinationAmount,exchangeRate,note,attachmentLabel,transferRecordId,debtSettlementId,relatedTransactionId,createdAt]);

@override
String toString() {
  return 'LedgerTransaction(id: $id, reference: $reference, type: $type, initiatedByUserId: $initiatedByUserId, senderDisplayName: $senderDisplayName, recipientUserId: $recipientUserId, recipientDisplayName: $recipientDisplayName, sourceWalletId: $sourceWalletId, destinationWalletId: $destinationWalletId, sourceCurrency: $sourceCurrency, destinationCurrency: $destinationCurrency, sourceAmount: $sourceAmount, destinationAmount: $destinationAmount, exchangeRate: $exchangeRate, note: $note, attachmentLabel: $attachmentLabel, transferRecordId: $transferRecordId, debtSettlementId: $debtSettlementId, relatedTransactionId: $relatedTransactionId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $LedgerTransactionCopyWith<$Res>  {
  factory $LedgerTransactionCopyWith(LedgerTransaction value, $Res Function(LedgerTransaction) _then) = _$LedgerTransactionCopyWithImpl;
@useResult
$Res call({
 String id, TransactionReference reference, TransactionType type, String initiatedByUserId, String? senderDisplayName, String? recipientUserId, String? recipientDisplayName, String? sourceWalletId, String? destinationWalletId, Currency sourceCurrency, Currency? destinationCurrency, String sourceAmount, String? destinationAmount, String? exchangeRate, String? note, String? attachmentLabel, String? transferRecordId, String? debtSettlementId, String? relatedTransactionId,@DateTimeConverter() DateTime createdAt
});


$TransactionReferenceCopyWith<$Res> get reference;

}
/// @nodoc
class _$LedgerTransactionCopyWithImpl<$Res>
    implements $LedgerTransactionCopyWith<$Res> {
  _$LedgerTransactionCopyWithImpl(this._self, this._then);

  final LedgerTransaction _self;
  final $Res Function(LedgerTransaction) _then;

/// Create a copy of LedgerTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? reference = null,Object? type = null,Object? initiatedByUserId = null,Object? senderDisplayName = freezed,Object? recipientUserId = freezed,Object? recipientDisplayName = freezed,Object? sourceWalletId = freezed,Object? destinationWalletId = freezed,Object? sourceCurrency = null,Object? destinationCurrency = freezed,Object? sourceAmount = null,Object? destinationAmount = freezed,Object? exchangeRate = freezed,Object? note = freezed,Object? attachmentLabel = freezed,Object? transferRecordId = freezed,Object? debtSettlementId = freezed,Object? relatedTransactionId = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as TransactionReference,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,initiatedByUserId: null == initiatedByUserId ? _self.initiatedByUserId : initiatedByUserId // ignore: cast_nullable_to_non_nullable
as String,senderDisplayName: freezed == senderDisplayName ? _self.senderDisplayName : senderDisplayName // ignore: cast_nullable_to_non_nullable
as String?,recipientUserId: freezed == recipientUserId ? _self.recipientUserId : recipientUserId // ignore: cast_nullable_to_non_nullable
as String?,recipientDisplayName: freezed == recipientDisplayName ? _self.recipientDisplayName : recipientDisplayName // ignore: cast_nullable_to_non_nullable
as String?,sourceWalletId: freezed == sourceWalletId ? _self.sourceWalletId : sourceWalletId // ignore: cast_nullable_to_non_nullable
as String?,destinationWalletId: freezed == destinationWalletId ? _self.destinationWalletId : destinationWalletId // ignore: cast_nullable_to_non_nullable
as String?,sourceCurrency: null == sourceCurrency ? _self.sourceCurrency : sourceCurrency // ignore: cast_nullable_to_non_nullable
as Currency,destinationCurrency: freezed == destinationCurrency ? _self.destinationCurrency : destinationCurrency // ignore: cast_nullable_to_non_nullable
as Currency?,sourceAmount: null == sourceAmount ? _self.sourceAmount : sourceAmount // ignore: cast_nullable_to_non_nullable
as String,destinationAmount: freezed == destinationAmount ? _self.destinationAmount : destinationAmount // ignore: cast_nullable_to_non_nullable
as String?,exchangeRate: freezed == exchangeRate ? _self.exchangeRate : exchangeRate // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,attachmentLabel: freezed == attachmentLabel ? _self.attachmentLabel : attachmentLabel // ignore: cast_nullable_to_non_nullable
as String?,transferRecordId: freezed == transferRecordId ? _self.transferRecordId : transferRecordId // ignore: cast_nullable_to_non_nullable
as String?,debtSettlementId: freezed == debtSettlementId ? _self.debtSettlementId : debtSettlementId // ignore: cast_nullable_to_non_nullable
as String?,relatedTransactionId: freezed == relatedTransactionId ? _self.relatedTransactionId : relatedTransactionId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of LedgerTransaction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionReferenceCopyWith<$Res> get reference {
  
  return $TransactionReferenceCopyWith<$Res>(_self.reference, (value) {
    return _then(_self.copyWith(reference: value));
  });
}
}


/// Adds pattern-matching-related methods to [LedgerTransaction].
extension LedgerTransactionPatterns on LedgerTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LedgerTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LedgerTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LedgerTransaction value)  $default,){
final _that = this;
switch (_that) {
case _LedgerTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LedgerTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _LedgerTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  TransactionReference reference,  TransactionType type,  String initiatedByUserId,  String? senderDisplayName,  String? recipientUserId,  String? recipientDisplayName,  String? sourceWalletId,  String? destinationWalletId,  Currency sourceCurrency,  Currency? destinationCurrency,  String sourceAmount,  String? destinationAmount,  String? exchangeRate,  String? note,  String? attachmentLabel,  String? transferRecordId,  String? debtSettlementId,  String? relatedTransactionId, @DateTimeConverter()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LedgerTransaction() when $default != null:
return $default(_that.id,_that.reference,_that.type,_that.initiatedByUserId,_that.senderDisplayName,_that.recipientUserId,_that.recipientDisplayName,_that.sourceWalletId,_that.destinationWalletId,_that.sourceCurrency,_that.destinationCurrency,_that.sourceAmount,_that.destinationAmount,_that.exchangeRate,_that.note,_that.attachmentLabel,_that.transferRecordId,_that.debtSettlementId,_that.relatedTransactionId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  TransactionReference reference,  TransactionType type,  String initiatedByUserId,  String? senderDisplayName,  String? recipientUserId,  String? recipientDisplayName,  String? sourceWalletId,  String? destinationWalletId,  Currency sourceCurrency,  Currency? destinationCurrency,  String sourceAmount,  String? destinationAmount,  String? exchangeRate,  String? note,  String? attachmentLabel,  String? transferRecordId,  String? debtSettlementId,  String? relatedTransactionId, @DateTimeConverter()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _LedgerTransaction():
return $default(_that.id,_that.reference,_that.type,_that.initiatedByUserId,_that.senderDisplayName,_that.recipientUserId,_that.recipientDisplayName,_that.sourceWalletId,_that.destinationWalletId,_that.sourceCurrency,_that.destinationCurrency,_that.sourceAmount,_that.destinationAmount,_that.exchangeRate,_that.note,_that.attachmentLabel,_that.transferRecordId,_that.debtSettlementId,_that.relatedTransactionId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  TransactionReference reference,  TransactionType type,  String initiatedByUserId,  String? senderDisplayName,  String? recipientUserId,  String? recipientDisplayName,  String? sourceWalletId,  String? destinationWalletId,  Currency sourceCurrency,  Currency? destinationCurrency,  String sourceAmount,  String? destinationAmount,  String? exchangeRate,  String? note,  String? attachmentLabel,  String? transferRecordId,  String? debtSettlementId,  String? relatedTransactionId, @DateTimeConverter()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _LedgerTransaction() when $default != null:
return $default(_that.id,_that.reference,_that.type,_that.initiatedByUserId,_that.senderDisplayName,_that.recipientUserId,_that.recipientDisplayName,_that.sourceWalletId,_that.destinationWalletId,_that.sourceCurrency,_that.destinationCurrency,_that.sourceAmount,_that.destinationAmount,_that.exchangeRate,_that.note,_that.attachmentLabel,_that.transferRecordId,_that.debtSettlementId,_that.relatedTransactionId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LedgerTransaction implements LedgerTransaction {
  const _LedgerTransaction({required this.id, required this.reference, required this.type, required this.initiatedByUserId, this.senderDisplayName, this.recipientUserId, this.recipientDisplayName, this.sourceWalletId, this.destinationWalletId, required this.sourceCurrency, this.destinationCurrency, required this.sourceAmount, this.destinationAmount, this.exchangeRate, this.note, this.attachmentLabel, this.transferRecordId, this.debtSettlementId, this.relatedTransactionId, @DateTimeConverter() required this.createdAt});
  factory _LedgerTransaction.fromJson(Map<String, dynamic> json) => _$LedgerTransactionFromJson(json);

@override final  String id;
@override final  TransactionReference reference;
@override final  TransactionType type;
@override final  String initiatedByUserId;
@override final  String? senderDisplayName;
@override final  String? recipientUserId;
@override final  String? recipientDisplayName;
@override final  String? sourceWalletId;
@override final  String? destinationWalletId;
@override final  Currency sourceCurrency;
@override final  Currency? destinationCurrency;
@override final  String sourceAmount;
@override final  String? destinationAmount;
@override final  String? exchangeRate;
@override final  String? note;
@override final  String? attachmentLabel;
@override final  String? transferRecordId;
@override final  String? debtSettlementId;
@override final  String? relatedTransactionId;
@override@DateTimeConverter() final  DateTime createdAt;

/// Create a copy of LedgerTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LedgerTransactionCopyWith<_LedgerTransaction> get copyWith => __$LedgerTransactionCopyWithImpl<_LedgerTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LedgerTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LedgerTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.type, type) || other.type == type)&&(identical(other.initiatedByUserId, initiatedByUserId) || other.initiatedByUserId == initiatedByUserId)&&(identical(other.senderDisplayName, senderDisplayName) || other.senderDisplayName == senderDisplayName)&&(identical(other.recipientUserId, recipientUserId) || other.recipientUserId == recipientUserId)&&(identical(other.recipientDisplayName, recipientDisplayName) || other.recipientDisplayName == recipientDisplayName)&&(identical(other.sourceWalletId, sourceWalletId) || other.sourceWalletId == sourceWalletId)&&(identical(other.destinationWalletId, destinationWalletId) || other.destinationWalletId == destinationWalletId)&&(identical(other.sourceCurrency, sourceCurrency) || other.sourceCurrency == sourceCurrency)&&(identical(other.destinationCurrency, destinationCurrency) || other.destinationCurrency == destinationCurrency)&&(identical(other.sourceAmount, sourceAmount) || other.sourceAmount == sourceAmount)&&(identical(other.destinationAmount, destinationAmount) || other.destinationAmount == destinationAmount)&&(identical(other.exchangeRate, exchangeRate) || other.exchangeRate == exchangeRate)&&(identical(other.note, note) || other.note == note)&&(identical(other.attachmentLabel, attachmentLabel) || other.attachmentLabel == attachmentLabel)&&(identical(other.transferRecordId, transferRecordId) || other.transferRecordId == transferRecordId)&&(identical(other.debtSettlementId, debtSettlementId) || other.debtSettlementId == debtSettlementId)&&(identical(other.relatedTransactionId, relatedTransactionId) || other.relatedTransactionId == relatedTransactionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,reference,type,initiatedByUserId,senderDisplayName,recipientUserId,recipientDisplayName,sourceWalletId,destinationWalletId,sourceCurrency,destinationCurrency,sourceAmount,destinationAmount,exchangeRate,note,attachmentLabel,transferRecordId,debtSettlementId,relatedTransactionId,createdAt]);

@override
String toString() {
  return 'LedgerTransaction(id: $id, reference: $reference, type: $type, initiatedByUserId: $initiatedByUserId, senderDisplayName: $senderDisplayName, recipientUserId: $recipientUserId, recipientDisplayName: $recipientDisplayName, sourceWalletId: $sourceWalletId, destinationWalletId: $destinationWalletId, sourceCurrency: $sourceCurrency, destinationCurrency: $destinationCurrency, sourceAmount: $sourceAmount, destinationAmount: $destinationAmount, exchangeRate: $exchangeRate, note: $note, attachmentLabel: $attachmentLabel, transferRecordId: $transferRecordId, debtSettlementId: $debtSettlementId, relatedTransactionId: $relatedTransactionId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$LedgerTransactionCopyWith<$Res> implements $LedgerTransactionCopyWith<$Res> {
  factory _$LedgerTransactionCopyWith(_LedgerTransaction value, $Res Function(_LedgerTransaction) _then) = __$LedgerTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, TransactionReference reference, TransactionType type, String initiatedByUserId, String? senderDisplayName, String? recipientUserId, String? recipientDisplayName, String? sourceWalletId, String? destinationWalletId, Currency sourceCurrency, Currency? destinationCurrency, String sourceAmount, String? destinationAmount, String? exchangeRate, String? note, String? attachmentLabel, String? transferRecordId, String? debtSettlementId, String? relatedTransactionId,@DateTimeConverter() DateTime createdAt
});


@override $TransactionReferenceCopyWith<$Res> get reference;

}
/// @nodoc
class __$LedgerTransactionCopyWithImpl<$Res>
    implements _$LedgerTransactionCopyWith<$Res> {
  __$LedgerTransactionCopyWithImpl(this._self, this._then);

  final _LedgerTransaction _self;
  final $Res Function(_LedgerTransaction) _then;

/// Create a copy of LedgerTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? reference = null,Object? type = null,Object? initiatedByUserId = null,Object? senderDisplayName = freezed,Object? recipientUserId = freezed,Object? recipientDisplayName = freezed,Object? sourceWalletId = freezed,Object? destinationWalletId = freezed,Object? sourceCurrency = null,Object? destinationCurrency = freezed,Object? sourceAmount = null,Object? destinationAmount = freezed,Object? exchangeRate = freezed,Object? note = freezed,Object? attachmentLabel = freezed,Object? transferRecordId = freezed,Object? debtSettlementId = freezed,Object? relatedTransactionId = freezed,Object? createdAt = null,}) {
  return _then(_LedgerTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as TransactionReference,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,initiatedByUserId: null == initiatedByUserId ? _self.initiatedByUserId : initiatedByUserId // ignore: cast_nullable_to_non_nullable
as String,senderDisplayName: freezed == senderDisplayName ? _self.senderDisplayName : senderDisplayName // ignore: cast_nullable_to_non_nullable
as String?,recipientUserId: freezed == recipientUserId ? _self.recipientUserId : recipientUserId // ignore: cast_nullable_to_non_nullable
as String?,recipientDisplayName: freezed == recipientDisplayName ? _self.recipientDisplayName : recipientDisplayName // ignore: cast_nullable_to_non_nullable
as String?,sourceWalletId: freezed == sourceWalletId ? _self.sourceWalletId : sourceWalletId // ignore: cast_nullable_to_non_nullable
as String?,destinationWalletId: freezed == destinationWalletId ? _self.destinationWalletId : destinationWalletId // ignore: cast_nullable_to_non_nullable
as String?,sourceCurrency: null == sourceCurrency ? _self.sourceCurrency : sourceCurrency // ignore: cast_nullable_to_non_nullable
as Currency,destinationCurrency: freezed == destinationCurrency ? _self.destinationCurrency : destinationCurrency // ignore: cast_nullable_to_non_nullable
as Currency?,sourceAmount: null == sourceAmount ? _self.sourceAmount : sourceAmount // ignore: cast_nullable_to_non_nullable
as String,destinationAmount: freezed == destinationAmount ? _self.destinationAmount : destinationAmount // ignore: cast_nullable_to_non_nullable
as String?,exchangeRate: freezed == exchangeRate ? _self.exchangeRate : exchangeRate // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,attachmentLabel: freezed == attachmentLabel ? _self.attachmentLabel : attachmentLabel // ignore: cast_nullable_to_non_nullable
as String?,transferRecordId: freezed == transferRecordId ? _self.transferRecordId : transferRecordId // ignore: cast_nullable_to_non_nullable
as String?,debtSettlementId: freezed == debtSettlementId ? _self.debtSettlementId : debtSettlementId // ignore: cast_nullable_to_non_nullable
as String?,relatedTransactionId: freezed == relatedTransactionId ? _self.relatedTransactionId : relatedTransactionId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of LedgerTransaction
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
