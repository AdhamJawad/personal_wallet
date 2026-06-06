// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WalletState {

 bool get isLoading; List<WalletOverview> get wallets; WalletDashboardSnapshot? get dashboardSnapshot; WalletOverview? get selectedWallet; String get searchQuery; WalletSortOption get sortOption; String? get errorMessage;
/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletStateCopyWith<WalletState> get copyWith => _$WalletStateCopyWithImpl<WalletState>(this as WalletState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.wallets, wallets)&&(identical(other.dashboardSnapshot, dashboardSnapshot) || other.dashboardSnapshot == dashboardSnapshot)&&(identical(other.selectedWallet, selectedWallet) || other.selectedWallet == selectedWallet)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.sortOption, sortOption) || other.sortOption == sortOption)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(wallets),dashboardSnapshot,selectedWallet,searchQuery,sortOption,errorMessage);

@override
String toString() {
  return 'WalletState(isLoading: $isLoading, wallets: $wallets, dashboardSnapshot: $dashboardSnapshot, selectedWallet: $selectedWallet, searchQuery: $searchQuery, sortOption: $sortOption, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $WalletStateCopyWith<$Res>  {
  factory $WalletStateCopyWith(WalletState value, $Res Function(WalletState) _then) = _$WalletStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<WalletOverview> wallets, WalletDashboardSnapshot? dashboardSnapshot, WalletOverview? selectedWallet, String searchQuery, WalletSortOption sortOption, String? errorMessage
});


$WalletDashboardSnapshotCopyWith<$Res>? get dashboardSnapshot;$WalletOverviewCopyWith<$Res>? get selectedWallet;

}
/// @nodoc
class _$WalletStateCopyWithImpl<$Res>
    implements $WalletStateCopyWith<$Res> {
  _$WalletStateCopyWithImpl(this._self, this._then);

  final WalletState _self;
  final $Res Function(WalletState) _then;

/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? wallets = null,Object? dashboardSnapshot = freezed,Object? selectedWallet = freezed,Object? searchQuery = null,Object? sortOption = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,wallets: null == wallets ? _self.wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<WalletOverview>,dashboardSnapshot: freezed == dashboardSnapshot ? _self.dashboardSnapshot : dashboardSnapshot // ignore: cast_nullable_to_non_nullable
as WalletDashboardSnapshot?,selectedWallet: freezed == selectedWallet ? _self.selectedWallet : selectedWallet // ignore: cast_nullable_to_non_nullable
as WalletOverview?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,sortOption: null == sortOption ? _self.sortOption : sortOption // ignore: cast_nullable_to_non_nullable
as WalletSortOption,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletDashboardSnapshotCopyWith<$Res>? get dashboardSnapshot {
    if (_self.dashboardSnapshot == null) {
    return null;
  }

  return $WalletDashboardSnapshotCopyWith<$Res>(_self.dashboardSnapshot!, (value) {
    return _then(_self.copyWith(dashboardSnapshot: value));
  });
}/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletOverviewCopyWith<$Res>? get selectedWallet {
    if (_self.selectedWallet == null) {
    return null;
  }

  return $WalletOverviewCopyWith<$Res>(_self.selectedWallet!, (value) {
    return _then(_self.copyWith(selectedWallet: value));
  });
}
}


