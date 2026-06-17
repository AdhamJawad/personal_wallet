import {AppError} from "../shared/errors/app.error.js";

/**
 * Error raised when an authenticated Firebase user is required.
 */
export class AttachmentsUnauthenticatedError extends AppError {
  /**
   * Creates an unauthenticated attachments access error.
   */
  constructor() {
    super("Authentication is required.", "unauthenticated", 401);
    this.name = "AttachmentsUnauthenticatedError";
  }
}

/**
 * Error raised when an attachment entity is invalid or not found.
 */
export class InvalidAttachmentEntityError extends AppError {
  /**
   * Creates an invalid attachment entity error.
   */
  constructor() {
    super("Attachment entity is invalid.", "internal", 404);
    this.name = "InvalidAttachmentEntityError";
  }
}

/**
 * Error raised when the user does not own the attachment entity.
 */
export class UnauthorizedAttachmentEntityAccessError extends AppError {
  /**
   * Creates an unauthorized attachment entity access error.
   */
  constructor() {
    super("You do not have access to this entity.", "forbidden", 403);
    this.name = "UnauthorizedAttachmentEntityAccessError";
  }
}

/**
 * Error raised when attachment upload completion fails.
 */
export class AttachmentUploadCompletionError extends AppError {
  /**
   * Creates an attachment upload completion error.
   */
  constructor() {
    super("Failed to complete attachment upload.", "internal", 500);
    this.name = "AttachmentUploadCompletionError";
  }
}
