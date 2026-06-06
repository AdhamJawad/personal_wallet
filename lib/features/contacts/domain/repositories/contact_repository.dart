import '../models/contact.dart';

abstract interface class ContactRepository {
  Future<Contact> createExternalContact({
    required String ownerUserId,
    required String name,
    String? phoneNumber,
    String? note,
  });
  Future<Contact> createRegisteredContact({
    required String ownerUserId,
    required String linkedUserId,
    required String name,
    String? phoneNumber,
    String? note,
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
}
