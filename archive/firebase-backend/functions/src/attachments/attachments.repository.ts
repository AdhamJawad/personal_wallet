import {Timestamp} from "firebase-admin/firestore";
import {getStorage} from "firebase-admin/storage";

import {APP_CONSTANTS} from "../shared/constants/app.constants.js";
import {db} from "../shared/firestore/firestore.client.js";
import type {
  AttachmentRecord,
  CreateAttachmentInput,
} from "./attachments.types.js";

/**
 * Repository for attachment persistence and storage operations.
 */
export class AttachmentsRepository {
  /**
   * Creates a signed upload URL for a storage object.
   * @param {string} storagePath Cloud Storage object path.
   * @param {string} contentType MIME content type.
   * @return {Promise<string>} Signed upload URL.
   */
  async createUploadUrl(
    storagePath: string,
    contentType: string,
  ): Promise<string> {
    const bucket = getStorage().bucket();
    const [uploadUrl] = await bucket.file(storagePath).getSignedUrl({
      version: "v4",
      action: "write",
      expires:
        Date.now() +
        APP_CONSTANTS.attachments.uploadUrlExpiresInMinutes *
          60 *
          1000,
      contentType,
    });

    return uploadUrl;
  }

  /**
   * Returns storage object metadata if the file exists.
   * @param {string} storagePath Cloud Storage object path.
   * @return {Promise<object | null>} Object metadata if available.
   */
  async getStorageObjectMetadata(
    storagePath: string,
  ): Promise<{size?: string; contentType?: string} | null> {
    const bucket = getStorage().bucket();
    const [exists] = await bucket.file(storagePath).exists();

    if (!exists) {
      return null;
    }

    const [metadata] = await bucket.file(storagePath).getMetadata();

    return {
      size: typeof metadata.size === "string" ? metadata.size : undefined,
      contentType:
        typeof metadata.contentType === "string" ?
          metadata.contentType :
          undefined,
    };
  }

  /**
   * Creates an attachment metadata document.
   * @param {CreateAttachmentInput} input Attachment payload.
   * @return {Promise<AttachmentRecord>} Created attachment record.
   */
  async createAttachment(
    input: CreateAttachmentInput,
  ): Promise<AttachmentRecord> {
    const collectionName = APP_CONSTANTS.firestore.collections.attachments;
    const attachmentRef = db.collection(collectionName).doc();
    const createdAt = Timestamp.now();

    await attachmentRef.create({
      attachmentId: attachmentRef.id,
      ownerUid: input.ownerUid,
      entityType: input.entityType,
      entityId: input.entityId,
      fileName: input.fileName,
      contentType: input.contentType,
      storagePath: input.storagePath,
      fileSize: input.fileSize,
      createdAt,
    });

    return {
      attachmentId: attachmentRef.id,
      ownerUid: input.ownerUid,
      entityType: input.entityType,
      entityId: input.entityId,
      fileName: input.fileName,
      contentType: input.contentType,
      storagePath: input.storagePath,
      fileSize: input.fileSize,
      createdAt: createdAt.toDate(),
    };
  }

  /**
   * Returns attachments for a specific owner and entity.
   * @param {string} ownerUid Firebase Auth UID of the attachment owner.
   * @param {string} entityType Supported entity type.
   * @param {string} entityId Related entity identifier.
   * @return {Promise<AttachmentRecord[]>} Attachment records.
   */
  async getAttachmentsByOwnerAndEntity(
    ownerUid: string,
    entityType: AttachmentRecord["entityType"],
    entityId: string,
  ): Promise<AttachmentRecord[]> {
    const collectionName = APP_CONSTANTS.firestore.collections.attachments;
    const snapshot = await db.collection(collectionName)
      .where("ownerUid", "==", ownerUid)
      .where("entityType", "==", entityType)
      .where("entityId", "==", entityId)
      .orderBy("createdAt", "desc")
      .get();

    return snapshot.docs.map((document) => {
      const data = document.data();

      return {
        attachmentId: data.attachmentId as string,
        ownerUid: data.ownerUid as string,
        entityType: data.entityType as AttachmentRecord["entityType"],
        entityId: data.entityId as string,
        fileName: data.fileName as string,
        contentType: data.contentType as string,
        storagePath: data.storagePath as string,
        fileSize: data.fileSize as number,
        createdAt: this.toDate(data.createdAt),
      };
    });
  }

  /**
   * Converts Firestore timestamps and date-like values to Date.
   * @param {unknown} value Firestore timestamp-like value.
   * @return {Date | undefined} Converted date instance.
   */
  private toDate(value: unknown): Date | undefined {
    if (!value) {
      return undefined;
    }

    if (value instanceof Timestamp) {
      return value.toDate();
    }

    if (value instanceof Date) {
      return value;
    }

    return new Date(value as string);
  }
}
