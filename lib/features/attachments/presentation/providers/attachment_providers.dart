import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/sync/providers/sync_providers.dart';
import '../../../audit/presentation/providers/audit_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/mock_attachment_repository.dart';
import '../../domain/repositories/attachment_repository.dart';
import '../controllers/attachment_controller.dart';
import '../controllers/attachment_state.dart';

final attachmentRepositoryProvider = Provider<AttachmentRepository>((Ref ref) {
  return MockAttachmentRepository(
    localStore: ref.watch(localStoreProvider),
    syncQueueRepository: ref.watch(syncQueueRepositoryProvider),
    auditLogger: ref.watch(auditLoggerProvider),
  );
});

final attachmentControllerProvider =
    StateNotifierProvider<AttachmentController, AttachmentState>((Ref ref) {
      final authState = ref.watch(authControllerProvider);
      return AttachmentController(
        attachmentRepository: ref.watch(attachmentRepositoryProvider),
        ownerUserId: authState.session?.user.id,
      );
    });
