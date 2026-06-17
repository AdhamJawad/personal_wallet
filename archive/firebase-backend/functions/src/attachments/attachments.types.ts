export type AttachmentEntityType =
  | "debt"
  | "transfer"
  | "wallet"
  | "settlement";

export interface AttachmentRecord {
  attachmentId: string;
  ownerUid: string;
  entityType: AttachmentEntityType;
  entityId: string;
  fileName: string;
  contentType: string;
  storagePath: string;
  fileSize: number;
  createdAt?: Date;
}

export interface CreateAttachmentUploadUrlRequest {
  entityType: string;
  entityId: string;
  fileName: string;
  contentType: string;
}

export interface CreateAttachmentUploadUrlInput {
  ownerUid: string;
  entityType: AttachmentEntityType;
  entityId: string;
  fileName: string;
  contentType: string;
}

export interface CreateAttachmentUploadUrlResponse {
  uploadUrl: string;
  storagePath: string;
}

export interface CompleteAttachmentUploadRequest {
  entityType: string;
  entityId: string;
  fileName: string;
  contentType: string;
  storagePath: string;
  fileSize: number;
}

export interface CompleteAttachmentUploadInput {
  ownerUid: string;
  entityType: AttachmentEntityType;
  entityId: string;
  fileName: string;
  contentType: string;
  storagePath: string;
  fileSize: number;
}

export interface CreateAttachmentInput {
  ownerUid: string;
  entityType: AttachmentEntityType;
  entityId: string;
  fileName: string;
  contentType: string;
  storagePath: string;
  fileSize: number;
}

export interface GetAttachmentsRequest {
  entityType: string;
  entityId: string;
}
