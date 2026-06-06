import '../../../../core/utils/id_generator.dart';
import '../../domain/models/qr_profile.dart';
import '../../domain/repositories/qr_repository.dart';

class MockQrRepository implements QrRepository {
  const MockQrRepository();

  @override
  Future<QrProfile?> fetchProfile(String userId) async {
    final DateTime now = DateTime.now().toUtc();

    return QrProfile(
      userId: userId,
      transferToken: IdGenerator.next(),
      contactToken: IdGenerator.next(),
      createdAt: now,
      updatedAt: now,
    );
  }
}
