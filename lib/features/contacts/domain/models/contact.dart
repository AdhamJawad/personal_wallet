import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_time_converter.dart';
import '../../../../shared/domain/enums/contact_entity_type.dart';
import '../../../../shared/domain/enums/contact_kind.dart';
import 'future_link_candidate.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

@freezed
abstract class Contact with _$Contact {
  const factory Contact({
    required String id,
    required String ownerUserId,
    required ContactKind kind,
    @Default(ContactEntityType.person) ContactEntityType entityType,
    required String name,
    String? phoneNumber,
    String? emailAddress,
    String? note,
    String? imageUri,
    String? linkedUserId,
    FutureLinkCandidate? futureLinkCandidate,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeConverter() required DateTime updatedAt,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}
