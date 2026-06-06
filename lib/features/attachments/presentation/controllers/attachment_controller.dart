import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/attachment_draft.dart';
import '../../domain/models/attachment_reference.dart';
import '../../domain/repositories/attachment_repository.dart';
import 'attachment_state.dart';

class AttachmentController extends StateNotifier<AttachmentState> {
  AttachmentController({
    required AttachmentRepository attachmentRepository,
    required String? ownerUserId,
  }) : _attachmentRepository = attachmentRepository,
       _ownerUserId = ownerUserId,
       super(const AttachmentState());

  final AttachmentRepository _attachmentRepository;
  final String? _ownerUserId;

  String get _resolvedOwnerUserId {
    final String? ownerUserId = _ownerUserId;
    if (ownerUserId == null) {
      throw const AttachmentControllerException('No authenticated user found.');
    }
    return ownerUserId;
  }

  Future<bool> createAttachments({
    required AttachmentReference reference,
    required List<AttachmentDraft> drafts,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _attachmentRepository.createAttachments(
        ownerUserId: _resolvedOwnerUserId,
        reference: reference,
        drafts: drafts,
      );
      await loadReference(reference);
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      return false;
    }
  }

  Future<void> loadReference(AttachmentReference reference) async {
    state = state.copyWith(
      isLoading: true,
      activeReference: reference,
      errorMessage: null,
    );
    try {
      final attachments = await _attachmentRepository.fetchAttachments(
        ownerUserId: _resolvedOwnerUserId,
        reference: reference,
      );
      state = state.copyWith(
        isLoading: false,
        attachments: attachments,
        activeReference: reference,
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }
}

class AttachmentControllerException implements Exception {
  const AttachmentControllerException(this.message);

  final String message;

  @override
  String toString() => message;
}
