import {AppError} from "./app.error.js";

/**
 * Error used for intentionally unimplemented placeholders.
 */
export class NotImplementedError extends AppError {
  /**
   * Creates a not-implemented error instance.
   * @param {string} message Override error message.
   */
  constructor(message = "Not implemented.") {
    super(message, "not_implemented", 501);
    this.name = "NotImplementedError";
  }
}
