import {AppError} from "../shared/errors/app.error.js";

/**
 * Error raised when audit log access is attempted without authentication.
 */
export class AuditUnauthorizedAccessError extends AppError {
  /**
   * Creates an unauthorized audit access error.
   */
  constructor() {
    super("Authentication is required.", "unauthenticated", 401);
    this.name = "AuditUnauthorizedAccessError";
  }
}
