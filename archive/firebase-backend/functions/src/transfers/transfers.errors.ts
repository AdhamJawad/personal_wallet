import {AppError} from "../shared/errors/app.error.js";

/**
 * Error raised when an authenticated Firebase user is required.
 */
export class TransferUnauthenticatedError extends AppError {
  /**
   * Creates an unauthenticated transfer access error.
   */
  constructor() {
    super("Authentication is required.", "unauthenticated", 401);
    this.name = "TransferUnauthenticatedError";
  }
}

/**
 * Error raised when a transfer amount is invalid.
 */
export class InvalidTransferAmountError extends AppError {
  /**
   * Creates an invalid transfer amount error.
   */
  constructor() {
    super(
      "Transfer amount must be greater than zero.",
      "validation_failed",
      400,
    );
    this.name = "InvalidTransferAmountError";
  }
}

/**
 * Error raised when a wallet cannot be found.
 */
export class TransferWalletNotFoundError extends AppError {
  /**
   * Creates a transfer wallet not found error.
   */
  constructor() {
    super("Wallet not found.", "internal", 404);
    this.name = "TransferWalletNotFoundError";
  }
}

/**
 * Error raised when a wallet is not owned by the authenticated user.
 */
export class TransferUnauthorizedWalletAccessError extends AppError {
  /**
   * Creates an unauthorized wallet access error.
   */
  constructor() {
    super("You do not have access to this wallet.", "forbidden", 403);
    this.name = "TransferUnauthorizedWalletAccessError";
  }
}

/**
 * Error raised when source and destination wallets belong to the same user.
 */
export class SelfTransferError extends AppError {
  /**
   * Creates a self transfer error.
   */
  constructor() {
    super(
      "Destination wallet must belong to a different user.",
      "validation_failed",
      400,
    );
    this.name = "SelfTransferError";
  }
}

/**
 * Error raised when a wallet does not support the requested currency.
 */
export class UnsupportedTransferCurrencyError extends AppError {
  /**
   * Creates an unsupported transfer currency error.
   */
  constructor() {
    super(
      "Currency is not supported by both wallets.",
      "validation_failed",
      400,
    );
    this.name = "UnsupportedTransferCurrencyError";
  }
}

/**
 * Error raised when a wallet does not have enough funds.
 */
export class TransferInsufficientFundsError extends AppError {
  /**
   * Creates an insufficient funds error.
   */
  constructor() {
    super("Insufficient funds.", "validation_failed", 400);
    this.name = "TransferInsufficientFundsError";
  }
}
