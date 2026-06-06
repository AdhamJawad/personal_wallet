import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/mock_audit_repository.dart';
import '../../domain/repositories/audit_repository.dart';
import '../../domain/services/audit_logger.dart';
import '../controllers/audit_controller.dart';
import '../controllers/audit_state.dart';

final auditRepositoryProvider = Provider<AuditRepository>((Ref ref) {
  return MockAuditRepository(ref.watch(localStoreProvider));
});

final auditLoggerProvider = Provider<AuditLogger>((Ref ref) {
  return AuditLogger(ref.watch(auditRepositoryProvider));
});

final auditControllerProvider =
    StateNotifierProvider<AuditController, AuditState>((Ref ref) {
      final authState = ref.watch(authControllerProvider);
      return AuditController(
        auditRepository: ref.watch(auditRepositoryProvider),
        ownerUserId: authState.session?.user.id,
      );
    });
