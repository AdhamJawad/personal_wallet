import {CallableRequest, HttpsError, onCall} from "firebase-functions/https";

import {APP_CONSTANTS} from "../shared/constants/app.constants.js";
import {AppError} from "../shared/errors/app.error.js";
import {ValidationError} from "../shared/errors/validation.error.js";
import {appLogger} from "../shared/utils/logger.js";
import {
  AttachmentUploadCompletionError,
  AttachmentsUnauthenticatedError,
  InvalidAttachmentEntityError,
  UnauthorizedAttachmentEntityAccessError,
} from "./attachments.errors.js";
import {AttachmentsService} from "./attachments.service.js";
import type {
  AttachmentEntityType,
  AttachmentRecord,
  CompleteAttachmentUploadRequest,
  CreateAttachmentUploadUrlRequest,
  CreateAttachmentUploadUrlResponse,
  GetAttachmentsRequest,
} from "./attachments.types.js";

/**
 * Controller for the attachments module.
 */
export class AttachmentsController {
  /**
   * Creates an attachments controller instance.
   * @param {AttachmentsService} attachmentsService
   * Attachment service dependency.
   */
  constructor(
    private readonly attachmentsService: AttachmentsService =
    new AttachmentsService(),
  ) {}

  /**
   * Creates a signed upload URL for an owned entity attachment.
   * @return {unknown} Callable Firebase function handler.
   */
  createAttachmentUploadUrl() {
    return onCall<CreateAttachmentUploadUrlRequest>(
      {region: APP_CONSTANTS.region},
      async (request): Promise<CreateAttachmentUploadUrlResponse> => {
        const ownerUid = this.requireAuthenticatedUid(request);
        const payload = this.validateCreateAttachmentUploadUrlRequest(
          request.data,
        );

        appLogger.info("Create attachment upload URL request received.", {
          event: "attachments.upload_url.requested",
          ownerUid,
          entityType: payload.entityType,
          entityId: payload.entityId,
        });

        try {
          return await this.attachmentsService.createAttachmentUploadUrl({
            ownerUid,
            ...payload,
          });
        } catch (error) {
          appLogger.error("Create attachment upload URL request failed.", {
            event: "attachments.upload_url.error",
            ownerUid,
            entityType: payload.entityType,
            entityId: payload.entityId,
            error: error instanceof Error ? error.message : "unknown_error",
          });
          throw this.toHttpsError(
            error,
            "Failed to create attachment upload URL.",
          );
        }
      },
    );
  }

  /**
   * Completes an attachment upload for an owned entity.
   * @return {unknown} Callable Firebase function handler.
   */
  completeAttachmentUpload() {
    return onCall<CompleteAttachmentUploadRequest>(
      {region: APP_CONSTANTS.region},
      async (request): Promise<AttachmentRecord> => {
        const ownerUid = this.requireAuthenticatedUid(request);
        const payload = this.validateCompleteAttachmentUploadRequest(
          request.data,
        );

        appLogger.info("Complete attachment upload request received.", {
          event: "attachments.complete.requested",
          ownerUid,
          entityType: payload.entityType,
          entityId: payload.entityId,
          storagePath: payload.storagePath,
        });

        try {
          return await this.attachmentsService.completeAttachmentUpload({
            ownerUid,
            ...payload,
          });
        } catch (error) {
          appLogger.error("Complete attachment upload request failed.", {
            event: "attachments.complete.error",
            ownerUid,
            entityType: payload.entityType,
            entityId: payload.entityId,
            storagePath: payload.storagePath,
            error: error instanceof Error ? error.message : "unknown_error",
          });
          throw this.toHttpsError(
            error,
            "Failed to complete attachment upload.",
          );
        }
      },
    );
  }

  /**
   * Returns attachments for an owned entity.
   * @return {unknown} Callable Firebase function handler.
   */
  getAttachments() {
    return onCall<GetAttachmentsRequest>(
      {region: APP_CONSTANTS.region},
      async (request): Promise<AttachmentRecord[]> => {
        const ownerUid = this.requireAuthenticatedUid(request);
        const payload = this.validateGetAttachmentsRequest(request.data);

        appLogger.info("Get attachments request received.", {
          event: "attachments.list.requested",
          ownerUid,
          entityType: payload.entityType,
          entityId: payload.entityId,
        });

        try {
          return await this.attachmentsService.getAttachments(
            ownerUid,
            payload.entityType,
            payload.entityId,
          );
        } catch (error) {
          appLogger.error("Get attachments request failed.", {
            event: "attachments.list.error",
            ownerUid,
            entityType: payload.entityType,
            entityId: payload.entityId,
            error: error instanceof Error ? error.message : "unknown_error",
          });
          throw this.toHttpsError(error, "Failed to load attachments.");
        }
      },
    );
  }

  /**
   * Extracts the authenticated Firebase UID from the callable request.
   * @param {CallableRequest<unknown>} request Callable request.
   * @return {string} Authenticated Firebase UID.
   */
  private requireAuthenticatedUid(request: CallableRequest<unknown>): string {
    const uid = request.auth?.uid;

    if (!uid) {
      throw new AttachmentsUnauthenticatedError();
    }

    return uid;
  }

