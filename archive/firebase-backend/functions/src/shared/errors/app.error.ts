export type ErrorCode =
  | "internal"
  | "not_implemented"
  | "validation_failed"
  | "unauthenticated"
  | "forbidden";

/**
 * Base application error for non-domain-specific failures.
 */
export class AppError extends Error {
  /**
   * Creates an application error instance.
   * @param {string} message Human-readable error message.
   * @param {ErrorCode} code Stable application error code.
   * @param {number} status HTTP-style status code.
   * @param {Record<string, unknown>=} details
   * Optional structured error details.
   */
  constructor(
    message: string,
    public readonly code: ErrorCode = "internal",
    public readonly status: number = 500,
    public readonly details?: Record<string, unknown>,
  ) {
    super(message);
    this.name = "AppError";
  }
}
