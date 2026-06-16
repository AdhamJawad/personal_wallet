import {
  randomBytes,
  randomInt,
  scryptSync,
  timingSafeEqual,
} from "node:crypto";
import {getAuth} from "firebase-admin/auth";

import {APP_CONSTANTS} from "../shared/constants/app.constants.js";
import {appLogger} from "../shared/utils/logger.js";
import {maskPhoneNumber} from "../shared/utils/phone.js";
import {
  AuthUserCreationError,
  CustomTokenGenerationError,
  IdentityResolutionError,
  OtpChallengeExpiredError,
  OtpChallengeNotFoundError,
  OtpChallengeStateError,
  OtpVerificationFailedError,
  UserProfileCreationError,
  UserProfileLookupError,
} from "./auth.errors.js";
import {AuthRepository} from "./auth.repository.js";
import type {
  CreateOtpChallengeInput,
  OtpChallengeRecord,
  SendOtpAlreadySentResult,
  SendOtpResult,
  UserProfileRecord,
  VerifyOtpResult,
} from "./auth.types.js";

interface SendOtpTransactionResult {
  result: SendOtpResult;
  expiredChallengeIds: string[];
  blockedChallengeId?: string;
}

interface VerifyOtpTransactionResult {
  challengeId: string;
  outcome: "verified" | "failed" | "locked";
  attempts: number;
}

interface ResolvedIdentityResult {
  uid: string;
  isNewUser: boolean;
  profile: UserProfileRecord;
}

/**
 * Service for auth workflows.
 */
export class AuthService {
  /**
   * Creates an auth service instance.
   * @param {AuthRepository} authRepository Auth repository dependency.
   */
  constructor(
    private readonly authRepository: AuthRepository = new AuthRepository(),
  ) {}

  /**
   * Creates and stores an OTP challenge.
   * @param {string} phoneNumber Normalized E.164 phone number.
   * @return {Promise<SendOtpResult>} Challenge creation result.
   */
  async sendOtp(phoneNumber: string): Promise<SendOtpResult> {
    const now = new Date();
    const transactionResult = await this.authRepository.runTransaction(
      async (transaction): Promise<SendOtpTransactionResult> => {
        const pendingChallenges =
          await this.authRepository.findPendingChallengesByPhoneNumber(
            transaction,
            phoneNumber,
          );
        const newestPendingChallenge = pendingChallenges[0];
        const duplicatePendingChallenges = pendingChallenges.slice(1);
        const expiredChallengeIds: string[] = [];

        for (const challenge of duplicatePendingChallenges) {
          await this.authRepository.expireChallenge(
            transaction,
            challenge.id,
            "superseded",
          );
          expiredChallengeIds.push(challenge.id);
        }

        if (newestPendingChallenge) {
          if (this.isExpired(newestPendingChallenge, now)) {
            await this.authRepository.expireChallenge(
              transaction,
              newestPendingChallenge.id,
              "ttl_expired",
            );
            expiredChallengeIds.push(newestPendingChallenge.id);
          } else {
            const retryAfterSeconds = this.getRetryAfterSeconds(
              newestPendingChallenge,
              now,
            );

            if (retryAfterSeconds > 0) {
              return {
                result: {
                  status: "otp_already_sent",
                  retryAfterSeconds,
                },
                expiredChallengeIds,
                blockedChallengeId: newestPendingChallenge.id,
              };
            }

            await this.authRepository.expireChallenge(
              transaction,
              newestPendingChallenge.id,
              "superseded",
            );
            expiredChallengeIds.push(newestPendingChallenge.id);
          }
        }

        const challenge = this.buildChallenge(phoneNumber, now);
        const challengeId = await this.authRepository.createOtpChallenge(
          transaction,
          challenge,
        );

        return {
          result: {
            challengeId,
            expiresAt: challenge.expiresAt.toISOString(),
            status: challenge.status,
          },
          expiredChallengeIds,
        };
      },
    );

    this.logSendOtpOutcome(phoneNumber, transactionResult);

    return transactionResult.result;
  }

