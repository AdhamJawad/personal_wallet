import '../enums/attachment_kind.dart';
import 'attachment_reference.dart';

class Attachment {
  const Attachment({
    required this.id,
    required this.ownerUserId,
    required this.reference,
    required this.kind,
    required this.fileName,
    required this.storagePath,
    this.mimeType,
    this.byteSize,
    this.checksum,
    this.cacheLocalUri,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'] as String,
      ownerUserId: json['ownerUserId'] as String,
      reference: AttachmentReference.fromJson(
        json['reference'] as Map<String, dynamic>,
      ),
      kind: AttachmentKind.values.byName(json['kind'] as String),
      fileName: json['fileName'] as String,
      storagePath: json['storagePath'] as String,
      mimeType: json['mimeType'] as String?,
      byteSize: (json['byteSize'] as num?)?.toInt(),
      checksum: json['checksum'] as String?,
      cacheLocalUri: json['cacheLocalUri'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  final String id;
  final String ownerUserId;
  final AttachmentReference reference;
  final AttachmentKind kind;
  final String fileName;
  final String storagePath;
  final String? mimeType;
  final int? byteSize;
  final String? checksum;
  final String? cacheLocalUri;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get localUri => cacheLocalUri ?? storagePath;

  Attachment copyWith({
    String? id,
    String? ownerUserId,
    AttachmentReference? reference,
    AttachmentKind? kind,
    String? fileName,
    String? storagePath,
    String? mimeType,
    int? byteSize,
    String? checksum,
    String? cacheLocalUri,
    bool clearCacheLocalUri = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Attachment(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      reference: reference ?? this.reference,
      kind: kind ?? this.kind,
      fileName: fileName ?? this.fileName,
      storagePath: storagePath ?? this.storagePath,
      mimeType: mimeType ?? this.mimeType,
      byteSize: byteSize ?? this.byteSize,
      checksum: checksum ?? this.checksum,
      cacheLocalUri: clearCacheLocalUri
          ? null
          : cacheLocalUri ?? this.cacheLocalUri,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'ownerUserId': ownerUserId,
    'reference': reference.toJson(),
    'kind': kind.name,
    'fileName': fileName,
    'storagePath': storagePath,
    'mimeType': mimeType,
    'byteSize': byteSize,
    'checksum': checksum,
    'cacheLocalUri': cacheLocalUri,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
