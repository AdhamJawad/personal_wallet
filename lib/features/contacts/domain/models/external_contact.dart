import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_time_converter.dart';
import 'future_link_candidate.dart';

part 'external_contact.freezed.dart';
part 'external_contact.g.dart';

@freezed
abstract class ExternalContact with _$ExternalContact {
  const factory ExternalContact({
    required String id,
    required String ownerUserId,
    required String name,
    String? phoneNumber,
    String? note,
    FutureLinkCandidate? futureLinkCandidate,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeConverter() required DateTime updatedAt,
  }) = _ExternalContact;

  factory ExternalContact.fromJson(Map<String, dynamic> json) =>
      _$ExternalContactFromJson(json);
}
