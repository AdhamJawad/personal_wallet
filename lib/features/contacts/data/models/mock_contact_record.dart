import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/contact.dart';

part 'mock_contact_record.freezed.dart';
part 'mock_contact_record.g.dart';

@freezed
abstract class MockContactRecord with _$MockContactRecord {
  const factory MockContactRecord({required Contact contact}) =
      _MockContactRecord;

  factory MockContactRecord.fromJson(Map<String, dynamic> json) =>
      _$MockContactRecordFromJson(json);
}
