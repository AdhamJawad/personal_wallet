import {AppError} from "../shared/errors/app.error.js";

/**
 * Error raised when an authenticated Firebase user is required.
 */
export class WalletUnauthenticatedError extends AppError {
  /**
   * Creates an unauthenticated wallet access error.
   */
  constructor() {
    super("Authentication is required.", "unauthenticated", 401);
    this.name = "WalletUnauthenticatedError";
  }
}

/**
 * Error raised when wallet creation fails.
 */
export class WalletCreationError extends AppError {
  /**
   * Creates a wallet creation error.
   */
  constructor() {
    super("Failed to create wallet.", "internal", 500);
    this.name = "WalletCreationError";
  }
}

/**
 * Error raised when a wallet cannot be found.
 */
export class WalletNotFoundError extends AppError {
  /**
   * Creates a wallet not found error.
   */
  constructor() {
    super("Wallet not found.", "internal", 404);
    this.name = "WalletNotFoundError";
  }
}

/**
 * Error raised when a wallet is not owned by the authenticated user.
 */
export class WalletUnauthorizedError extends AppError {
  /**
   * Creates an unauthorized wallet access error.
   */
  constructor() {
    super("You do not have access to this wallet.", "forbidden", 403);
    this.name = "WalletUnauthorizedError";
  }
}
