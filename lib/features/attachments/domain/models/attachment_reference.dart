import '../enums/attachment_reference_type.dart';

class AttachmentReference {
  const AttachmentReference({
    required this.entityType,
    required this.entityId,
    this.label,
  });

  factory AttachmentReference.fromJson(Map<String, dynamic> json) {
    return AttachmentReference(
      entityType: AttachmentReferenceType.values.byName(
        json['entityType'] as String,
      ),
      entityId: json['entityId'] as String,
      label: null,
    );
  }

  final AttachmentReferenceType entityType;
  final String entityId;
  final String? label;

  AttachmentReferenceType get type => entityType;

  AttachmentReference copyWith({
    AttachmentReferenceType? entityType,
    String? entityId,
    String? label,
  }) {
    return AttachmentReference(
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      label: label ?? this.label,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'entityType': entityType.name,
    'entityId': entityId,
  };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AttachmentReference &&
            other.entityType == entityType &&
            other.entityId == entityId;
  }

  @override
  int get hashCode => Object.hash(entityType, entityId);
}
