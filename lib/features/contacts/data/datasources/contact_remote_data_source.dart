import '../../../../core/network/remote_data_source.dart';
import '../../../../shared/domain/enums/contact_entity_type.dart';
import '../../domain/models/contact.dart';

abstract interface class ContactRemoteDataSource implements RemoteDataSource {
  Future<Contact> createExternalContact({
    required String ownerUserId,
    required ContactEntityType entityType,
    required String name,
    String? phoneNumber,
    String? emailAddress,
    String? note,
    String? imageUri,
  });
  Future<Contact> createRegisteredContact({
    required String ownerUserId,
    required String linkedUserId,
    required ContactEntityType entityType,
    required String name,
    String? phoneNumber,
    String? emailAddress,
    String? note,
    String? imageUri,
  });
  Future<List<Contact>> fetchContacts(String ownerUserId);
  Future<Contact?> getContactById({
    required String ownerUserId,
    required String contactId,
  });
  Future<Contact?> getContactByLinkedUserId({
    required String ownerUserId,
    required String linkedUserId,
  });
  Future<Contact> updateContact({
    required String ownerUserId,
    required String contactId,
    required ContactEntityType entityType,
    required String name,
    String? phoneNumber,
    String? emailAddress,
    String? note,
    String? imageUri,
  });
  Future<void> deleteContact({
    required String ownerUserId,
    required String contactId,
  });
}
