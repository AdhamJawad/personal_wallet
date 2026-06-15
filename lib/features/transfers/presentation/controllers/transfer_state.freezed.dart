// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransferState {

 bool get isLoading; List<TransferSummary> get transfers; TransferSummary? get selectedTransfer; TransferSummary? get lastCompletedTransfer; SettlementSummary? get lastCompletedSettlement; String get searchQuery; String? get errorMessage;
/// Create a copy of TransferState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferStateCopyWith<TransferState> get copyWith => _$TransferStateCopyWithImpl<TransferState>(this as TransferState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.transfers, transfers)&&(identical(other.selectedTransfer, selectedTransfer) || other.selectedTransfer == selectedTransfer)&&(identical(other.lastCompletedTransfer, lastCompletedTransfer) || other.lastCompletedTransfer == lastCompletedTransfer)&&(identical(other.lastCompletedSettlement, lastCompletedSettlement) || other.lastCompletedSettlement == lastCompletedSettlement)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(transfers),selectedTransfer,lastCompletedTransfer,lastCompletedSettlement,searchQuery,errorMessage);

@override
String toString() {
  return 'TransferState(isLoading: $isLoading, transfers: $transfers, selectedTransfer: $selectedTransfer, lastCompletedTransfer: $lastCompletedTransfer, lastCompletedSettlement: $lastCompletedSettlement, searchQuery: $searchQuery, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $TransferStateCopyWith<$Res>  {
  factory $TransferStateCopyWith(TransferState value, $Res Function(TransferState) _then) = _$TransferStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<TransferSummary> transfers, TransferSummary? selectedTransfer, TransferSummary? lastCompletedTransfer, SettlementSummary? lastCompletedSettlement, String searchQuery, String? errorMessage
});




}
/// @nodoc
class _$TransferStateCopyWithImpl<$Res>
    implements $TransferStateCopyWith<$Res> {
  _$TransferStateCopyWithImpl(this._self, this._then);

  final TransferState _self;
  final $Res Function(TransferState) _then;

/// Create a copy of TransferState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? transfers = null,Object? selectedTransfer = freezed,Object? lastCompletedTransfer = freezed,Object? lastCompletedSettlement = freezed,Object? searchQuery = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,transfers: null == transfers ? _self.transfers : transfers // ignore: cast_nullable_to_non_nullable
as List<TransferSummary>,selectedTransfer: freezed == selectedTransfer ? _self.selectedTransfer : selectedTransfer // ignore: cast_nullable_to_non_nullable
as TransferSummary?,lastCompletedTransfer: freezed == lastCompletedTransfer ? _self.lastCompletedTransfer : lastCompletedTransfer // ignore: cast_nullable_to_non_nullable
as TransferSummary?,lastCompletedSettlement: freezed == lastCompletedSettlement ? _self.lastCompletedSettlement : lastCompletedSettlement // ignore: cast_nullable_to_non_nullable
as SettlementSummary?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferState].
extension TransferStatePatterns on TransferState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferState value)  $default,){
final _that = this;
switch (_that) {
case _TransferState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferState value)?  $default,){
final _that = this;
switch (_that) {
case _TransferState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<TransferSummary> transfers,  TransferSummary? selectedTransfer,  TransferSummary? lastCompletedTransfer,  SettlementSummary? lastCompletedSettlement,  String searchQuery,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferState() when $default != null:
return $default(_that.isLoading,_that.transfers,_that.selectedTransfer,_that.lastCompletedTransfer,_that.lastCompletedSettlement,_that.searchQuery,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<TransferSummary> transfers,  TransferSummary? selectedTransfer,  TransferSummary? lastCompletedTransfer,  SettlementSummary? lastCompletedSettlement,  String searchQuery,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _TransferState():
return $default(_that.isLoading,_that.transfers,_that.selectedTransfer,_that.lastCompletedTransfer,_that.lastCompletedSettlement,_that.searchQuery,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<TransferSummary> transfers,  TransferSummary? selectedTransfer,  TransferSummary? lastCompletedTransfer,  SettlementSummary? lastCompletedSettlement,  String searchQuery,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _TransferState() when $default != null:
return $default(_that.isLoading,_that.transfers,_that.selectedTransfer,_that.lastCompletedTransfer,_that.lastCompletedSettlement,_that.searchQuery,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _TransferState extends TransferState {
  const _TransferState({this.isLoading = false, final  List<TransferSummary> transfers = const <TransferSummary>[], this.selectedTransfer, this.lastCompletedTransfer, this.lastCompletedSettlement, this.searchQuery = '', this.errorMessage}): _transfers = transfers,super._();
  

@override@JsonKey() final  bool isLoading;
 final  List<TransferSummary> _transfers;
@override@JsonKey() List<TransferSummary> get transfers {
  if (_transfers is EqualUnmodifiableListView) return _transfers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transfers);
}

@override final  TransferSummary? selectedTransfer;
@override final  TransferSummary? lastCompletedTransfer;
@override final  SettlementSummary? lastCompletedSettlement;
@override@JsonKey() final  String searchQuery;
@override final  String? errorMessage;

/// Create a copy of TransferState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferStateCopyWith<_TransferState> get copyWith => __$TransferStateCopyWithImpl<_TransferState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._transfers, _transfers)&&(identical(other.selectedTransfer, selectedTransfer) || other.selectedTransfer == selectedTransfer)&&(identical(other.lastCompletedTransfer, lastCompletedTransfer) || other.lastCompletedTransfer == lastCompletedTransfer)&&(identical(other.lastCompletedSettlement, lastCompletedSettlement) || other.lastCompletedSettlement == lastCompletedSettlement)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_transfers),selectedTransfer,lastCompletedTransfer,lastCompletedSettlement,searchQuery,errorMessage);

@override
String toString() {
  return 'TransferState(isLoading: $isLoading, transfers: $transfers, selectedTransfer: $selectedTransfer, lastCompletedTransfer: $lastCompletedTransfer, lastCompletedSettlement: $lastCompletedSettlement, searchQuery: $searchQuery, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$TransferStateCopyWith<$Res> implements $TransferStateCopyWith<$Res> {
  factory _$TransferStateCopyWith(_TransferState value, $Res Function(_TransferState) _then) = __$TransferStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<TransferSummary> transfers, TransferSummary? selectedTransfer, TransferSummary? lastCompletedTransfer, SettlementSummary? lastCompletedSettlement, String searchQuery, String? errorMessage
});




}
/// @nodoc
class __$TransferStateCopyWithImpl<$Res>
    implements _$TransferStateCopyWith<$Res> {
  __$TransferStateCopyWithImpl(this._self, this._then);

  final _TransferState _self;
  final $Res Function(_TransferState) _then;

/// Create a copy of TransferState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? transfers = null,Object? selectedTransfer = freezed,Object? lastCompletedTransfer = freezed,Object? lastCompletedSettlement = freezed,Object? searchQuery = null,Object? errorMessage = freezed,}) {
  return _then(_TransferState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,transfers: null == transfers ? _self._transfers : transfers // ignore: cast_nullable_to_non_nullable
as List<TransferSummary>,selectedTransfer: freezed == selectedTransfer ? _self.selectedTransfer : selectedTransfer // ignore: cast_nullable_to_non_nullable
as TransferSummary?,lastCompletedTransfer: freezed == lastCompletedTransfer ? _self.lastCompletedTransfer : lastCompletedTransfer // ignore: cast_nullable_to_non_nullable
as TransferSummary?,lastCompletedSettlement: freezed == lastCompletedSettlement ? _self.lastCompletedSettlement : lastCompletedSettlement // ignore: cast_nullable_to_non_nullable
as SettlementSummary?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
