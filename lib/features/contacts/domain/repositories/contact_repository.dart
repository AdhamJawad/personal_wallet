import '../models/contact_profile.dart';

abstract interface class ContactRepository {
  Future<List<ContactProfile>> fetchContacts(String ownerUserId);
}