/// Adds pattern-matching-related methods to [WalletState].
extension WalletStatePatterns on WalletState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletState value)  $default,){
final _that = this;
switch (_that) {
case _WalletState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletState value)?  $default,){
final _that = this;
switch (_that) {
case _WalletState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<WalletOverview> wallets,  WalletDashboardSnapshot? dashboardSnapshot,  WalletOverview? selectedWallet,  String searchQuery,  WalletSortOption sortOption,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletState() when $default != null:
return $default(_that.isLoading,_that.wallets,_that.dashboardSnapshot,_that.selectedWallet,_that.searchQuery,_that.sortOption,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<WalletOverview> wallets,  WalletDashboardSnapshot? dashboardSnapshot,  WalletOverview? selectedWallet,  String searchQuery,  WalletSortOption sortOption,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _WalletState():
return $default(_that.isLoading,_that.wallets,_that.dashboardSnapshot,_that.selectedWallet,_that.searchQuery,_that.sortOption,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<WalletOverview> wallets,  WalletDashboardSnapshot? dashboardSnapshot,  WalletOverview? selectedWallet,  String searchQuery,  WalletSortOption sortOption,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _WalletState() when $default != null:
return $default(_that.isLoading,_that.wallets,_that.dashboardSnapshot,_that.selectedWallet,_that.searchQuery,_that.sortOption,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _WalletState extends WalletState {
  const _WalletState({this.isLoading = false, final  List<WalletOverview> wallets = const <WalletOverview>[], this.dashboardSnapshot, this.selectedWallet, this.searchQuery = '', this.sortOption = WalletSortOption.newest, this.errorMessage}): _wallets = wallets,super._();
  

@override@JsonKey() final  bool isLoading;
 final  List<WalletOverview> _wallets;
@override@JsonKey() List<WalletOverview> get wallets {
  if (_wallets is EqualUnmodifiableListView) return _wallets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wallets);
}

@override final  WalletDashboardSnapshot? dashboardSnapshot;
@override final  WalletOverview? selectedWallet;
@override@JsonKey() final  String searchQuery;
@override@JsonKey() final  WalletSortOption sortOption;
@override final  String? errorMessage;

/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletStateCopyWith<_WalletState> get copyWith => __$WalletStateCopyWithImpl<_WalletState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._wallets, _wallets)&&(identical(other.dashboardSnapshot, dashboardSnapshot) || other.dashboardSnapshot == dashboardSnapshot)&&(identical(other.selectedWallet, selectedWallet) || other.selectedWallet == selectedWallet)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.sortOption, sortOption) || other.sortOption == sortOption)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_wallets),dashboardSnapshot,selectedWallet,searchQuery,sortOption,errorMessage);

@override
String toString() {
  return 'WalletState(isLoading: $isLoading, wallets: $wallets, dashboardSnapshot: $dashboardSnapshot, selectedWallet: $selectedWallet, searchQuery: $searchQuery, sortOption: $sortOption, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$WalletStateCopyWith<$Res> implements $WalletStateCopyWith<$Res> {
  factory _$WalletStateCopyWith(_WalletState value, $Res Function(_WalletState) _then) = __$WalletStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<WalletOverview> wallets, WalletDashboardSnapshot? dashboardSnapshot, WalletOverview? selectedWallet, String searchQuery, WalletSortOption sortOption, String? errorMessage
});


@override $WalletDashboardSnapshotCopyWith<$Res>? get dashboardSnapshot;@override $WalletOverviewCopyWith<$Res>? get selectedWallet;

}
/// @nodoc
class __$WalletStateCopyWithImpl<$Res>
    implements _$WalletStateCopyWith<$Res> {
  __$WalletStateCopyWithImpl(this._self, this._then);

  final _WalletState _self;
  final $Res Function(_WalletState) _then;

/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? wallets = null,Object? dashboardSnapshot = freezed,Object? selectedWallet = freezed,Object? searchQuery = null,Object? sortOption = null,Object? errorMessage = freezed,}) {
  return _then(_WalletState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,wallets: null == wallets ? _self._wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<WalletOverview>,dashboardSnapshot: freezed == dashboardSnapshot ? _self.dashboardSnapshot : dashboardSnapshot // ignore: cast_nullable_to_non_nullable
as WalletDashboardSnapshot?,selectedWallet: freezed == selectedWallet ? _self.selectedWallet : selectedWallet // ignore: cast_nullable_to_non_nullable
as WalletOverview?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,sortOption: null == sortOption ? _self.sortOption : sortOption // ignore: cast_nullable_to_non_nullable
as WalletSortOption,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletDashboardSnapshotCopyWith<$Res>? get dashboardSnapshot {
    if (_self.dashboardSnapshot == null) {
    return null;
  }

  return $WalletDashboardSnapshotCopyWith<$Res>(_self.dashboardSnapshot!, (value) {
    return _then(_self.copyWith(dashboardSnapshot: value));
  });
}/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletOverviewCopyWith<$Res>? get selectedWallet {
    if (_self.selectedWallet == null) {
    return null;
  }

  return $WalletOverviewCopyWith<$Res>(_self.selectedWallet!, (value) {
    return _then(_self.copyWith(selectedWallet: value));
  });
}
}

// dart format on
