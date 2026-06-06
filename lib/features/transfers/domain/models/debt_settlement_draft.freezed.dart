// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt_settlement_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DebtSettlementDraft {

 String get debtId; String get debtContactName; String get senderWalletId; String get senderWalletName; String get recipientUserId; String get recipientDisplayName; Currency get currency; String get amount; String get remainingAmountBeforeSettlement; String? get note;
/// Create a copy of DebtSettlementDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtSettlementDraftCopyWith<DebtSettlementDraft> get copyWith => _$DebtSettlementDraftCopyWithImpl<DebtSettlementDraft>(this as DebtSettlementDraft, _$identity);

  /// Serializes this DebtSettlementDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtSettlementDraft&&(identical(other.debtId, debtId) || other.debtId == debtId)&&(identical(other.debtContactName, debtContactName) || other.debtContactName == debtContactName)&&(identical(other.senderWalletId, senderWalletId) || other.senderWalletId == senderWalletId)&&(identical(other.senderWalletName, senderWalletName) || other.senderWalletName == senderWalletName)&&(identical(other.recipientUserId, recipientUserId) || other.recipientUserId == recipientUserId)&&(identical(other.recipientDisplayName, recipientDisplayName) || other.recipientDisplayName == recipientDisplayName)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.remainingAmountBeforeSettlement, remainingAmountBeforeSettlement) || other.remainingAmountBeforeSettlement == remainingAmountBeforeSettlement)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,debtId,debtContactName,senderWalletId,senderWalletName,recipientUserId,recipientDisplayName,currency,amount,remainingAmountBeforeSettlement,note);

@override
String toString() {
  return 'DebtSettlementDraft(debtId: $debtId, debtContactName: $debtContactName, senderWalletId: $senderWalletId, senderWalletName: $senderWalletName, recipientUserId: $recipientUserId, recipientDisplayName: $recipientDisplayName, currency: $currency, amount: $amount, remainingAmountBeforeSettlement: $remainingAmountBeforeSettlement, note: $note)';
}


}

