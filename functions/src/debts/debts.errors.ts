import {AppError} from "../shared/errors/app.error.js";

/**
 * Error raised when an authenticated Firebase user is required.
 */
export class DebtUnauthenticatedError extends AppError {
  /**
   * Creates an unauthenticated debt access error.
   */
  constructor() {
    super("Authentication is required.", "unauthenticated", 401);
    this.name = "DebtUnauthenticatedError";
  }
}

/**
 * Error raised when a debt amount is invalid.
 */
export class InvalidDebtAmountError extends AppError {
  /**
   * Creates an invalid debt amount error.
   */
  constructor() {
    super("Debt amount must be greater than zero.", "validation_failed", 400);
    this.name = "InvalidDebtAmountError";
  }
}

/**
 * Error raised when a debt direction is invalid.
 */
export class InvalidDebtDirectionError extends AppError {
  /**
   * Creates an invalid debt direction error.
   */
  constructor() {
    super("Debt direction is invalid.", "validation_failed", 400);
    this.name = "InvalidDebtDirectionError";
  }
}

/**
 * Error raised when a referenced contact cannot be found.
 */
export class DebtContactNotFoundError extends AppError {
  /**
   * Creates a contact not found error for debts.
   */
  constructor() {
    super("Contact not found.", "internal", 404);
    this.name = "DebtContactNotFoundError";
  }
}

/**
 * Error raised when a contact is not owned by the authenticated user.
 */
export class DebtUnauthorizedContactError extends AppError {
  /**
   * Creates an unauthorized contact access error for debts.
   */
  constructor() {
    super(
      "You do not have access to this contact.",
      "forbidden",
      403,
    );
    this.name = "DebtUnauthorizedContactError";
  }
}

/**
 * Error raised when a referenced debt cannot be found.
 */
export class DebtNotFoundError extends AppError {
  /**
   * Creates a debt not found error.
   */
  constructor() {
    super("Debt not found.", "internal", 404);
    this.name = "DebtNotFoundError";
  }
}

/**
 * Error raised when a settlement amount is invalid.
 */
export class InvalidSettlementAmountError extends AppError {
  /**
   * Creates an invalid settlement amount error.
   */
  constructor() {
    super(
      "Settlement amount must be greater than zero.",
      "validation_failed",
      400,
    );
    this.name = "InvalidSettlementAmountError";
  }
}

/**
 * Error raised when a settlement exceeds the remaining debt amount.
 */
export class SettlementExceedsRemainingBalanceError extends AppError {
  /**
   * Creates a settlement overflow error.
   */
  constructor() {
    super(
      "Settlement amount exceeds the remaining debt balance.",
      "validation_failed",
      400,
    );
    this.name = "SettlementExceedsRemainingBalanceError";
  }
}

/**
 * Error raised when a settlement is attempted for a non-active debt.
 */
export class DebtAlreadySettledError extends AppError {
  /**
   * Creates a debt already settled error.
   */
  constructor() {
    super("Debt is already settled.", "validation_failed", 400);
    this.name = "DebtAlreadySettledError";
  }
}

/**
 * Error raised when a debt is not owned by the authenticated user.
 */
export class DebtUnauthorizedAccessError extends AppError {
  /**
   * Creates an unauthorized debt access error.
   */
  constructor() {
    super(
      "You do not have access to this debt.",
      "forbidden",
      403,
    );
    this.name = "DebtUnauthorizedAccessError";
  }
}
