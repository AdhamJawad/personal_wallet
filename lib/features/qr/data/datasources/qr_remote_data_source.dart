import '../../../../core/network/remote_data_source.dart';
import '../../domain/models/qr_identity.dart';
import '../../domain/models/qr_scan_result.dart';

abstract interface class QrRemoteDataSource implements RemoteDataSource {
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
