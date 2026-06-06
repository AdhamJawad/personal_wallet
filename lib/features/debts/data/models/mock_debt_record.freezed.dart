// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mock_debt_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MockDebtRecord {

 Debt get debt; List<DebtRepayment> get repayments; List<DebtSettlement> get settlements;
/// Create a copy of MockDebtRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MockDebtRecordCopyWith<MockDebtRecord> get copyWith => _$MockDebtRecordCopyWithImpl<MockDebtRecord>(this as MockDebtRecord, _$identity);

  /// Serializes this MockDebtRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MockDebtRecord&&(identical(other.debt, debt) || other.debt == debt)&&const DeepCollectionEquality().equals(other.repayments, repayments)&&const DeepCollectionEquality().equals(other.settlements, settlements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,debt,const DeepCollectionEquality().hash(repayments),const DeepCollectionEquality().hash(settlements));

@override
String toString() {
  return 'MockDebtRecord(debt: $debt, repayments: $repayments, settlements: $settlements)';
}


}

/// @nodoc
abstract mixin class $MockDebtRecordCopyWith<$Res>  {
  factory $MockDebtRecordCopyWith(MockDebtRecord value, $Res Function(MockDebtRecord) _then) = _$MockDebtRecordCopyWithImpl;
@useResult
$Res call({
 Debt debt, List<DebtRepayment> repayments, List<DebtSettlement> settlements
});


$DebtCopyWith<$Res> get debt;

}
/// @nodoc
class _$MockDebtRecordCopyWithImpl<$Res>
    implements $MockDebtRecordCopyWith<$Res> {
  _$MockDebtRecordCopyWithImpl(this._self, this._then);

  final MockDebtRecord _self;
  final $Res Function(MockDebtRecord) _then;

/// Create a copy of MockDebtRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? debt = null,Object? repayments = null,Object? settlements = null,}) {
  return _then(_self.copyWith(
debt: null == debt ? _self.debt : debt // ignore: cast_nullable_to_non_nullable
as Debt,repayments: null == repayments ? _self.repayments : repayments // ignore: cast_nullable_to_non_nullable
as List<DebtRepayment>,settlements: null == settlements ? _self.settlements : settlements // ignore: cast_nullable_to_non_nullable
as List<DebtSettlement>,
  ));
}
/// Create a copy of MockDebtRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DebtCopyWith<$Res> get debt {
  
  return $DebtCopyWith<$Res>(_self.debt, (value) {
    return _then(_self.copyWith(debt: value));
  });
}
}


/// Adds pattern-matching-related methods to [MockDebtRecord].
extension MockDebtRecordPatterns on MockDebtRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MockDebtRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MockDebtRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MockDebtRecord value)  $default,){
final _that = this;
switch (_that) {
case _MockDebtRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MockDebtRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MockDebtRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Debt debt,  List<DebtRepayment> repayments,  List<DebtSettlement> settlements)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MockDebtRecord() when $default != null:
return $default(_that.debt,_that.repayments,_that.settlements);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Debt debt,  List<DebtRepayment> repayments,  List<DebtSettlement> settlements)  $default,) {final _that = this;
switch (_that) {
case _MockDebtRecord():
return $default(_that.debt,_that.repayments,_that.settlements);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Debt debt,  List<DebtRepayment> repayments,  List<DebtSettlement> settlements)?  $default,) {final _that = this;
switch (_that) {
case _MockDebtRecord() when $default != null:
return $default(_that.debt,_that.repayments,_that.settlements);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MockDebtRecord implements MockDebtRecord {
  const _MockDebtRecord({required this.debt, required final  List<DebtRepayment> repayments, final  List<DebtSettlement> settlements = const <DebtSettlement>[]}): _repayments = repayments,_settlements = settlements;
  factory _MockDebtRecord.fromJson(Map<String, dynamic> json) => _$MockDebtRecordFromJson(json);

@override final  Debt debt;
 final  List<DebtRepayment> _repayments;
@override List<DebtRepayment> get repayments {
  if (_repayments is EqualUnmodifiableListView) return _repayments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_repayments);
}

 final  List<DebtSettlement> _settlements;
@override@JsonKey() List<DebtSettlement> get settlements {
  if (_settlements is EqualUnmodifiableListView) return _settlements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_settlements);
}


/// Create a copy of MockDebtRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MockDebtRecordCopyWith<_MockDebtRecord> get copyWith => __$MockDebtRecordCopyWithImpl<_MockDebtRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MockDebtRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MockDebtRecord&&(identical(other.debt, debt) || other.debt == debt)&&const DeepCollectionEquality().equals(other._repayments, _repayments)&&const DeepCollectionEquality().equals(other._settlements, _settlements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,debt,const DeepCollectionEquality().hash(_repayments),const DeepCollectionEquality().hash(_settlements));

@override
String toString() {
  return 'MockDebtRecord(debt: $debt, repayments: $repayments, settlements: $settlements)';
}


}

/// @nodoc
abstract mixin class _$MockDebtRecordCopyWith<$Res> implements $MockDebtRecordCopyWith<$Res> {
  factory _$MockDebtRecordCopyWith(_MockDebtRecord value, $Res Function(_MockDebtRecord) _then) = __$MockDebtRecordCopyWithImpl;
@override @useResult
$Res call({
 Debt debt, List<DebtRepayment> repayments, List<DebtSettlement> settlements
});


@override $DebtCopyWith<$Res> get debt;

}
/// @nodoc
class __$MockDebtRecordCopyWithImpl<$Res>
    implements _$MockDebtRecordCopyWith<$Res> {
  __$MockDebtRecordCopyWithImpl(this._self, this._then);

  final _MockDebtRecord _self;
  final $Res Function(_MockDebtRecord) _then;

/// Create a copy of MockDebtRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? debt = null,Object? repayments = null,Object? settlements = null,}) {
  return _then(_MockDebtRecord(
debt: null == debt ? _self.debt : debt // ignore: cast_nullable_to_non_nullable
as Debt,repayments: null == repayments ? _self._repayments : repayments // ignore: cast_nullable_to_non_nullable
as List<DebtRepayment>,settlements: null == settlements ? _self._settlements : settlements // ignore: cast_nullable_to_non_nullable
as List<DebtSettlement>,
  ));
}

/// Create a copy of MockDebtRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DebtCopyWith<$Res> get debt {
  
  return $DebtCopyWith<$Res>(_self.debt, (value) {
    return _then(_self.copyWith(debt: value));
  });
}
}

// dart format on
