import '../models/qr_identity.dart';
import '../models/qr_scan_result.dart';

abstract interface class QrRepository {
  Future<QrIdentity> fetchIdentity({
    required String userId,
    required String displayName,
    required String publicReferenceIdentifier,
  });
  Future<List<QrIdentity>> fetchKnownIdentities(String ownerUserId);
  Future<QrScanResult?> scanPayload({
    required String ownerUserId,
    required String payload,
  });
}
