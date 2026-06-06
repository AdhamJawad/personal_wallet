import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/attachment.dart';
import '../../domain/models/attachment_reference.dart';

part 'attachment_state.freezed.dart';

@freezed
abstract class AttachmentState with _$AttachmentState {
  const factory AttachmentState({
    @Default(false) bool isLoading,
    @Default(<Attachment>[]) List<Attachment> attachments,
    AttachmentReference? activeReference,
    String? errorMessage,
  }) = _AttachmentState;
}