  /**
   * Validates the create upload URL request input.
   * @param {CreateAttachmentUploadUrlRequest | undefined} data Request payload.
   * @return {object} Normalized request payload.
   */
  private validateCreateAttachmentUploadUrlRequest(
    data: CreateAttachmentUploadUrlRequest | undefined,
  ): {
    entityType: AttachmentEntityType;
    entityId: string;
    fileName: string;
    contentType: string;
  } {
    return {
      entityType: this.validateEntityType(data?.entityType),
      entityId: this.validateEntityId(data?.entityId),
      fileName: this.validateFileName(data?.fileName),
      contentType: this.validateContentType(data?.contentType),
    };
  }

  /**
   * Validates the complete upload request input.
   * @param {CompleteAttachmentUploadRequest | undefined} data Request payload.
   * @return {object} Normalized request payload.
   */
  private validateCompleteAttachmentUploadRequest(
    data: CompleteAttachmentUploadRequest | undefined,
  ): {
    entityType: AttachmentEntityType;
    entityId: string;
    fileName: string;
    contentType: string;
    storagePath: string;
    fileSize: number;
  } {
    if (typeof data?.storagePath !== "string" || !data.storagePath.trim()) {
      throw new ValidationError("A valid storagePath is required.", {
        field: "storagePath",
      });
    }

    if (typeof data?.fileSize !== "number" || Number.isNaN(data.fileSize)) {
      throw new ValidationError("A valid fileSize is required.", {
        field: "fileSize",
      });
    }

    return {
      entityType: this.validateEntityType(data.entityType),
      entityId: this.validateEntityId(data.entityId),
      fileName: this.validateFileName(data.fileName),
      contentType: this.validateContentType(data.contentType),
      storagePath: data.storagePath.trim(),
      fileSize: data.fileSize,
    };
  }

  /**
   * Validates the get attachments request input.
   * @param {GetAttachmentsRequest | undefined} data Request payload.
   * @return {object} Normalized request payload.
   */
  private validateGetAttachmentsRequest(
    data: GetAttachmentsRequest | undefined,
  ): {entityType: AttachmentEntityType; entityId: string} {
    return {
      entityType: this.validateEntityType(data?.entityType),
      entityId: this.validateEntityId(data?.entityId),
    };
  }

  /**
   * Validates an attachment entity type.
   * @param {unknown} entityType Candidate entity type.
   * @return {AttachmentEntityType} Validated entity type.
   */
  private validateEntityType(entityType: unknown): AttachmentEntityType {
    if (typeof entityType !== "string") {
      throw new ValidationError("A valid entityType is required.", {
        field: "entityType",
      });
    }

    const normalizedEntityType = entityType.trim();

    if (
      normalizedEntityType !== "debt" &&
      normalizedEntityType !== "transfer" &&
      normalizedEntityType !== "wallet" &&
      normalizedEntityType !== "settlement"
    ) {
      throw new ValidationError("entityType is invalid.", {
        field: "entityType",
      });
    }

    return normalizedEntityType;
  }

  /**
   * Validates an entity identifier.
   * @param {unknown} entityId Candidate entity identifier.
   * @return {string} Normalized entity identifier.
   */
  private validateEntityId(entityId: unknown): string {
    if (typeof entityId !== "string" || !entityId.trim()) {
      throw new ValidationError("A valid entityId is required.", {
        field: "entityId",
      });
    }

    return entityId.trim();
  }

  /**
   * Validates a file name value.
   * @param {unknown} fileName Candidate file name.
   * @return {string} Normalized file name.
   */
  private validateFileName(fileName: unknown): string {
    if (typeof fileName !== "string" || !fileName.trim()) {
      throw new ValidationError("A valid fileName is required.", {
        field: "fileName",
      });
    }

    return fileName.trim();
  }

  /**
   * Validates a content type value.
   * @param {unknown} contentType Candidate content type.
   * @return {string} Normalized content type.
   */
  private validateContentType(contentType: unknown): string {
    if (typeof contentType !== "string" || !contentType.trim()) {
      throw new ValidationError("A valid contentType is required.", {
        field: "contentType",
      });
    }

    return contentType.trim();
  }

  /**
   * Maps internal application errors to callable HTTPS errors.
   * @param {unknown} error Error raised by the attachments layer.
   * @param {string} fallbackMessage Fallback error message.
   * @return {HttpsError} Callable-friendly error response.
   */
  private toHttpsError(error: unknown, fallbackMessage: string): HttpsError {
    if (error instanceof HttpsError) {
      return error;
    }

    if (error instanceof ValidationError) {
      return new HttpsError("invalid-argument", error.message, error.details);
    }

    if (error instanceof AttachmentsUnauthenticatedError) {
      return new HttpsError("unauthenticated", error.message, error.details);
    }

    if (error instanceof InvalidAttachmentEntityError) {
      return new HttpsError("not-found", error.message, error.details);
    }

    if (error instanceof UnauthorizedAttachmentEntityAccessError) {
      return new HttpsError("permission-denied", error.message, error.details);
    }

    if (error instanceof AttachmentUploadCompletionError) {
      return new HttpsError(
        "failed-precondition",
        error.message,
        error.details,
      );
    }

    if (error instanceof AppError) {
      return new HttpsError("internal", error.message, error.details);
    }

    return new HttpsError("internal", fallbackMessage);
  }
}
