// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'future_link_candidate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FutureLinkCandidate _$FutureLinkCandidateFromJson(Map<String, dynamic> json) =>
    _FutureLinkCandidate(
      externalContactId: json['externalContactId'] as String,
      matchingRegisteredUserId: json['matchingRegisteredUserId'] as String?,
      ownerApprovalRequired: json['ownerApprovalRequired'] as bool,
      contactApprovalRequired: json['contactApprovalRequired'] as bool,
      detectedAt: const DateTimeConverter().fromJson(
        json['detectedAt'] as String,
      ),
    );

Map<String, dynamic> _$FutureLinkCandidateToJson(
  _FutureLinkCandidate instance,
) => <String, dynamic>{
  'externalContactId': instance.externalContactId,
  'matchingRegisteredUserId': instance.matchingRegisteredUserId,
  'ownerApprovalRequired': instance.ownerApprovalRequired,
  'contactApprovalRequired': instance.contactApprovalRequired,
  'detectedAt': const DateTimeConverter().toJson(instance.detectedAt),
};
