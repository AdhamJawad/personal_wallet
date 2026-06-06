import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/audit_event.dart';
import '../../domain/repositories/audit_repository.dart';
import 'audit_state.dart';

class AuditController extends StateNotifier<AuditState> {
  AuditController({
    required AuditRepository auditRepository,
    required String? ownerUserId,
  }) : _auditRepository = auditRepository,
       _ownerUserId = ownerUserId,
       super(const AuditState()) {
    if (ownerUserId != null) {
      initialize();
    }
  }

  final AuditRepository _auditRepository;
  final String? _ownerUserId;

  String get _resolvedOwnerUserId {
    final String? ownerUserId = _ownerUserId;
    if (ownerUserId == null) {
      throw const AuditControllerException('No authenticated user found.');
    }
    return ownerUserId;
  }

  Future<void> initialize() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final List<AuditEvent> events = await _auditRepository.fetchEvents(
        _resolvedOwnerUserId,
      );
      state = state.copyWith(
        isLoading: false,
        events: events,
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }
}

class AuditControllerException implements Exception {
  const AuditControllerException(this.message);

  final String message;

  @override
  String toString() => message;
}
