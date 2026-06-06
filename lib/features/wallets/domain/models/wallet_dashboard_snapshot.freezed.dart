// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_dashboard_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletDashboardSnapshot {

 String get ownerUserId; String get totalUsd; String get totalSyp; List<WalletOverview> get walletSummaries; List<WalletActivityItem> get recentActivities;
/// Create a copy of WalletDashboardSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletDashboardSnapshotCopyWith<WalletDashboardSnapshot> get copyWith => _$WalletDashboardSnapshotCopyWithImpl<WalletDashboardSnapshot>(this as WalletDashboardSnapshot, _$identity);

  /// Serializes this WalletDashboardSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletDashboardSnapshot&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.totalUsd, totalUsd) || other.totalUsd == totalUsd)&&(identical(other.totalSyp, totalSyp) || other.totalSyp == totalSyp)&&const DeepCollectionEquality().equals(other.walletSummaries, walletSummaries)&&const DeepCollectionEquality().equals(other.recentActivities, recentActivities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ownerUserId,totalUsd,totalSyp,const DeepCollectionEquality().hash(walletSummaries),const DeepCollectionEquality().hash(recentActivities));

@override
String toString() {
  return 'WalletDashboardSnapshot(ownerUserId: $ownerUserId, totalUsd: $totalUsd, totalSyp: $totalSyp, walletSummaries: $walletSummaries, recentActivities: $recentActivities)';
}


}

