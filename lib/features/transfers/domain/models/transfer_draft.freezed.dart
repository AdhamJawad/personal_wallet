// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransferDraft {

 String get senderWalletId; String get senderWalletName; String get recipientUserId; String get recipientDisplayName; Currency get currency; String get amount; String? get note;
/// Create a copy of TransferDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferDraftCopyWith<TransferDraft> get copyWith => _$TransferDraftCopyWithImpl<TransferDraft>(this as TransferDraft, _$identity);

  /// Serializes this TransferDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferDraft&&(identical(other.senderWalletId, senderWalletId) || other.senderWalletId == senderWalletId)&&(identical(other.senderWalletName, senderWalletName) || other.senderWalletName == senderWalletName)&&(identical(other.recipientUserId, recipientUserId) || other.recipientUserId == recipientUserId)&&(identical(other.recipientDisplayName, recipientDisplayName) || other.recipientDisplayName == recipientDisplayName)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,senderWalletId,senderWalletName,recipientUserId,recipientDisplayName,currency,amount,note);

@override
String toString() {
  return 'TransferDraft(senderWalletId: $senderWalletId, senderWalletName: $senderWalletName, recipientUserId: $recipientUserId, recipientDisplayName: $recipientDisplayName, currency: $currency, amount: $amount, note: $note)';
}


}

/// @nodoc
abstract mixin class $TransferDraftCopyWith<$Res>  {
  factory $TransferDraftCopyWith(TransferDraft value, $Res Function(TransferDraft) _then) = _$TransferDraftCopyWithImpl;
@useResult
$Res call({
 String senderWalletId, String senderWalletName, String recipientUserId, String recipientDisplayName, Currency currency, String amount, String? note
});




}
/// @nodoc
class _$TransferDraftCopyWithImpl<$Res>
    implements $TransferDraftCopyWith<$Res> {
  _$TransferDraftCopyWithImpl(this._self, this._then);

  final TransferDraft _self;
  final $Res Function(TransferDraft) _then;

/// Create a copy of TransferDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? senderWalletId = null,Object? senderWalletName = null,Object? recipientUserId = null,Object? recipientDisplayName = null,Object? currency = null,Object? amount = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
senderWalletId: null == senderWalletId ? _self.senderWalletId : senderWalletId // ignore: cast_nullable_to_non_nullable
as String,senderWalletName: null == senderWalletName ? _self.senderWalletName : senderWalletName // ignore: cast_nullable_to_non_nullable
as String,recipientUserId: null == recipientUserId ? _self.recipientUserId : recipientUserId // ignore: cast_nullable_to_non_nullable
as String,recipientDisplayName: null == recipientDisplayName ? _self.recipientDisplayName : recipientDisplayName // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferDraft].
extension TransferDraftPatterns on TransferDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferDraft value)  $default,){
final _that = this;
switch (_that) {
case _TransferDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferDraft value)?  $default,){
final _that = this;
switch (_that) {
case _TransferDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String senderWalletId,  String senderWalletName,  String recipientUserId,  String recipientDisplayName,  Currency currency,  String amount,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferDraft() when $default != null:
return $default(_that.senderWalletId,_that.senderWalletName,_that.recipientUserId,_that.recipientDisplayName,_that.currency,_that.amount,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String senderWalletId,  String senderWalletName,  String recipientUserId,  String recipientDisplayName,  Currency currency,  String amount,  String? note)  $default,) {final _that = this;
switch (_that) {
case _TransferDraft():
return $default(_that.senderWalletId,_that.senderWalletName,_that.recipientUserId,_that.recipientDisplayName,_that.currency,_that.amount,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String senderWalletId,  String senderWalletName,  String recipientUserId,  String recipientDisplayName,  Currency currency,  String amount,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _TransferDraft() when $default != null:
return $default(_that.senderWalletId,_that.senderWalletName,_that.recipientUserId,_that.recipientDisplayName,_that.currency,_that.amount,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransferDraft implements TransferDraft {
  const _TransferDraft({required this.senderWalletId, required this.senderWalletName, required this.recipientUserId, required this.recipientDisplayName, required this.currency, required this.amount, this.note});
  factory _TransferDraft.fromJson(Map<String, dynamic> json) => _$TransferDraftFromJson(json);

@override final  String senderWalletId;
@override final  String senderWalletName;
@override final  String recipientUserId;
@override final  String recipientDisplayName;
@override final  Currency currency;
@override final  String amount;
@override final  String? note;

/// Create a copy of TransferDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferDraftCopyWith<_TransferDraft> get copyWith => __$TransferDraftCopyWithImpl<_TransferDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferDraftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferDraft&&(identical(other.senderWalletId, senderWalletId) || other.senderWalletId == senderWalletId)&&(identical(other.senderWalletName, senderWalletName) || other.senderWalletName == senderWalletName)&&(identical(other.recipientUserId, recipientUserId) || other.recipientUserId == recipientUserId)&&(identical(other.recipientDisplayName, recipientDisplayName) || other.recipientDisplayName == recipientDisplayName)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,senderWalletId,senderWalletName,recipientUserId,recipientDisplayName,currency,amount,note);

@override
String toString() {
  return 'TransferDraft(senderWalletId: $senderWalletId, senderWalletName: $senderWalletName, recipientUserId: $recipientUserId, recipientDisplayName: $recipientDisplayName, currency: $currency, amount: $amount, note: $note)';
}


}

/// @nodoc
abstract mixin class _$TransferDraftCopyWith<$Res> implements $TransferDraftCopyWith<$Res> {
  factory _$TransferDraftCopyWith(_TransferDraft value, $Res Function(_TransferDraft) _then) = __$TransferDraftCopyWithImpl;
@override @useResult
$Res call({
 String senderWalletId, String senderWalletName, String recipientUserId, String recipientDisplayName, Currency currency, String amount, String? note
});




}
/// @nodoc
class __$TransferDraftCopyWithImpl<$Res>
    implements _$TransferDraftCopyWith<$Res> {
  __$TransferDraftCopyWithImpl(this._self, this._then);

  final _TransferDraft _self;
  final $Res Function(_TransferDraft) _then;

/// Create a copy of TransferDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? senderWalletId = null,Object? senderWalletName = null,Object? recipientUserId = null,Object? recipientDisplayName = null,Object? currency = null,Object? amount = null,Object? note = freezed,}) {
  return _then(_TransferDraft(
senderWalletId: null == senderWalletId ? _self.senderWalletId : senderWalletId // ignore: cast_nullable_to_non_nullable
as String,senderWalletName: null == senderWalletName ? _self.senderWalletName : senderWalletName // ignore: cast_nullable_to_non_nullable
as String,recipientUserId: null == recipientUserId ? _self.recipientUserId : recipientUserId // ignore: cast_nullable_to_non_nullable
as String,recipientDisplayName: null == recipientDisplayName ? _self.recipientDisplayName : recipientDisplayName // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
