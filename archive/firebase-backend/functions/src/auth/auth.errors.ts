import {AppError} from "../shared/errors/app.error.js";

/**
 * Error raised when no OTP challenge exists for verification.
 */
export class OtpChallengeNotFoundError extends AppError {
  /**
   * Creates an OTP challenge not found error.
   */
  constructor() {
    super("No OTP challenge was found for this phone number.", "internal", 404);
    this.name = "OtpChallengeNotFoundError";
  }
}

/**
 * Error raised when an OTP challenge is no longer pending.
 */
export class OtpChallengeStateError extends AppError {
  /**
   * Creates an OTP challenge state error.
   * @param {string} status Current challenge status.
   */
  constructor(status: string) {
    super(
      "OTP challenge is not in a verifiable state.",
      "internal",
      409,
      {status},
    );
    this.name = "OtpChallengeStateError";
  }
}

/**
 * Error raised when an OTP challenge has expired.
 */
export class OtpChallengeExpiredError extends AppError {
  /**
   * Creates an OTP challenge expired error.
   */
  constructor() {
    super("OTP challenge has expired.", "internal", 410);
    this.name = "OtpChallengeExpiredError";
  }
}

/**
 * Error raised when OTP verification fails.
 */
export class OtpVerificationFailedError extends AppError {
  /**
   * Creates an OTP verification failed error.
   * @param {number} attempts Attempts used after the failed verification.
   * @param {boolean} locked True when the challenge is now locked.
   */
  constructor(attempts: number, locked: boolean) {
    super(
      locked ? "OTP challenge has been locked." : "OTP verification failed.",
      "internal",
      401,
      {attempts, locked},
    );
    this.name = "OtpVerificationFailedError";
  }
}

/**
 * Error raised when phone identity resolution fails.
 */
export class IdentityResolutionError extends AppError {
  /**
   * Creates an identity resolution error.
   */
  constructor() {
    super("Failed to resolve user identity.", "internal", 500);
    this.name = "IdentityResolutionError";
  }
}

/**
 * Error raised when Firebase Auth user creation fails.
 */
export class AuthUserCreationError extends AppError {
  /**
   * Creates a Firebase Auth user creation error.
   */
  constructor() {
    super("Failed to create Firebase Auth user.", "internal", 500);
    this.name = "AuthUserCreationError";
  }
}

/**
 * Error raised when custom token creation fails.
 */
export class CustomTokenGenerationError extends AppError {
  /**
   * Creates a custom token generation error.
   */
  constructor() {
    super("Failed to generate Firebase custom token.", "internal", 500);
    this.name = "CustomTokenGenerationError";
  }
}

/**
 * Error raised when profile creation fails.
 */
export class UserProfileCreationError extends AppError {
  /**
   * Creates a user profile creation error.
   */
  constructor() {
    super("Failed to create user profile.", "internal", 500);
    this.name = "UserProfileCreationError";
  }
}

/**
 * Error raised when profile lookup fails.
 */
export class UserProfileLookupError extends AppError {
  /**
   * Creates a user profile lookup error.
   */
  constructor() {
    super("Failed to load user profile.", "internal", 500);
    this.name = "UserProfileLookupError";
  }
}