  /**
   * Verifies an OTP challenge for a phone number.
   * @param {string} phoneNumber Normalized E.164 phone number.
   * @param {string} otp Raw OTP code.
   * @return {Promise<VerifyOtpResult>} Verification result.
   */
  async verifyOtp(
    phoneNumber: string,
    otp: string,
  ): Promise<VerifyOtpResult> {
    const now = new Date();
    const phoneNumberMasked = maskPhoneNumber(phoneNumber);

    try {
      const transactionResult = await this.authRepository.runTransaction(
        async (transaction): Promise<VerifyOtpTransactionResult> => {
          const challenge = await this.authRepository
            .findLatestChallengeByPhoneNumber(transaction, phoneNumber);

          if (!challenge) {
            throw new OtpChallengeNotFoundError();
          }

          if (challenge.status !== APP_CONSTANTS.auth.otp.statusPending) {
            throw new OtpChallengeStateError(challenge.status);
          }

          if (this.isExpired(challenge, now)) {
            await this.authRepository.expireChallenge(
              transaction,
              challenge.id,
              "ttl_expired",
            );
            throw new OtpChallengeExpiredError();
          }

          if (!this.verifyOtpHash(otp, challenge.otpHash)) {
            const attempts = challenge.attempts + 1;

            if (attempts >= APP_CONSTANTS.auth.otp.maxAttempts) {
              await this.authRepository.lockChallenge(
                transaction,
                challenge.id,
                attempts,
              );

              return {
                challengeId: challenge.id,
                outcome: "locked",
                attempts,
              };
            }

            await this.authRepository.updateChallengeAttempts(
              transaction,
              challenge.id,
              attempts,
            );

            return {
              challengeId: challenge.id,
              outcome: "failed",
              attempts,
            };
          }

          await this.authRepository.verifyChallenge(transaction, challenge.id);

          return {
            challengeId: challenge.id,
            outcome: "verified",
            attempts: challenge.attempts,
          };
        },
      );

      this.logVerifyOtpOutcome(phoneNumberMasked, transactionResult);

      if (transactionResult.outcome === "locked") {
        throw new OtpVerificationFailedError(transactionResult.attempts, true);
      }

      if (transactionResult.outcome === "failed") {
        throw new OtpVerificationFailedError(transactionResult.attempts, false);
      }

      const identity = await this.resolveIdentityByPhoneNumber(phoneNumber);
      const customToken = await this.generateCustomToken(identity.uid);

      return {
        status: "verified",
        isNewUser: identity.isNewUser,
        uid: identity.uid,
        customToken,
        profile: identity.profile,
      };
    } catch (error) {
      if (error instanceof OtpChallengeExpiredError) {
        appLogger.warn("Expired OTP challenge encountered during verify.", {
          event: "auth.otp.verification_expired",
          phoneNumberMasked,
        });
      }

      throw error;
    }
  }

  /**
   * Generates a numeric OTP.
   * @return {string} Fixed-length OTP code.
   */
  private generateOtp(): string {
    const otpLength = APP_CONSTANTS.auth.otp.length;
    const lowerBound = 10 ** (otpLength - 1);
    const upperBound = 10 ** otpLength;

    return String(randomInt(lowerBound, upperBound));
  }

  /**
   * Hashes an OTP with a random salt for secure storage.
   * @param {string} otpCode Raw OTP code.
   * @return {string} Encoded salted hash.
   */
  private hashOtp(otpCode: string): string {
    const salt = randomBytes(16).toString("hex");
    const hash = scryptSync(otpCode, salt, 64).toString("hex");

    return `${salt}:${hash}`;
  }

  /**
   * Verifies a raw OTP against the stored salted hash.
   * @param {string} otpCode Raw OTP code.
   * @param {string} storedHash Encoded salted hash value.
   * @return {boolean} True when the OTP matches.
   */
  private verifyOtpHash(otpCode: string, storedHash: string): boolean {
    const [salt, expectedHash] = storedHash.split(":");

    if (!salt || !expectedHash) {
      return false;
    }

    const candidateHash = scryptSync(otpCode, salt, 64).toString("hex");

    if (candidateHash.length !== expectedHash.length) {
      return false;
    }

    return timingSafeEqual(
      Buffer.from(candidateHash, "hex"),
      Buffer.from(expectedHash, "hex"),
    );
  }

