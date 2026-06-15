import '../../domain/models/attachment.dart';
import '../../domain/models/attachment_reference.dart';

class AttachmentState {
  const AttachmentState({
    this.isLoading = false,
    this.attachments = const <Attachment>[],
    this.activeReference,
    this.errorMessage,
  });

  final bool isLoading;
  final List<Attachment> attachments;
  final AttachmentReference? activeReference;
  final String? errorMessage;

  AttachmentState copyWith({
    bool? isLoading,
    List<Attachment>? attachments,
    AttachmentReference? activeReference,
    bool clearActiveReference = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return AttachmentState(
      isLoading: isLoading ?? this.isLoading,
      attachments: attachments ?? this.attachments,
      activeReference: clearActiveReference
          ? null
          : activeReference ?? this.activeReference,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AttachmentState &&
            other.isLoading == isLoading &&
            _listEquals(other.attachments, attachments) &&
            other.activeReference == activeReference &&
            other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(
    isLoading,
    Object.hashAll(attachments),
    activeReference,
    errorMessage,
  );
}

bool _listEquals(List<Object?> left, List<Object?> right) {
  if (identical(left, right)) {
    return true;
  }
  if (left.length != right.length) {
    return false;
  }
  for (int index = 0; index < left.length; index++) {
    if (left[index] != right[index]) {
      return false;
    }
  }
  return true;
}
