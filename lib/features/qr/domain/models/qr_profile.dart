import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_time_converter.dart';

part 'qr_profile.freezed.dart';
part 'qr_profile.g.dart';

@freezed
abstract class QrProfile with _$QrProfile {
  const factory QrProfile({
    required String userId,
    required String transferToken,
    required String contactToken,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeConverter() required DateTime updatedAt,
  }) = _QrProfile;

  factory QrProfile.fromJson(Map<String, dynamic> json) =>
      _$QrProfileFromJson(json);
}
