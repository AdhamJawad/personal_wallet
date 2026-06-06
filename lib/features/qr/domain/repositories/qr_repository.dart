import '../models/qr_profile.dart';

abstract interface class QrRepository {
  Future<QrProfile?> fetchProfile(String userId);
}
