import {randomUUID} from "crypto";

import {DebtsRepository} from "../debts/debts.repository.js";
import {appLogger} from "../shared/utils/logger.js";
import {TransfersRepository} from "../transfers/transfers.repository.js";
import {WalletsRepository} from "../wallets/wallets.repository.js";
import {
  AttachmentUploadCompletionError,
  InvalidAttachmentEntityError,
  UnauthorizedAttachmentEntityAccessError,
} from "./attachments.errors.js";
import {AttachmentsRepository} from "./attachments.repository.js";
import type {
  AttachmentEntityType,
  AttachmentRecord,
  CompleteAttachmentUploadInput,
  CreateAttachmentUploadUrlInput,
  CreateAttachmentUploadUrlResponse,
} from "./attachments.types.js";

/**
 * Service for attachment workflows.
 */
export class AttachmentsService {
  /**
   * Creates an attachments service instance.
   * @param {AttachmentsRepository} attachmentsRepository
   * Attachment repository dependency.
   * @param {WalletsRepository} walletsRepository Wallet repository dependency.
   * @param {DebtsRepository} debtsRepository Debts repository dependency.
   * @param {TransfersRepository} transfersRepository
   * Transfers repository dependency.
   */
  constructor(
    private readonly attachmentsRepository: AttachmentsRepository =
    new AttachmentsRepository(),
    private readonly walletsRepository: WalletsRepository =
    new WalletsRepository(),
    private readonly debtsRepository: DebtsRepository = new DebtsRepository(),
    private readonly transfersRepository: TransfersRepository =
    new TransfersRepository(),
  ) {}

  /**
   * Creates a signed upload URL for an owned entity attachment.
   * @param {CreateAttachmentUploadUrlInput} input Upload URL request payload.
   * @return {Promise<CreateAttachmentUploadUrlResponse>} Upload URL response.
   */
  async createAttachmentUploadUrl(
    input: CreateAttachmentUploadUrlInput,
  ): Promise<CreateAttachmentUploadUrlResponse> {
    await this.assertEntityOwnership(
      input.ownerUid,
      input.entityType,
      input.entityId,
    );

    const storagePath = this.buildStoragePath(
      input.ownerUid,
      input.entityType,
      input.entityId,
      input.fileName,
    );
    const uploadUrl = await this.attachmentsRepository.createUploadUrl(
      storagePath,
      input.contentType,
    );

    appLogger.info("Attachment upload URL created successfully.", {
      event: "attachments.upload_url.completed",
      ownerUid: input.ownerUid,
      entityType: input.entityType,
      entityId: input.entityId,
      storagePath,
    });

    return {
      uploadUrl,
      storagePath,
    };
  }

  /**
   * Completes an attachment upload by storing Firestore metadata.
   * @param {CompleteAttachmentUploadInput} input Attachment completion payload.
   * @return {Promise<AttachmentRecord>} Created attachment record.
   */
  async completeAttachmentUpload(
    input: CompleteAttachmentUploadInput,
  ): Promise<AttachmentRecord> {
    await this.assertEntityOwnership(
      input.ownerUid,
      input.entityType,
      input.entityId,
    );

    const expectedPrefix = this.getStoragePrefix(
      input.ownerUid,
      input.entityType,
      input.entityId,
    );

    if (!input.storagePath.startsWith(expectedPrefix)) {
      appLogger.warn("Attachment storage path failed ownership validation.", {
        event: "attachments.complete.invalid_storage_path",
        ownerUid: input.ownerUid,
        entityType: input.entityType,
        entityId: input.entityId,
        storagePath: input.storagePath,
      });
      throw new UnauthorizedAttachmentEntityAccessError();
    }

    try {
      const objectMetadata = await this.attachmentsRepository
        .getStorageObjectMetadata(input.storagePath);

      if (!objectMetadata) {
        throw new AttachmentUploadCompletionError();
      }

      const attachment = await this.attachmentsRepository.createAttachment({
        ownerUid: input.ownerUid,
        entityType: input.entityType,
        entityId: input.entityId,
        fileName: input.fileName,
        contentType: objectMetadata.contentType ?? input.contentType,
        storagePath: input.storagePath,
        fileSize:
          Number(objectMetadata.size) > 0 ?
            Number(objectMetadata.size) :
            input.fileSize,
      });

      appLogger.info("Attachment upload completed successfully.", {
        event: "attachments.complete.completed",
        ownerUid: input.ownerUid,
        attachmentId: attachment.attachmentId,
        entityType: input.entityType,
        entityId: input.entityId,
      });

      return attachment;
    } catch (error) {
      if (error instanceof AttachmentUploadCompletionError) {
        throw error;
      }

      appLogger.error("Attachment upload completion failed.", {
        event: "attachments.complete.failed",
        ownerUid: input.ownerUid,
        entityType: input.entityType,
        entityId: input.entityId,
        storagePath: input.storagePath,
        error: error instanceof Error ? error.message : "unknown_error",
      });
      throw new AttachmentUploadCompletionError();
    }
  }

