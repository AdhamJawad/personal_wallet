// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionRecord {

 String get id; TransactionType get type; String get initiatedByUserId; String? get sourceWalletId; String? get destinationWalletId; String get sourceAmount; Currency get sourceCurrency; String? get destinationAmount; Currency? get destinationCurrency; String? get relatedTransactionId; String? get note;@DateTimeConverter() DateTime get createdAt;
/// Create a copy of TransactionRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionRecordCopyWith<TransactionRecord> get copyWith => _$TransactionRecordCopyWithImpl<TransactionRecord>(this as TransactionRecord, _$identity);

  /// Serializes this TransactionRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.initiatedByUserId, initiatedByUserId) || other.initiatedByUserId == initiatedByUserId)&&(identical(other.sourceWalletId, sourceWalletId) || other.sourceWalletId == sourceWalletId)&&(identical(other.destinationWalletId, destinationWalletId) || other.destinationWalletId == destinationWalletId)&&(identical(other.sourceAmount, sourceAmount) || other.sourceAmount == sourceAmount)&&(identical(other.sourceCurrency, sourceCurrency) || other.sourceCurrency == sourceCurrency)&&(identical(other.destinationAmount, destinationAmount) || other.destinationAmount == destinationAmount)&&(identical(other.destinationCurrency, destinationCurrency) || other.destinationCurrency == destinationCurrency)&&(identical(other.relatedTransactionId, relatedTransactionId) || other.relatedTransactionId == relatedTransactionId)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,initiatedByUserId,sourceWalletId,destinationWalletId,sourceAmount,sourceCurrency,destinationAmount,destinationCurrency,relatedTransactionId,note,createdAt);