/// @nodoc
abstract mixin class $DebtSettlementDraftCopyWith<$Res>  {
  factory $DebtSettlementDraftCopyWith(DebtSettlementDraft value, $Res Function(DebtSettlementDraft) _then) = _$DebtSettlementDraftCopyWithImpl;
@useResult
$Res call({
 String debtId, String debtContactName, String senderWalletId, String senderWalletName, String recipientUserId, String recipientDisplayName, Currency currency, String amount, String remainingAmountBeforeSettlement, String? note
});




}
/// @nodoc
class _$DebtSettlementDraftCopyWithImpl<$Res>
    implements $DebtSettlementDraftCopyWith<$Res> {
  _$DebtSettlementDraftCopyWithImpl(this._self, this._then);

  final DebtSettlementDraft _self;
  final $Res Function(DebtSettlementDraft) _then;

/// Create a copy of DebtSettlementDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? debtId = null,Object? debtContactName = null,Object? senderWalletId = null,Object? senderWalletName = null,Object? recipientUserId = null,Object? recipientDisplayName = null,Object? currency = null,Object? amount = null,Object? remainingAmountBeforeSettlement = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
debtId: null == debtId ? _self.debtId : debtId // ignore: cast_nullable_to_non_nullable
as String,debtContactName: null == debtContactName ? _self.debtContactName : debtContactName // ignore: cast_nullable_to_non_nullable
as String,senderWalletId: null == senderWalletId ? _self.senderWalletId : senderWalletId // ignore: cast_nullable_to_non_nullable
as String,senderWalletName: null == senderWalletName ? _self.senderWalletName : senderWalletName // ignore: cast_nullable_to_non_nullable
as String,recipientUserId: null == recipientUserId ? _self.recipientUserId : recipientUserId // ignore: cast_nullable_to_non_nullable
as String,recipientDisplayName: null == recipientDisplayName ? _self.recipientDisplayName : recipientDisplayName // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,remainingAmountBeforeSettlement: null == remainingAmountBeforeSettlement ? _self.remainingAmountBeforeSettlement : remainingAmountBeforeSettlement // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DebtSettlementDraft].
extension DebtSettlementDraftPatterns on DebtSettlementDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DebtSettlementDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DebtSettlementDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DebtSettlementDraft value)  $default,){
final _that = this;
switch (_that) {
case _DebtSettlementDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DebtSettlementDraft value)?  $default,){
final _that = this;
switch (_that) {
case _DebtSettlementDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String debtId,  String debtContactName,  String senderWalletId,  String senderWalletName,  String recipientUserId,  String recipientDisplayName,  Currency currency,  String amount,  String remainingAmountBeforeSettlement,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DebtSettlementDraft() when $default != null:
return $default(_that.debtId,_that.debtContactName,_that.senderWalletId,_that.senderWalletName,_that.recipientUserId,_that.recipientDisplayName,_that.currency,_that.amount,_that.remainingAmountBeforeSettlement,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String debtId,  String debtContactName,  String senderWalletId,  String senderWalletName,  String recipientUserId,  String recipientDisplayName,  Currency currency,  String amount,  String remainingAmountBeforeSettlement,  String? note)  $default,) {final _that = this;
switch (_that) {
case _DebtSettlementDraft():
return $default(_that.debtId,_that.debtContactName,_that.senderWalletId,_that.senderWalletName,_that.recipientUserId,_that.recipientDisplayName,_that.currency,_that.amount,_that.remainingAmountBeforeSettlement,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String debtId,  String debtContactName,  String senderWalletId,  String senderWalletName,  String recipientUserId,  String recipientDisplayName,  Currency currency,  String amount,  String remainingAmountBeforeSettlement,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _DebtSettlementDraft() when $default != null:
return $default(_that.debtId,_that.debtContactName,_that.senderWalletId,_that.senderWalletName,_that.recipientUserId,_that.recipientDisplayName,_that.currency,_that.amount,_that.remainingAmountBeforeSettlement,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DebtSettlementDraft implements DebtSettlementDraft {
  const _DebtSettlementDraft({required this.debtId, required this.debtContactName, required this.senderWalletId, required this.senderWalletName, required this.recipientUserId, required this.recipientDisplayName, required this.currency, required this.amount, required this.remainingAmountBeforeSettlement, this.note});
  factory _DebtSettlementDraft.fromJson(Map<String, dynamic> json) => _$DebtSettlementDraftFromJson(json);

@override final  String debtId;
@override final  String debtContactName;
@override final  String senderWalletId;
@override final  String senderWalletName;
@override final  String recipientUserId;
@override final  String recipientDisplayName;
@override final  Currency currency;
@override final  String amount;
@override final  String remainingAmountBeforeSettlement;
@override final  String? note;

/// Create a copy of DebtSettlementDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtSettlementDraftCopyWith<_DebtSettlementDraft> get copyWith => __$DebtSettlementDraftCopyWithImpl<_DebtSettlementDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DebtSettlementDraftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DebtSettlementDraft&&(identical(other.debtId, debtId) || other.debtId == debtId)&&(identical(other.debtContactName, debtContactName) || other.debtContactName == debtContactName)&&(identical(other.senderWalletId, senderWalletId) || other.senderWalletId == senderWalletId)&&(identical(other.senderWalletName, senderWalletName) || other.senderWalletName == senderWalletName)&&(identical(other.recipientUserId, recipientUserId) || other.recipientUserId == recipientUserId)&&(identical(other.recipientDisplayName, recipientDisplayName) || other.recipientDisplayName == recipientDisplayName)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.remainingAmountBeforeSettlement, remainingAmountBeforeSettlement) || other.remainingAmountBeforeSettlement == remainingAmountBeforeSettlement)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,debtId,debtContactName,senderWalletId,senderWalletName,recipientUserId,recipientDisplayName,currency,amount,remainingAmountBeforeSettlement,note);

@override
String toString() {
  return 'DebtSettlementDraft(debtId: $debtId, debtContactName: $debtContactName, senderWalletId: $senderWalletId, senderWalletName: $senderWalletName, recipientUserId: $recipientUserId, recipientDisplayName: $recipientDisplayName, currency: $currency, amount: $amount, remainingAmountBeforeSettlement: $remainingAmountBeforeSettlement, note: $note)';
}


}

/// @nodoc
abstract mixin class _$DebtSettlementDraftCopyWith<$Res> implements $DebtSettlementDraftCopyWith<$Res> {
  factory _$DebtSettlementDraftCopyWith(_DebtSettlementDraft value, $Res Function(_DebtSettlementDraft) _then) = __$DebtSettlementDraftCopyWithImpl;
@override @useResult
$Res call({
 String debtId, String debtContactName, String senderWalletId, String senderWalletName, String recipientUserId, String recipientDisplayName, Currency currency, String amount, String remainingAmountBeforeSettlement, String? note
});




}
/// @nodoc
class __$DebtSettlementDraftCopyWithImpl<$Res>
    implements _$DebtSettlementDraftCopyWith<$Res> {
  __$DebtSettlementDraftCopyWithImpl(this._self, this._then);

  final _DebtSettlementDraft _self;
  final $Res Function(_DebtSettlementDraft) _then;

/// Create a copy of DebtSettlementDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? debtId = null,Object? debtContactName = null,Object? senderWalletId = null,Object? senderWalletName = null,Object? recipientUserId = null,Object? recipientDisplayName = null,Object? currency = null,Object? amount = null,Object? remainingAmountBeforeSettlement = null,Object? note = freezed,}) {
  return _then(_DebtSettlementDraft(
debtId: null == debtId ? _self.debtId : debtId // ignore: cast_nullable_to_non_nullable
as String,debtContactName: null == debtContactName ? _self.debtContactName : debtContactName // ignore: cast_nullable_to_non_nullable
as String,senderWalletId: null == senderWalletId ? _self.senderWalletId : senderWalletId // ignore: cast_nullable_to_non_nullable
as String,senderWalletName: null == senderWalletName ? _self.senderWalletName : senderWalletName // ignore: cast_nullable_to_non_nullable
as String,recipientUserId: null == recipientUserId ? _self.recipientUserId : recipientUserId // ignore: cast_nullable_to_non_nullable
as String,recipientDisplayName: null == recipientDisplayName ? _self.recipientDisplayName : recipientDisplayName // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,remainingAmountBeforeSettlement: null == remainingAmountBeforeSettlement ? _self.remainingAmountBeforeSettlement : remainingAmountBeforeSettlement // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
