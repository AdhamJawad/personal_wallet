import {AppError} from "./app.error.js";

/**
 * Error used for invalid request input.
 */
export class ValidationError extends AppError {
  /**
   * Creates a validation error instance.
   * @param {string} message Human-readable validation message.
   * @param {Record<string, unknown>=} details Optional validation details.
   */
  constructor(message: string, details?: Record<string, unknown>) {
    super(message, "validation_failed", 400, details);
    this.name = "ValidationError";
  }
}
