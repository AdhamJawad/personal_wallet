import {HttpsError, onCall} from "firebase-functions/https";

import {APP_CONSTANTS} from "../shared/constants/app.constants.js";
import {AppError} from "../shared/errors/app.error.js";
import {ValidationError} from "../shared/errors/validation.error.js";
import {appLogger} from "../shared/utils/logger.js";
import {
  isValidPhoneNumber,
  maskPhoneNumber,
  normalizePhoneNumber,
} from "../shared/utils/phone.js";
import {
  OtpChallengeExpiredError,
  OtpChallengeNotFoundError,
  OtpChallengeStateError,
  OtpVerificationFailedError,
} from "./auth.errors.js";
import {AuthService} from "./auth.service.js";
import type {
  SendOtpRequest,
  SendOtpResult,
  VerifyOtpRequest,
  VerifyOtpResult,
} from "./auth.types.js";

/**
 * Controller for the auth module.
 */
export class AuthController {
  /**
   * Creates an auth controller instance.
   * @param {AuthService} authService Auth service dependency.
   */
  constructor(private readonly authService: AuthService = new AuthService()) {}

  /**
   * Creates an OTP challenge for a validated phone number.
   * @return {unknown} Callable Firebase function handler.
   */
  sendOtp() {
    return onCall<SendOtpRequest>(
      {region: APP_CONSTANTS.region},
      async (request): Promise<SendOtpResult> => {
        const phoneNumber = this.validatePhoneNumber(request.data?.phoneNumber);

        appLogger.info("OTP challenge request received.", {
          event: "auth.otp.challenge_requested",
          phoneNumberMasked: maskPhoneNumber(phoneNumber),
        });

        try {
          const result = await this.authService.sendOtp(phoneNumber);

          if (result.status === "otp_already_sent") {
            appLogger.info("OTP request returned existing lifecycle state.", {
              event: "auth.otp.challenge_reused",
              retryAfterSeconds: result.retryAfterSeconds,
              phoneNumberMasked: maskPhoneNumber(phoneNumber),
            });
          } else {
            appLogger.info("OTP challenge created successfully.", {
              event: "auth.otp.challenge_completed",
              challengeId: result.challengeId,
              phoneNumberMasked: maskPhoneNumber(phoneNumber),
            });
          }

          return result;
        } catch (error) {
          appLogger.error("OTP challenge creation failed.", {
            event: "auth.otp.challenge_failed",
            phoneNumberMasked: maskPhoneNumber(phoneNumber),
            error: error instanceof Error ? error.message : "unknown_error",
          });

          throw this.toHttpsError(error, "Failed to create OTP challenge.");
        }
      },
    );
  }

  /**
   * Verifies an OTP challenge for a validated phone number.
   * @return {unknown} Callable Firebase function handler.
   */
  verifyOtp() {
    return onCall<VerifyOtpRequest>(
      {region: APP_CONSTANTS.region},
      async (request): Promise<VerifyOtpResult> => {
        const phoneNumber = this.validatePhoneNumber(request.data?.phoneNumber);
        const otp = this.validateOtp(request.data?.otp);

        appLogger.info("OTP verification request received.", {
          event: "auth.otp.verification_requested",
          phoneNumberMasked: maskPhoneNumber(phoneNumber),
        });

        try {
          const result = await this.authService.verifyOtp(phoneNumber, otp);

          appLogger.info("OTP verification completed successfully.", {
            event: "auth.otp.verification_completed",
            phoneNumberMasked: maskPhoneNumber(phoneNumber),
          });

          return result;
        } catch (error) {
          if (error instanceof OtpVerificationFailedError) {
            appLogger.warn("OTP verification rejected.", {
              event: "auth.otp.verification_rejected",
              phoneNumberMasked: maskPhoneNumber(phoneNumber),
              details: error.details,
            });
          } else if (
            error instanceof OtpChallengeExpiredError ||
            error instanceof OtpChallengeStateError ||
            error instanceof OtpChallengeNotFoundError
          ) {
            appLogger.warn("OTP verification failed by challenge state.", {
              event: "auth.otp.verification_state_error",
              phoneNumberMasked: maskPhoneNumber(phoneNumber),
              error: error.message,
              details: error.details,
            });
          } else {
            appLogger.error("OTP verification failed unexpectedly.", {
              event: "auth.otp.verification_error",
              phoneNumberMasked: maskPhoneNumber(phoneNumber),
              error: error instanceof Error ? error.message : "unknown_error",
            });
          }

          throw this.toHttpsError(error, "Failed to verify OTP.");
        }
      },
    );
  }

  /**
   * Validates a phone number value.
   * @param {unknown} phoneNumber Candidate phone number input.
   * @return {string} Normalized E.164 phone number.
   */
  private validatePhoneNumber(phoneNumber: unknown): string {
    if (typeof phoneNumber !== "string") {
      throw new ValidationError(
        "A valid phone number is required.",
        {field: "phoneNumber"},
      );
    }

    const normalizedPhoneNumber = normalizePhoneNumber(phoneNumber);

    if (!isValidPhoneNumber(normalizedPhoneNumber)) {
      throw new ValidationError(
        "Phone number must be a valid E.164 value.",
        {field: "phoneNumber"},
      );
    }

    return normalizedPhoneNumber;
  }

  /**
   * Validates an OTP value.
   * @param {unknown} otp Candidate OTP input.
   * @return {string} Normalized OTP string.
   */
  private validateOtp(otp: unknown): string {
    if (typeof otp !== "string") {
      throw new ValidationError("A valid OTP is required.", {field: "otp"});
    }

    const normalizedOtp = otp.trim();
    const otpPattern = new RegExp(`^\\d{${APP_CONSTANTS.auth.otp.length}}$`);

    if (!otpPattern.test(normalizedOtp)) {
      throw new ValidationError(
        `OTP must be exactly ${APP_CONSTANTS.auth.otp.length} digits.`,
        {field: "otp"},
      );
    }

    return normalizedOtp;
  }

  /**
   * Maps internal application errors to callable HTTPS errors.
   * @param {unknown} error Error raised by the auth layer.
   * @param {string} fallbackMessage Fallback error message.
   * @return {HttpsError} Callable-friendly error response.
   */
  private toHttpsError(error: unknown, fallbackMessage: string): HttpsError {
    if (error instanceof HttpsError) {
      return error;
    }

    if (error instanceof ValidationError) {
      return new HttpsError("invalid-argument", error.message, error.details);
    }

    if (error instanceof OtpChallengeNotFoundError) {
      return new HttpsError("not-found", error.message, error.details);
    }

    if (error instanceof OtpChallengeStateError) {
      return new HttpsError(
        "failed-precondition",
        error.message,
        error.details,
      );
    }

    if (error instanceof OtpChallengeExpiredError) {
      return new HttpsError("deadline-exceeded", error.message, error.details);
    }

    if (error instanceof OtpVerificationFailedError) {
      return new HttpsError("permission-denied", error.message, error.details);
    }

    if (error instanceof AppError) {
      return new HttpsError("internal", error.message, error.details);
    }

    return new HttpsError("internal", fallbackMessage);
  }
}
