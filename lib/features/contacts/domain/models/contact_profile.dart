import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_time_converter.dart';
import '../../../../shared/domain/enums/contact_kind.dart';

part 'contact_profile.freezed.dart';
part 'contact_profile.g.dart';

@freezed
abstract class ContactProfile with _$ContactProfile {
  const factory ContactProfile({
    required String id,
    required String ownerUserId,
    required ContactKind kind,
    required String displayName,
    String? linkedUserId,
    String? phoneNumber,
    String? qrToken,
    required bool dualApprovalRequired,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeConverter() required DateTime updatedAt,
  }) = _ContactProfile;

  factory ContactProfile.fromJson(Map<String, dynamic> json) =>
      _$ContactProfileFromJson(json);
}