  /**
   * Resolves or creates the canonical Firebase identity for a phone number.
   * @param {string} phoneNumber Normalized E.164 phone number.
   * @return {Promise<ResolvedIdentityResult>} Resolved identity result.
   */
  private async resolveIdentityByPhoneNumber(
    phoneNumber: string,
  ): Promise<ResolvedIdentityResult> {
    const phoneNumberMasked = maskPhoneNumber(phoneNumber);
    const existingMapping = await this.authRepository
      .getPhoneIndexByPhoneNumber(phoneNumber);

    if (existingMapping) {
      appLogger.info("Resolved existing phone identity.", {
        event: "auth.identity.existing_user_login",
        phoneNumberMasked,
        uid: existingMapping.uid,
      });

      return {
        uid: existingMapping.uid,
        isNewUser: false,
        profile: await this.ensureUserProfile(
          existingMapping.uid,
          phoneNumber,
        ),
      };
    }

    let createdUid: string | null = null;

    try {
      const authUser = await getAuth().createUser({phoneNumber});
      createdUid = authUser.uid;

      appLogger.info("Created new Firebase Auth user.", {
        event: "auth.identity.new_user_created",
        phoneNumberMasked,
        uid: createdUid,
      });
    } catch (error) {
      appLogger.error("Firebase Auth user creation failed.", {
        event: "auth.identity.user_creation_failed",
        phoneNumberMasked,
        error: error instanceof Error ? error.message : "unknown_error",
      });
      throw new AuthUserCreationError();
    }

    try {
      await this.authRepository.createPhoneIndexMapping(
        createdUid,
        phoneNumber,
      );

      return {
        uid: createdUid,
        isNewUser: true,
        profile: await this.createAndLoadUserProfile(createdUid, phoneNumber),
      };
    } catch (error) {
      const resolvedMapping = await this.authRepository
        .getPhoneIndexByPhoneNumber(phoneNumber);

      if (resolvedMapping) {
        await this.cleanupAuthUser(createdUid);

        appLogger.info("Resolved phone identity after mapping race.", {
          event: "auth.identity.existing_user_login",
          phoneNumberMasked,
          uid: resolvedMapping.uid,
        });

        return {
          uid: resolvedMapping.uid,
          isNewUser: false,
          profile: await this.ensureUserProfile(
            resolvedMapping.uid,
            phoneNumber,
          ),
        };
      }

      await this.cleanupAuthUser(createdUid);

      appLogger.error("Phone index mapping creation failed.", {
        event: "auth.identity.mapping_failed",
        phoneNumberMasked,
        uid: createdUid,
        error: error instanceof Error ? error.message : "unknown_error",
      });

      throw new IdentityResolutionError();
    }
  }

  /**
   * Ensures that a canonical user profile exists and returns it.
   * @param {string} uid Firebase Auth UID.
   * @param {string} phoneNumber Normalized E.164 phone number.
   * @return {Promise<UserProfileRecord>} Canonical user profile.
   */
  private async ensureUserProfile(
    uid: string,
    phoneNumber: string,
  ): Promise<UserProfileRecord> {
    const phoneNumberMasked = maskPhoneNumber(phoneNumber);

    try {
      const existingProfile = await this.authRepository.getUserProfile(uid);

      if (existingProfile) {
        appLogger.info("Loaded existing canonical user profile.", {
          event: "auth.profile.existing_loaded",
          phoneNumberMasked,
          uid,
        });

        return existingProfile;
      }
    } catch (error) {
      appLogger.error("User profile lookup failed.", {
        event: "auth.profile.lookup_failed",
        phoneNumberMasked,
        uid,
        error: error instanceof Error ? error.message : "unknown_error",
      });
      throw new UserProfileLookupError();
    }

    return this.createAndLoadUserProfile(uid, phoneNumber);
  }