  /**
   * Returns attachments for an owned entity.
   * @param {string} ownerUid Firebase Auth UID of the attachment owner.
   * @param {AttachmentEntityType} entityType Supported entity type.
   * @param {string} entityId Related entity identifier.
   * @return {Promise<AttachmentRecord[]>} Attachment records.
   */
  async getAttachments(
    ownerUid: string,
    entityType: AttachmentEntityType,
    entityId: string,
  ): Promise<AttachmentRecord[]> {
    await this.assertEntityOwnership(ownerUid, entityType, entityId);

    return this.attachmentsRepository.getAttachmentsByOwnerAndEntity(
      ownerUid,
      entityType,
      entityId,
    );
  }

  /**
   * Ensures the authenticated user has access to the target entity.
   * @param {string} ownerUid Firebase Auth UID of the caller.
   * @param {AttachmentEntityType} entityType Supported entity type.
   * @param {string} entityId Related entity identifier.
   * @return {Promise<void>} Resolves when ownership is confirmed.
   */
  private async assertEntityOwnership(
    ownerUid: string,
    entityType: AttachmentEntityType,
    entityId: string,
  ): Promise<void> {
    switch (entityType) {
    case "wallet": {
      const wallet = await this.walletsRepository.getWalletById(entityId);

      if (!wallet) {
        throw new InvalidAttachmentEntityError();
      }

      if (wallet.ownerUid !== ownerUid) {
        throw new UnauthorizedAttachmentEntityAccessError();
      }

      return;
    }
    case "debt": {
      const debt = await this.debtsRepository.getDebtById(entityId);

      if (!debt) {
        throw new InvalidAttachmentEntityError();
      }

      if (debt.ownerUid !== ownerUid) {
        throw new UnauthorizedAttachmentEntityAccessError();
      }

      return;
    }
    case "settlement": {
      const settlement = await this.debtsRepository.getSettlementById(entityId);

      if (!settlement) {
        throw new InvalidAttachmentEntityError();
      }

      if (settlement.ownerUid !== ownerUid) {
        throw new UnauthorizedAttachmentEntityAccessError();
      }

      return;
    }
    case "transfer": {
      const transfer = await this.transfersRepository.getTransferById(entityId);

      if (!transfer) {
        throw new InvalidAttachmentEntityError();
      }

      if (
        transfer.senderUid !== ownerUid &&
        transfer.receiverUid !== ownerUid
      ) {
        throw new UnauthorizedAttachmentEntityAccessError();
      }

      return;
    }
    }
  }

  /**
   * Returns the storage prefix for an owner's entity attachments.
   * @param {string} ownerUid Firebase Auth UID of the attachment owner.
   * @param {AttachmentEntityType} entityType Supported entity type.
   * @param {string} entityId Related entity identifier.
   * @return {string} Storage prefix.
   */
  private getStoragePrefix(
    ownerUid: string,
    entityType: AttachmentEntityType,
    entityId: string,
  ): string {
    return `attachments/${ownerUid}/${entityType}/${entityId}/`;
  }

  /**
   * Builds a Cloud Storage path for an attachment upload.
   * @param {string} ownerUid Firebase Auth UID of the attachment owner.
   * @param {AttachmentEntityType} entityType Supported entity type.
   * @param {string} entityId Related entity identifier.
   * @param {string} fileName Original client file name.
   * @return {string} Cloud Storage object path.
   */
  private buildStoragePath(
    ownerUid: string,
    entityType: AttachmentEntityType,
    entityId: string,
    fileName: string,
  ): string {
    const safeFileName = fileName.replace(/[^a-zA-Z0-9._-]/g, "_");
    const storagePrefix = this.getStoragePrefix(ownerUid, entityType, entityId);

    return `${storagePrefix}${randomUUID()}-${safeFileName}`;
  }
}