/// @nodoc
abstract mixin class $WalletDashboardSnapshotCopyWith<$Res>  {
  factory $WalletDashboardSnapshotCopyWith(WalletDashboardSnapshot value, $Res Function(WalletDashboardSnapshot) _then) = _$WalletDashboardSnapshotCopyWithImpl;
@useResult
$Res call({
 String ownerUserId, String totalUsd, String totalSyp, List<WalletOverview> walletSummaries, List<WalletActivityItem> recentActivities
});




}
/// @nodoc
class _$WalletDashboardSnapshotCopyWithImpl<$Res>
    implements $WalletDashboardSnapshotCopyWith<$Res> {
  _$WalletDashboardSnapshotCopyWithImpl(this._self, this._then);

  final WalletDashboardSnapshot _self;
  final $Res Function(WalletDashboardSnapshot) _then;

/// Create a copy of WalletDashboardSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ownerUserId = null,Object? totalUsd = null,Object? totalSyp = null,Object? walletSummaries = null,Object? recentActivities = null,}) {
  return _then(_self.copyWith(
ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,totalUsd: null == totalUsd ? _self.totalUsd : totalUsd // ignore: cast_nullable_to_non_nullable
as String,totalSyp: null == totalSyp ? _self.totalSyp : totalSyp // ignore: cast_nullable_to_non_nullable
as String,walletSummaries: null == walletSummaries ? _self.walletSummaries : walletSummaries // ignore: cast_nullable_to_non_nullable
as List<WalletOverview>,recentActivities: null == recentActivities ? _self.recentActivities : recentActivities // ignore: cast_nullable_to_non_nullable
as List<WalletActivityItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletDashboardSnapshot].
extension WalletDashboardSnapshotPatterns on WalletDashboardSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletDashboardSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletDashboardSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletDashboardSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _WalletDashboardSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletDashboardSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _WalletDashboardSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ownerUserId,  String totalUsd,  String totalSyp,  List<WalletOverview> walletSummaries,  List<WalletActivityItem> recentActivities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletDashboardSnapshot() when $default != null:
return $default(_that.ownerUserId,_that.totalUsd,_that.totalSyp,_that.walletSummaries,_that.recentActivities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ownerUserId,  String totalUsd,  String totalSyp,  List<WalletOverview> walletSummaries,  List<WalletActivityItem> recentActivities)  $default,) {final _that = this;
switch (_that) {
case _WalletDashboardSnapshot():
return $default(_that.ownerUserId,_that.totalUsd,_that.totalSyp,_that.walletSummaries,_that.recentActivities);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ownerUserId,  String totalUsd,  String totalSyp,  List<WalletOverview> walletSummaries,  List<WalletActivityItem> recentActivities)?  $default,) {final _that = this;
switch (_that) {
case _WalletDashboardSnapshot() when $default != null:
return $default(_that.ownerUserId,_that.totalUsd,_that.totalSyp,_that.walletSummaries,_that.recentActivities);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalletDashboardSnapshot implements WalletDashboardSnapshot {
  const _WalletDashboardSnapshot({required this.ownerUserId, required this.totalUsd, required this.totalSyp, required final  List<WalletOverview> walletSummaries, required final  List<WalletActivityItem> recentActivities}): _walletSummaries = walletSummaries,_recentActivities = recentActivities;
  factory _WalletDashboardSnapshot.fromJson(Map<String, dynamic> json) => _$WalletDashboardSnapshotFromJson(json);

@override final  String ownerUserId;
@override final  String totalUsd;
@override final  String totalSyp;
 final  List<WalletOverview> _walletSummaries;
@override List<WalletOverview> get walletSummaries {
  if (_walletSummaries is EqualUnmodifiableListView) return _walletSummaries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_walletSummaries);
}

 final  List<WalletActivityItem> _recentActivities;
@override List<WalletActivityItem> get recentActivities {
  if (_recentActivities is EqualUnmodifiableListView) return _recentActivities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentActivities);
}


/// Create a copy of WalletDashboardSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletDashboardSnapshotCopyWith<_WalletDashboardSnapshot> get copyWith => __$WalletDashboardSnapshotCopyWithImpl<_WalletDashboardSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletDashboardSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletDashboardSnapshot&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.totalUsd, totalUsd) || other.totalUsd == totalUsd)&&(identical(other.totalSyp, totalSyp) || other.totalSyp == totalSyp)&&const DeepCollectionEquality().equals(other._walletSummaries, _walletSummaries)&&const DeepCollectionEquality().equals(other._recentActivities, _recentActivities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ownerUserId,totalUsd,totalSyp,const DeepCollectionEquality().hash(_walletSummaries),const DeepCollectionEquality().hash(_recentActivities));

@override
String toString() {
  return 'WalletDashboardSnapshot(ownerUserId: $ownerUserId, totalUsd: $totalUsd, totalSyp: $totalSyp, walletSummaries: $walletSummaries, recentActivities: $recentActivities)';
}


}

/// @nodoc
abstract mixin class _$WalletDashboardSnapshotCopyWith<$Res> implements $WalletDashboardSnapshotCopyWith<$Res> {
  factory _$WalletDashboardSnapshotCopyWith(_WalletDashboardSnapshot value, $Res Function(_WalletDashboardSnapshot) _then) = __$WalletDashboardSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String ownerUserId, String totalUsd, String totalSyp, List<WalletOverview> walletSummaries, List<WalletActivityItem> recentActivities
});




}
/// @nodoc
class __$WalletDashboardSnapshotCopyWithImpl<$Res>
    implements _$WalletDashboardSnapshotCopyWith<$Res> {
  __$WalletDashboardSnapshotCopyWithImpl(this._self, this._then);

  final _WalletDashboardSnapshot _self;
  final $Res Function(_WalletDashboardSnapshot) _then;

/// Create a copy of WalletDashboardSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ownerUserId = null,Object? totalUsd = null,Object? totalSyp = null,Object? walletSummaries = null,Object? recentActivities = null,}) {
  return _then(_WalletDashboardSnapshot(
ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,totalUsd: null == totalUsd ? _self.totalUsd : totalUsd // ignore: cast_nullable_to_non_nullable
as String,totalSyp: null == totalSyp ? _self.totalSyp : totalSyp // ignore: cast_nullable_to_non_nullable
as String,walletSummaries: null == walletSummaries ? _self._walletSummaries : walletSummaries // ignore: cast_nullable_to_non_nullable
as List<WalletOverview>,recentActivities: null == recentActivities ? _self._recentActivities : recentActivities // ignore: cast_nullable_to_non_nullable
as List<WalletActivityItem>,
  ));
}


}

// dart format on
