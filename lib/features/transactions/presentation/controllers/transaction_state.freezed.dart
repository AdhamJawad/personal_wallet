// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionState {

 bool get isLoading; List<LedgerTransaction> get transactions; LedgerTransaction? get selectedTransaction; String get searchQuery; TransactionFilterOption get filterOption; TransactionSortOption get sortOption; String? get errorMessage;
/// Create a copy of TransactionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionStateCopyWith<TransactionState> get copyWith => _$TransactionStateCopyWithImpl<TransactionState>(this as TransactionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.transactions, transactions)&&(identical(other.selectedTransaction, selectedTransaction) || other.selectedTransaction == selectedTransaction)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.filterOption, filterOption) || other.filterOption == filterOption)&&(identical(other.sortOption, sortOption) || other.sortOption == sortOption)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(transactions),selectedTransaction,searchQuery,filterOption,sortOption,errorMessage);

@override
String toString() {
  return 'TransactionState(isLoading: $isLoading, transactions: $transactions, selectedTransaction: $selectedTransaction, searchQuery: $searchQuery, filterOption: $filterOption, sortOption: $sortOption, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $TransactionStateCopyWith<$Res>  {
  factory $TransactionStateCopyWith(TransactionState value, $Res Function(TransactionState) _then) = _$TransactionStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<LedgerTransaction> transactions, LedgerTransaction? selectedTransaction, String searchQuery, TransactionFilterOption filterOption, TransactionSortOption sortOption, String? errorMessage
});


$LedgerTransactionCopyWith<$Res>? get selectedTransaction;

}
/// @nodoc
class _$TransactionStateCopyWithImpl<$Res>
    implements $TransactionStateCopyWith<$Res> {
  _$TransactionStateCopyWithImpl(this._self, this._then);

  final TransactionState _self;
  final $Res Function(TransactionState) _then;

/// Create a copy of TransactionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? transactions = null,Object? selectedTransaction = freezed,Object? searchQuery = null,Object? filterOption = null,Object? sortOption = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<LedgerTransaction>,selectedTransaction: freezed == selectedTransaction ? _self.selectedTransaction : selectedTransaction // ignore: cast_nullable_to_non_nullable
as LedgerTransaction?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,filterOption: null == filterOption ? _self.filterOption : filterOption // ignore: cast_nullable_to_non_nullable
as TransactionFilterOption,sortOption: null == sortOption ? _self.sortOption : sortOption // ignore: cast_nullable_to_non_nullable
as TransactionSortOption,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of TransactionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LedgerTransactionCopyWith<$Res>? get selectedTransaction {
    if (_self.selectedTransaction == null) {
    return null;
  }

  return $LedgerTransactionCopyWith<$Res>(_self.selectedTransaction!, (value) {
    return _then(_self.copyWith(selectedTransaction: value));
  });
}
}


/// Adds pattern-matching-related methods to [TransactionState].
extension TransactionStatePatterns on TransactionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionState value)  $default,){
final _that = this;
switch (_that) {
case _TransactionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionState value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<LedgerTransaction> transactions,  LedgerTransaction? selectedTransaction,  String searchQuery,  TransactionFilterOption filterOption,  TransactionSortOption sortOption,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionState() when $default != null:
return $default(_that.isLoading,_that.transactions,_that.selectedTransaction,_that.searchQuery,_that.filterOption,_that.sortOption,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<LedgerTransaction> transactions,  LedgerTransaction? selectedTransaction,  String searchQuery,  TransactionFilterOption filterOption,  TransactionSortOption sortOption,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _TransactionState():
return $default(_that.isLoading,_that.transactions,_that.selectedTransaction,_that.searchQuery,_that.filterOption,_that.sortOption,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<LedgerTransaction> transactions,  LedgerTransaction? selectedTransaction,  String searchQuery,  TransactionFilterOption filterOption,  TransactionSortOption sortOption,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _TransactionState() when $default != null:
return $default(_that.isLoading,_that.transactions,_that.selectedTransaction,_that.searchQuery,_that.filterOption,_that.sortOption,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionState extends TransactionState {
  const _TransactionState({this.isLoading = false, final  List<LedgerTransaction> transactions = const <LedgerTransaction>[], this.selectedTransaction, this.searchQuery = '', this.filterOption = TransactionFilterOption.all, this.sortOption = TransactionSortOption.newest, this.errorMessage}): _transactions = transactions,super._();
  

@override@JsonKey() final  bool isLoading;
 final  List<LedgerTransaction> _transactions;
@override@JsonKey() List<LedgerTransaction> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}

@override final  LedgerTransaction? selectedTransaction;
@override@JsonKey() final  String searchQuery;
@override@JsonKey() final  TransactionFilterOption filterOption;
@override@JsonKey() final  TransactionSortOption sortOption;
@override final  String? errorMessage;

/// Create a copy of TransactionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionStateCopyWith<_TransactionState> get copyWith => __$TransactionStateCopyWithImpl<_TransactionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._transactions, _transactions)&&(identical(other.selectedTransaction, selectedTransaction) || other.selectedTransaction == selectedTransaction)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.filterOption, filterOption) || other.filterOption == filterOption)&&(identical(other.sortOption, sortOption) || other.sortOption == sortOption)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_transactions),selectedTransaction,searchQuery,filterOption,sortOption,errorMessage);

@override
String toString() {
  return 'TransactionState(isLoading: $isLoading, transactions: $transactions, selectedTransaction: $selectedTransaction, searchQuery: $searchQuery, filterOption: $filterOption, sortOption: $sortOption, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$TransactionStateCopyWith<$Res> implements $TransactionStateCopyWith<$Res> {
  factory _$TransactionStateCopyWith(_TransactionState value, $Res Function(_TransactionState) _then) = __$TransactionStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<LedgerTransaction> transactions, LedgerTransaction? selectedTransaction, String searchQuery, TransactionFilterOption filterOption, TransactionSortOption sortOption, String? errorMessage
});


@override $LedgerTransactionCopyWith<$Res>? get selectedTransaction;

}
/// @nodoc
class __$TransactionStateCopyWithImpl<$Res>
    implements _$TransactionStateCopyWith<$Res> {
  __$TransactionStateCopyWithImpl(this._self, this._then);

  final _TransactionState _self;
  final $Res Function(_TransactionState) _then;

/// Create a copy of TransactionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? transactions = null,Object? selectedTransaction = freezed,Object? searchQuery = null,Object? filterOption = null,Object? sortOption = null,Object? errorMessage = freezed,}) {
  return _then(_TransactionState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<LedgerTransaction>,selectedTransaction: freezed == selectedTransaction ? _self.selectedTransaction : selectedTransaction // ignore: cast_nullable_to_non_nullable
as LedgerTransaction?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,filterOption: null == filterOption ? _self.filterOption : filterOption // ignore: cast_nullable_to_non_nullable
as TransactionFilterOption,sortOption: null == sortOption ? _self.sortOption : sortOption // ignore: cast_nullable_to_non_nullable
as TransactionSortOption,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of TransactionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LedgerTransactionCopyWith<$Res>? get selectedTransaction {
    if (_self.selectedTransaction == null) {
    return null;
  }

  return $LedgerTransactionCopyWith<$Res>(_self.selectedTransaction!, (value) {
    return _then(_self.copyWith(selectedTransaction: value));
  });
}
}

// dart format on
