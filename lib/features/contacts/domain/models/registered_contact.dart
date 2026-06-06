import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_time_converter.dart';

part 'registered_contact.freezed.dart';
part 'registered_contact.g.dart';

@freezed
abstract class RegisteredContact with _$RegisteredContact {
  const factory RegisteredContact({
    required String id,
    required String ownerUserId,
    required String linkedUserId,
    required String name,
    String? phoneNumber,
    String? note,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeConverter() required DateTime updatedAt,
  }) = _RegisteredContact;

  factory RegisteredContact.fromJson(Map<String, dynamic> json) =>
      _$RegisteredContactFromJson(json);
}
