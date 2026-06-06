import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_time_converter.dart';

part 'future_link_candidate.freezed.dart';
part 'future_link_candidate.g.dart';

@freezed
abstract class FutureLinkCandidate with _$FutureLinkCandidate {
  const factory FutureLinkCandidate({
    required String externalContactId,
    String? matchingRegisteredUserId,
    required bool ownerApprovalRequired,
    required bool contactApprovalRequired,
    @DateTimeConverter() required DateTime detectedAt,
  }) = _FutureLinkCandidate;

  factory FutureLinkCandidate.fromJson(Map<String, dynamic> json) =>
      _$FutureLinkCandidateFromJson(json);
}
