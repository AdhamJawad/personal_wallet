import '../../../../core/utils/id_generator.dart';
import '../../../../shared/domain/enums/contact_kind.dart';
import '../../domain/models/contact_profile.dart';
import '../../domain/repositories/contact_repository.dart';

class MockContactRepository implements ContactRepository {
  const MockContactRepository();

  @override
  Future<List<ContactProfile>> fetchContacts(String ownerUserId) async {
    final DateTime now = DateTime.now().toUtc();

    return <ContactProfile>[
      ContactProfile(
        id: IdGenerator.next(),
        ownerUserId: ownerUserId,
        kind: ContactKind.registered,
        displayName: 'Ahmad Kareem',
        linkedUserId: 'user_demo_2',
        phoneNumber: '+963900000002',
        qrToken: IdGenerator.next(),
        dualApprovalRequired: false,
        createdAt: now,
        updatedAt: now,
      ),
      ContactProfile(
        id: IdGenerator.next(),
        ownerUserId: ownerUserId,
        kind: ContactKind.external,
        displayName: 'Samer Office',
        phoneNumber: '+963900000003',
        dualApprovalRequired: true,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
