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

/**
 * Error raised when a deposit amount is invalid.
 */
export class InvalidDepositAmountError extends AppError {
  /**
   * Creates an invalid deposit amount error.
   */
  constructor() {
    super(
      "Deposit amount must be greater than zero.",
      "validation_failed",
      400,
    );
    this.name = "InvalidDepositAmountError";
  }
}

/**
 * Error raised when a currency is not supported by the wallet.
 */
export class InvalidWalletCurrencyError extends AppError {
  /**
   * Creates an invalid wallet currency error.
   */
  constructor() {
    super(
      "Currency is not supported by this wallet.",
      "validation_failed",
      400,
    );
    this.name = "InvalidWalletCurrencyError";
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
 * Error raised when the same wallet is used as both source and destination.
 */
export class SameWalletTransferError extends AppError {
  /**
   * Creates a same-wallet transfer error.
   */
  constructor() {
    super(
      "Source and destination wallets must be different.",
      "validation_failed",
      400,
    );
    this.name = "SameWalletTransferError";
  }
}

/**
 * Error raised when a transfer currency is unsupported.
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
 * Error raised when an exchange rate is invalid.
 */
export class InvalidExchangeRateError extends AppError {
  /**
   * Creates an invalid exchange rate error.
   */
  constructor() {
    super(
      "Exchange rate must be greater than zero.",
      "validation_failed",
      400,
    );
    this.name = "InvalidExchangeRateError";
  }
}

/**
 * Error raised when the same currency is used for both sides of an exchange.
 */
export class SameCurrencyExchangeError extends AppError {
  /**
   * Creates a same-currency exchange error.
   */
  constructor() {
    super(
      "fromCurrency and toCurrency must be different.",
      "validation_failed",
      400,
    );
    this.name = "SameCurrencyExchangeError";
  }
}

/**
 * Error raised when a wallet does not support the requested exchange currency.
 */
export class UnsupportedExchangeCurrencyError extends AppError {
  /**
   * Creates an unsupported exchange currency error.
   */
  constructor() {
    super(
      "Currency is not supported by this wallet.",
      "validation_failed",
      400,
    );
    this.name = "UnsupportedExchangeCurrencyError";
  }
}

/**
 * Error raised when a wallet does not have enough funds.
 */
export class InsufficientFundsError extends AppError {
  /**
   * Creates an insufficient funds error.
   */
  constructor() {
    super("Insufficient funds.", "validation_failed", 400);
    this.name = "InsufficientFundsError";
  }
}