  /**
   * Creates a canonical user profile and returns the loaded document.
   * @param {string} uid Firebase Auth UID.
   * @param {string} phoneNumber Normalized E.164 phone number.
   * @return {Promise<UserProfileRecord>} Created canonical user profile.
   */
  private async createAndLoadUserProfile(
    uid: string,
    phoneNumber: string,
  ): Promise<UserProfileRecord> {
    const phoneNumberMasked = maskPhoneNumber(phoneNumber);

    try {
      await this.authRepository.createUserProfile(uid, phoneNumber);

      appLogger.info("Created canonical user profile.", {
        event: "auth.profile.created",
        phoneNumberMasked,
        uid,
      });
    } catch (error) {
      const existingProfile = await this.loadExistingProfileAfterCreateFailure(
        uid,
        phoneNumber,
      );

      if (existingProfile) {
        appLogger.info("Loaded canonical user profile after create race.", {
          event: "auth.profile.recovered_after_race",
          phoneNumberMasked,
          uid,
        });

        return existingProfile;
      }

      appLogger.error("User profile creation failed.", {
        event: "auth.profile.create_failed",
        phoneNumberMasked,
        uid,
        error: error instanceof Error ? error.message : "unknown_error",
      });
      throw new UserProfileCreationError();
    }

    const createdProfile = await this.authRepository.getUserProfile(uid);

    if (!createdProfile) {
      appLogger.error("Created user profile could not be loaded.", {
        event: "auth.profile.post_create_lookup_failed",
        phoneNumberMasked,
        uid,
      });
      throw new UserProfileLookupError();
    }

    return createdProfile;
  }

  /**
   * Attempts to recover an existing profile after a create conflict.
   * @param {string} uid Firebase Auth UID.
   * @param {string} phoneNumber Normalized E.164 phone number.
   * @return {Promise<UserProfileRecord | null>} Existing profile if found.
   */
  private async loadExistingProfileAfterCreateFailure(
    uid: string,
    phoneNumber: string,
  ): Promise<UserProfileRecord | null> {
    try {
      return await this.authRepository.getUserProfile(uid);
    } catch (error) {
      appLogger.error("User profile recovery lookup failed.", {
        event: "auth.profile.recovery_lookup_failed",
        phoneNumberMasked: maskPhoneNumber(phoneNumber),
        uid,
        error: error instanceof Error ? error.message : "unknown_error",
      });
      return null;
    }
  }

  /**
   * Generates a Firebase custom token for an existing UID.
   * @param {string} uid Firebase Auth UID.
   * @return {Promise<string>} Firebase custom token.
   */
  private async generateCustomToken(uid: string): Promise<string> {
    try {
      const customToken = await getAuth().createCustomToken(uid);

      appLogger.info("Generated Firebase custom token.", {
        event: "auth.identity.custom_token_generated",
        uid,
      });

      return customToken;
    } catch (error) {
      appLogger.error("Firebase custom token generation failed.", {
        event: "auth.identity.custom_token_failed",
        uid,
        error: error instanceof Error ? error.message : "unknown_error",
      });
      throw new CustomTokenGenerationError();
    }
  }

  /**
   * Best-effort cleanup for orphaned Firebase Auth users after mapping failure.
   * @param {string} uid Firebase Auth UID to remove.
   * @return {Promise<void>} Resolves when cleanup completes.
   */
  private async cleanupAuthUser(uid: string): Promise<void> {
    try {
      await getAuth().deleteUser(uid);
    } catch (error) {
      appLogger.warn("Failed to clean up Firebase Auth user.", {
        event: "auth.identity.cleanup_failed",
        uid,
        error: error instanceof Error ? error.message : "unknown_error",
      });
    }
  }

  /**
   * Builds a new OTP challenge payload.
   * @param {string} phoneNumber Normalized E.164 phone number.
   * @param {Date} createdAt Challenge creation timestamp.
   * @return {CreateOtpChallengeInput} Challenge payload.
   */
  private buildChallenge(
    phoneNumber: string,
    createdAt: Date,
  ): CreateOtpChallengeInput {
    const expiresAt = new Date(
      createdAt.getTime() +
        APP_CONSTANTS.auth.otp.expiresInMinutes * 60 * 1000,
    );
    const otpCode = this.generateOtp();
    const otpHash = this.hashOtp(otpCode);

    return {
      phoneNumber,
      otpHash,
      expiresAt,
      attempts: 0,
      status: APP_CONSTANTS.auth.otp.statusPending,
    };
  }

