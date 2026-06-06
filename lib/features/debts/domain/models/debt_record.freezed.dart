// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DebtRecord {

 String get id; String get lenderPartyId; String get borrowerPartyId; Currency get currency; String get principalAmount; String get repaidAmount; DebtStatus get status; String? get note;@DateTimeConverter() DateTime get createdAt;@DateTimeConverter() DateTime get updatedAt;
/// Create a copy of DebtRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtRecordCopyWith<DebtRecord> get copyWith => _$DebtRecordCopyWithImpl<DebtRecord>(this as DebtRecord, _$identity);

  /// Serializes this DebtRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.lenderPartyId, lenderPartyId) || other.lenderPartyId == lenderPartyId)&&(identical(other.borrowerPartyId, borrowerPartyId) || other.borrowerPartyId == borrowerPartyId)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.principalAmount, principalAmount) || other.principalAmount == principalAmount)&&(identical(other.repaidAmount, repaidAmount) || other.repaidAmount == repaidAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lenderPartyId,borrowerPartyId,currency,principalAmount,repaidAmount,status,note,createdAt,updatedAt);

@override
String toString() {
  return 'DebtRecord(id: $id, lenderPartyId: $lenderPartyId, borrowerPartyId: $borrowerPartyId, currency: $currency, principalAmount: $principalAmount, repaidAmount: $repaidAmount, status: $status, note: $note, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DebtRecordCopyWith<$Res>  {
  factory $DebtRecordCopyWith(DebtRecord value, $Res Function(DebtRecord) _then) = _$DebtRecordCopyWithImpl;
@useResult
$Res call({
 String id, String lenderPartyId, String borrowerPartyId, Currency currency, String principalAmount, String repaidAmount, DebtStatus status, String? note,@DateTimeConverter() DateTime createdAt,@DateTimeConverter() DateTime updatedAt
});




}
/// @nodoc
class _$DebtRecordCopyWithImpl<$Res>
    implements $DebtRecordCopyWith<$Res> {
  _$DebtRecordCopyWithImpl(this._self, this._then);

  final DebtRecord _self;
  final $Res Function(DebtRecord) _then;

/// Create a copy of DebtRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? lenderPartyId = null,Object? borrowerPartyId = null,Object? currency = null,Object? principalAmount = null,Object? repaidAmount = null,Object? status = null,Object? note = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lenderPartyId: null == lenderPartyId ? _self.lenderPartyId : lenderPartyId // ignore: cast_nullable_to_non_nullable
as String,borrowerPartyId: null == borrowerPartyId ? _self.borrowerPartyId : borrowerPartyId // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,principalAmount: null == principalAmount ? _self.principalAmount : principalAmount // ignore: cast_nullable_to_non_nullable
as String,repaidAmount: null == repaidAmount ? _self.repaidAmount : repaidAmount // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DebtStatus,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DebtRecord].
extension DebtRecordPatterns on DebtRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DebtRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DebtRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DebtRecord value)  $default,){
final _that = this;
switch (_that) {
case _DebtRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DebtRecord value)?  $default,){
final _that = this;
switch (_that) {
case _DebtRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String lenderPartyId,  String borrowerPartyId,  Currency currency,  String principalAmount,  String repaidAmount,  DebtStatus status,  String? note, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DebtRecord() when $default != null:
return $default(_that.id,_that.lenderPartyId,_that.borrowerPartyId,_that.currency,_that.principalAmount,_that.repaidAmount,_that.status,_that.note,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String lenderPartyId,  String borrowerPartyId,  Currency currency,  String principalAmount,  String repaidAmount,  DebtStatus status,  String? note, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DebtRecord():
return $default(_that.id,_that.lenderPartyId,_that.borrowerPartyId,_that.currency,_that.principalAmount,_that.repaidAmount,_that.status,_that.note,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String lenderPartyId,  String borrowerPartyId,  Currency currency,  String principalAmount,  String repaidAmount,  DebtStatus status,  String? note, @DateTimeConverter()  DateTime createdAt, @DateTimeConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DebtRecord() when $default != null:
return $default(_that.id,_that.lenderPartyId,_that.borrowerPartyId,_that.currency,_that.principalAmount,_that.repaidAmount,_that.status,_that.note,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DebtRecord implements DebtRecord {
  const _DebtRecord({required this.id, required this.lenderPartyId, required this.borrowerPartyId, required this.currency, required this.principalAmount, required this.repaidAmount, required this.status, this.note, @DateTimeConverter() required this.createdAt, @DateTimeConverter() required this.updatedAt});
  factory _DebtRecord.fromJson(Map<String, dynamic> json) => _$DebtRecordFromJson(json);

@override final  String id;
@override final  String lenderPartyId;
@override final  String borrowerPartyId;
@override final  Currency currency;
@override final  String principalAmount;
@override final  String repaidAmount;
@override final  DebtStatus status;
@override final  String? note;
@override@DateTimeConverter() final  DateTime createdAt;
@override@DateTimeConverter() final  DateTime updatedAt;

/// Create a copy of DebtRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtRecordCopyWith<_DebtRecord> get copyWith => __$DebtRecordCopyWithImpl<_DebtRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DebtRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DebtRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.lenderPartyId, lenderPartyId) || other.lenderPartyId == lenderPartyId)&&(identical(other.borrowerPartyId, borrowerPartyId) || other.borrowerPartyId == borrowerPartyId)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.principalAmount, principalAmount) || other.principalAmount == principalAmount)&&(identical(other.repaidAmount, repaidAmount) || other.repaidAmount == repaidAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lenderPartyId,borrowerPartyId,currency,principalAmount,repaidAmount,status,note,createdAt,updatedAt);

@override
String toString() {
  return 'DebtRecord(id: $id, lenderPartyId: $lenderPartyId, borrowerPartyId: $borrowerPartyId, currency: $currency, principalAmount: $principalAmount, repaidAmount: $repaidAmount, status: $status, note: $note, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DebtRecordCopyWith<$Res> implements $DebtRecordCopyWith<$Res> {
  factory _$DebtRecordCopyWith(_DebtRecord value, $Res Function(_DebtRecord) _then) = __$DebtRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String lenderPartyId, String borrowerPartyId, Currency currency, String principalAmount, String repaidAmount, DebtStatus status, String? note,@DateTimeConverter() DateTime createdAt,@DateTimeConverter() DateTime updatedAt
});




}
/// @nodoc
class __$DebtRecordCopyWithImpl<$Res>
    implements _$DebtRecordCopyWith<$Res> {
  __$DebtRecordCopyWithImpl(this._self, this._then);

  final _DebtRecord _self;
  final $Res Function(_DebtRecord) _then;

/// Create a copy of DebtRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? lenderPartyId = null,Object? borrowerPartyId = null,Object? currency = null,Object? principalAmount = null,Object? repaidAmount = null,Object? status = null,Object? note = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_DebtRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lenderPartyId: null == lenderPartyId ? _self.lenderPartyId : lenderPartyId // ignore: cast_nullable_to_non_nullable
as String,borrowerPartyId: null == borrowerPartyId ? _self.borrowerPartyId : borrowerPartyId // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,principalAmount: null == principalAmount ? _self.principalAmount : principalAmount // ignore: cast_nullable_to_non_nullable
as String,repaidAmount: null == repaidAmount ? _self.repaidAmount : repaidAmount // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DebtStatus,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