@override
String toString() {
  return 'TransactionRecord(id: $id, type: $type, initiatedByUserId: $initiatedByUserId, sourceWalletId: $sourceWalletId, destinationWalletId: $destinationWalletId, sourceAmount: $sourceAmount, sourceCurrency: $sourceCurrency, destinationAmount: $destinationAmount, destinationCurrency: $destinationCurrency, relatedTransactionId: $relatedTransactionId, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TransactionRecordCopyWith<$Res>  {
  factory $TransactionRecordCopyWith(TransactionRecord value, $Res Function(TransactionRecord) _then) = _$TransactionRecordCopyWithImpl;
@useResult
$Res call({
 String id, TransactionType type, String initiatedByUserId, String? sourceWalletId, String? destinationWalletId, String sourceAmount, Currency sourceCurrency, String? destinationAmount, Currency? destinationCurrency, String? relatedTransactionId, String? note,@DateTimeConverter() DateTime createdAt
});




}
/// @nodoc
class _$TransactionRecordCopyWithImpl<$Res>
    implements $TransactionRecordCopyWith<$Res> {
  _$TransactionRecordCopyWithImpl(this._self, this._then);

  final TransactionRecord _self;
  final $Res Function(TransactionRecord) _then;

/// Create a copy of TransactionRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? initiatedByUserId = null,Object? sourceWalletId = freezed,Object? destinationWalletId = freezed,Object? sourceAmount = null,Object? sourceCurrency = null,Object? destinationAmount = freezed,Object? destinationCurrency = freezed,Object? relatedTransactionId = freezed,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,initiatedByUserId: null == initiatedByUserId ? _self.initiatedByUserId : initiatedByUserId // ignore: cast_nullable_to_non_nullable
as String,sourceWalletId: freezed == sourceWalletId ? _self.sourceWalletId : sourceWalletId // ignore: cast_nullable_to_non_nullable
as String?,destinationWalletId: freezed == destinationWalletId ? _self.destinationWalletId : destinationWalletId // ignore: cast_nullable_to_non_nullable
as String?,sourceAmount: null == sourceAmount ? _self.sourceAmount : sourceAmount // ignore: cast_nullable_to_non_nullable
as String,sourceCurrency: null == sourceCurrency ? _self.sourceCurrency : sourceCurrency // ignore: cast_nullable_to_non_nullable
as Currency,destinationAmount: freezed == destinationAmount ? _self.destinationAmount : destinationAmount // ignore: cast_nullable_to_non_nullable
as String?,destinationCurrency: freezed == destinationCurrency ? _self.destinationCurrency : destinationCurrency // ignore: cast_nullable_to_non_nullable
as Currency?,relatedTransactionId: freezed == relatedTransactionId ? _self.relatedTransactionId : relatedTransactionId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionRecord].
extension TransactionRecordPatterns on TransactionRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionRecord value)  $default,){
final _that = this;
switch (_that) {
case _TransactionRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionRecord value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  TransactionType type,  String initiatedByUserId,  String? sourceWalletId,  String? destinationWalletId,  String sourceAmount,  Currency sourceCurrency,  String? destinationAmount,  Currency? destinationCurrency,  String? relatedTransactionId,  String? note, @DateTimeConverter()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionRecord() when $default != null:
return $default(_that.id,_that.type,_that.initiatedByUserId,_that.sourceWalletId,_that.destinationWalletId,_that.sourceAmount,_that.sourceCurrency,_that.destinationAmount,_that.destinationCurrency,_that.relatedTransactionId,_that.note,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  TransactionType type,  String initiatedByUserId,  String? sourceWalletId,  String? destinationWalletId,  String sourceAmount,  Currency sourceCurrency,  String? destinationAmount,  Currency? destinationCurrency,  String? relatedTransactionId,  String? note, @DateTimeConverter()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _TransactionRecord():
return $default(_that.id,_that.type,_that.initiatedByUserId,_that.sourceWalletId,_that.destinationWalletId,_that.sourceAmount,_that.sourceCurrency,_that.destinationAmount,_that.destinationCurrency,_that.relatedTransactionId,_that.note,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  TransactionType type,  String initiatedByUserId,  String? sourceWalletId,  String? destinationWalletId,  String sourceAmount,  Currency sourceCurrency,  String? destinationAmount,  Currency? destinationCurrency,  String? relatedTransactionId,  String? note, @DateTimeConverter()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TransactionRecord() when $default != null:
return $default(_that.id,_that.type,_that.initiatedByUserId,_that.sourceWalletId,_that.destinationWalletId,_that.sourceAmount,_that.sourceCurrency,_that.destinationAmount,_that.destinationCurrency,_that.relatedTransactionId,_that.note,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionRecord implements TransactionRecord {
  const _TransactionRecord({required this.id, required this.type, required this.initiatedByUserId, this.sourceWalletId, this.destinationWalletId, required this.sourceAmount, required this.sourceCurrency, this.destinationAmount, this.destinationCurrency, this.relatedTransactionId, this.note, @DateTimeConverter() required this.createdAt});
  factory _TransactionRecord.fromJson(Map<String, dynamic> json) => _$TransactionRecordFromJson(json);

@override final  String id;
@override final  TransactionType type;
@override final  String initiatedByUserId;
@override final  String? sourceWalletId;
@override final  String? destinationWalletId;
@override final  String sourceAmount;
@override final  Currency sourceCurrency;
@override final  String? destinationAmount;
@override final  Currency? destinationCurrency;
@override final  String? relatedTransactionId;
@override final  String? note;
@override@DateTimeConverter() final  DateTime createdAt;

/// Create a copy of TransactionRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionRecordCopyWith<_TransactionRecord> get copyWith => __$TransactionRecordCopyWithImpl<_TransactionRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.initiatedByUserId, initiatedByUserId) || other.initiatedByUserId == initiatedByUserId)&&(identical(other.sourceWalletId, sourceWalletId) || other.sourceWalletId == sourceWalletId)&&(identical(other.destinationWalletId, destinationWalletId) || other.destinationWalletId == destinationWalletId)&&(identical(other.sourceAmount, sourceAmount) || other.sourceAmount == sourceAmount)&&(identical(other.sourceCurrency, sourceCurrency) || other.sourceCurrency == sourceCurrency)&&(identical(other.destinationAmount, destinationAmount) || other.destinationAmount == destinationAmount)&&(identical(other.destinationCurrency, destinationCurrency) || other.destinationCurrency == destinationCurrency)&&(identical(other.relatedTransactionId, relatedTransactionId) || other.relatedTransactionId == relatedTransactionId)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,initiatedByUserId,sourceWalletId,destinationWalletId,sourceAmount,sourceCurrency,destinationAmount,destinationCurrency,relatedTransactionId,note,createdAt);

@override
String toString() {
  return 'TransactionRecord(id: $id, type: $type, initiatedByUserId: $initiatedByUserId, sourceWalletId: $sourceWalletId, destinationWalletId: $destinationWalletId, sourceAmount: $sourceAmount, sourceCurrency: $sourceCurrency, destinationAmount: $destinationAmount, destinationCurrency: $destinationCurrency, relatedTransactionId: $relatedTransactionId, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TransactionRecordCopyWith<$Res> implements $TransactionRecordCopyWith<$Res> {
  factory _$TransactionRecordCopyWith(_TransactionRecord value, $Res Function(_TransactionRecord) _then) = __$TransactionRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, TransactionType type, String initiatedByUserId, String? sourceWalletId, String? destinationWalletId, String sourceAmount, Currency sourceCurrency, String? destinationAmount, Currency? destinationCurrency, String? relatedTransactionId, String? note,@DateTimeConverter() DateTime createdAt
});




}
/// @nodoc
class __$TransactionRecordCopyWithImpl<$Res>
    implements _$TransactionRecordCopyWith<$Res> {
  __$TransactionRecordCopyWithImpl(this._self, this._then);

  final _TransactionRecord _self;
  final $Res Function(_TransactionRecord) _then;

/// Create a copy of TransactionRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? initiatedByUserId = null,Object? sourceWalletId = freezed,Object? destinationWalletId = freezed,Object? sourceAmount = null,Object? sourceCurrency = null,Object? destinationAmount = freezed,Object? destinationCurrency = freezed,Object? relatedTransactionId = freezed,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_TransactionRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,initiatedByUserId: null == initiatedByUserId ? _self.initiatedByUserId : initiatedByUserId // ignore: cast_nullable_to_non_nullable
as String,sourceWalletId: freezed == sourceWalletId ? _self.sourceWalletId : sourceWalletId // ignore: cast_nullable_to_non_nullable
as String?,destinationWalletId: freezed == destinationWalletId ? _self.destinationWalletId : destinationWalletId // ignore: cast_nullable_to_non_nullable
as String?,sourceAmount: null == sourceAmount ? _self.sourceAmount : sourceAmount // ignore: cast_nullable_to_non_nullable
as String,sourceCurrency: null == sourceCurrency ? _self.sourceCurrency : sourceCurrency // ignore: cast_nullable_to_non_nullable
as Currency,destinationAmount: freezed == destinationAmount ? _self.destinationAmount : destinationAmount // ignore: cast_nullable_to_non_nullable
as String?,destinationCurrency: freezed == destinationCurrency ? _self.destinationCurrency : destinationCurrency // ignore: cast_nullable_to_non_nullable
as Currency?,relatedTransactionId: freezed == relatedTransactionId ? _self.relatedTransactionId : relatedTransactionId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
