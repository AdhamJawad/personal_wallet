import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/models/auth_session.dart';
import '../../domain/models/qr_identity.dart';
import '../../domain/repositories/qr_repository.dart';
import 'qr_state.dart';

class QrController extends StateNotifier<QrState> {
  QrController({
    required QrRepository qrRepository,
    required AuthSession? session,
  }) : _qrRepository = qrRepository,
       _session = session,
       super(const QrState()) {
    if (session != null) {
      initialize();
    }
  }

  final QrRepository _qrRepository;
  final AuthSession? _session;

  String get _resolvedOwnerUserId {
    final String? ownerUserId = _session?.user.id;
    if (ownerUserId == null) {
      throw const QrControllerException('No authenticated user found.');
    }
    return ownerUserId;
  }

  Future<void> initialize() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final session = _session;
      if (session == null) {
        throw const QrControllerException('No authenticated user found.');
      }

      final QrIdentity identity = await _qrRepository.fetchIdentity(
        userId: session.user.id,
        displayName: session.user.displayName,
        publicReferenceIdentifier: session.user.personalQrToken,
      );
      final identities = await _qrRepository.fetchKnownIdentities(
        session.user.id,
      );
      state = state.copyWith(
        isLoading: false,
        myIdentity: identity,
        knownIdentities: identities,
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<bool> scanPayload(String payload) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _qrRepository.scanPayload(
        ownerUserId: _resolvedOwnerUserId,
        payload: payload,
      );
      if (result == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'QR payload is invalid or no longer available.',
        );
        return false;
      }
      state = state.copyWith(
        isLoading: false,
        scanResult: result,
        errorMessage: null,
      );
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      return false;
    }
  }

  void clearScan() {
    state = state.copyWith(scanResult: null, errorMessage: null);
  }
}

class QrControllerException implements Exception {
  const QrControllerException(this.message);

  final String message;

  @override
  String toString() => message;
}