  /**
   * Returns true when the challenge has exceeded its expiry.
   * @param {OtpChallengeRecord} challenge Existing OTP challenge.
   * @param {Date} now Current timestamp.
   * @return {boolean} True when the challenge is expired.
   */
  private isExpired(challenge: OtpChallengeRecord, now: Date): boolean {
    return challenge.expiresAt.getTime() <= now.getTime();
  }

  /**
   * Calculates the cooldown wait time for a pending challenge.
   * @param {OtpChallengeRecord} challenge Existing OTP challenge.
   * @param {Date} now Current timestamp.
   * @return {number} Remaining cooldown in seconds.
   */
  private getRetryAfterSeconds(
    challenge: OtpChallengeRecord,
    now: Date,
  ): number {
    const cooldownEndsAt = new Date(
      challenge.createdAt.getTime() +
        APP_CONSTANTS.auth.otp.cooldownSeconds * 1000,
    );
    const remainingMs = cooldownEndsAt.getTime() - now.getTime();

    if (remainingMs <= 0) {
      return 0;
    }

    return Math.ceil(remainingMs / 1000);
  }

  /**
   * Writes structured logs for the OTP lifecycle outcome.
   * @param {string} phoneNumber Normalized E.164 phone number.
   * @param {SendOtpTransactionResult} transactionResult Final lifecycle result.
   * @return {void}
   */
  private logSendOtpOutcome(
    phoneNumber: string,
    transactionResult: SendOtpTransactionResult,
  ): void {
    const phoneNumberMasked = maskPhoneNumber(phoneNumber);

    if (transactionResult.expiredChallengeIds.length > 0) {
      appLogger.info("Expired older OTP challenges before issuing a new one.", {
        event: "auth.otp.challenge_expired",
        phoneNumberMasked,
        expiredChallengeIds: transactionResult.expiredChallengeIds,
      });
    }

    if (transactionResult.result.status === "otp_already_sent") {
      const result = transactionResult.result as SendOtpAlreadySentResult;

      appLogger.info("OTP request blocked by cooldown.", {
        event: "auth.otp.challenge_blocked",
        phoneNumberMasked,
        blockedChallengeId: transactionResult.blockedChallengeId,
        retryAfterSeconds: result.retryAfterSeconds,
      });

      return;
    }

    appLogger.info("OTP challenge persisted.", {
      event: "auth.otp.challenge_created",
      phoneNumberMasked,
      challengeId: transactionResult.result.challengeId,
      expiresAt: transactionResult.result.expiresAt,
    });
  }

  /**
   * Writes structured logs for the OTP verification outcome.
   * @param {string} phoneNumberMasked Masked phone number for logs.
   * @param {VerifyOtpTransactionResult} transactionResult Verification result.
   * @return {void}
   */
  private logVerifyOtpOutcome(
    phoneNumberMasked: string,
    transactionResult: VerifyOtpTransactionResult,
  ): void {
    if (transactionResult.outcome === "verified") {
      appLogger.info("OTP verified successfully.", {
        event: "auth.otp.verification_succeeded",
        phoneNumberMasked,
        challengeId: transactionResult.challengeId,
      });
      return;
    }

    if (transactionResult.outcome === "locked") {
      appLogger.warn("OTP challenge locked after failed attempts.", {
        event: "auth.otp.challenge_locked",
        phoneNumberMasked,
        challengeId: transactionResult.challengeId,
        attempts: transactionResult.attempts,
      });
      return;
    }

    appLogger.warn("OTP verification failed.", {
      event: "auth.otp.verification_failed",
      phoneNumberMasked,
      challengeId: transactionResult.challengeId,
      attempts: transactionResult.attempts,
    });
  }
}
