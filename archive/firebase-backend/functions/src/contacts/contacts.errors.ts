import {AppError} from "../shared/errors/app.error.js";

/**
 * Error raised when an authenticated Firebase user is required.
 */
export class ContactUnauthenticatedError extends AppError {
  /**
   * Creates an unauthenticated contact access error.
   */
  constructor() {
    super("Authentication is required.", "unauthenticated", 401);
    this.name = "ContactUnauthenticatedError";
  }
}

/**
 * Error raised when a contact name is invalid.
 */
export class InvalidContactNameError extends AppError {
  /**
   * Creates an invalid contact name error.
   */
  constructor() {
    super(
      "A valid contact display name is required.",
      "validation_failed",
      400,
    );
    this.name = "InvalidContactNameError";
  }
}

/**
 * Error raised when the same contact already exists for an owner.
 */
export class DuplicateContactError extends AppError {
  /**
   * Creates a duplicate contact error.
   */
  constructor() {
    super("A matching contact already exists.", "validation_failed", 409);
    this.name = "DuplicateContactError";
  }
}
