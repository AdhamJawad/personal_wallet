import {
  FieldValue,
  QueryDocumentSnapshot,
  Timestamp,
  Transaction,
} from "firebase-admin/firestore";

import {APP_CONSTANTS} from "../shared/constants/app.constants.js";
import {db} from "../shared/firestore/firestore.client.js";
import type {
  CreateOtpChallengeInput,
  OtpChallengeExpireReason,
  OtpChallengeRecord,
  PhoneIndexRecord,
  UserProfileRecord,
} from "./auth.types.js";

/**
 * Repository for auth persistence operations.
 */
export class AuthRepository {
  /**
   * Runs an auth Firestore transaction.
   * @param {Function} operation Transaction callback to execute.
   * @return {Promise<T>} Transaction result.
   */
  async runTransaction<T>(
    operation: (transaction: Transaction) => Promise<T>,
  ): Promise<T> {
    return db.runTransaction(operation);
  }

  /**
   * Loads a phone index record for a normalized phone number.
   * @param {string} phoneNumber Normalized E.164 phone number.
   * @return {Promise<PhoneIndexRecord | null>} Phone index record.
   */
  async getPhoneIndexByPhoneNumber(
    phoneNumber: string,
  ): Promise<PhoneIndexRecord | null> {
    const collectionName = APP_CONSTANTS.firestore.collections.phoneIndex;
    const snapshot = await db.collection(collectionName).doc(phoneNumber).get();

    if (!snapshot.exists) {
      return null;
    }

    const data = snapshot.data();

    return {
      uid: data?.uid as string,
      phoneNumber: data?.phoneNumber as string,
      createdAt: data?.createdAt ? this.toDate(data.createdAt) : undefined,
    };
  }

  /**
   * Creates a phone index mapping for a phone number.
   * @param {string} uid Firebase Auth UID.
   * @param {string} phoneNumber Normalized E.164 phone number.
   * @return {Promise<void>} Resolves when the mapping is created.
   */
  async createPhoneIndexMapping(
    uid: string,
    phoneNumber: string,
  ): Promise<void> {
    const collectionName = APP_CONSTANTS.firestore.collections.phoneIndex;
    const mappingRef = db.collection(collectionName).doc(phoneNumber);

    await mappingRef.create({
      uid,
      phoneNumber,
      createdAt: FieldValue.serverTimestamp(),
    });
  }

  /**
   * Loads a canonical user profile by UID.
   * @param {string} uid Firebase Auth UID.
   * @return {Promise<UserProfileRecord | null>} User profile record.
   */
  async getUserProfile(uid: string): Promise<UserProfileRecord | null> {
    const collectionName = APP_CONSTANTS.firestore.collections.users;
    const snapshot = await db.collection(collectionName).doc(uid).get();

    if (!snapshot.exists) {
      return null;
    }

    return this.mapUserProfile(uid, snapshot.data());
  }

  /**
   * Creates a canonical user profile document.
   * @param {string} uid Firebase Auth UID.
   * @param {string} phoneNumber Normalized E.164 phone number.
   * @return {Promise<void>} Resolves when the profile is created.
   */
  async createUserProfile(uid: string, phoneNumber: string): Promise<void> {
    const collectionName = APP_CONSTANTS.firestore.collections.users;
    const profileRef = db.collection(collectionName).doc(uid);

    await profileRef.create({
      uid,
      phoneNumber,
      displayName: null,
      emailAddress: null,
      profileImageUrl: null,
      status: "active",
      createdAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
    });
  }

  /**
   * Returns pending challenges for a phone number ordered by newest first.
   * @param {Transaction} transaction Active Firestore transaction.
   * @param {string} phoneNumber Normalized E.164 phone number.
   * @return {Promise<OtpChallengeRecord[]>} Pending challenge records.
   */
  async findPendingChallengesByPhoneNumber(
    transaction: Transaction,
    phoneNumber: string,
  ): Promise<OtpChallengeRecord[]> {
    const collectionName =
      APP_CONSTANTS.firestore.collections.authOtpChallenges;
    const snapshot = await transaction.get(
      db.collection(collectionName)
        .where("phoneNumber", "==", phoneNumber)
        .where("status", "==", APP_CONSTANTS.auth.otp.statusPending)
        .orderBy("createdAt", "desc"),
    );

    return snapshot.docs.map((document) => this.mapOtpChallenge(document));
  }

  /**
   * Returns the latest challenge for a phone number regardless of status.
   * @param {Transaction} transaction Active Firestore transaction.
   * @param {string} phoneNumber Normalized E.164 phone number.
   * @return {Promise<OtpChallengeRecord | null>} Latest challenge record.
   */
  async findLatestChallengeByPhoneNumber(
    transaction: Transaction,
    phoneNumber: string,
  ): Promise<OtpChallengeRecord | null> {
    const collectionName =
      APP_CONSTANTS.firestore.collections.authOtpChallenges;
    const snapshot = await transaction.get(
      db.collection(collectionName)
        .where("phoneNumber", "==", phoneNumber)
        .orderBy("createdAt", "desc")
        .limit(1),
    );

    if (snapshot.empty) {
      return null;
    }

    return this.mapOtpChallenge(snapshot.docs[0]);
  }

  /**
   * Expires an OTP challenge document.
   * @param {Transaction} transaction Active Firestore transaction.
   * @param {string} challengeId Challenge document ID.
   * @param {OtpChallengeExpireReason} reason Lifecycle expire reason.
   * @return {Promise<void>} Resolves when the update is queued.
   */
  async expireChallenge(
    transaction: Transaction,
    challengeId: string,
    reason: OtpChallengeExpireReason,
  ): Promise<void> {
    const collectionName =
      APP_CONSTANTS.firestore.collections.authOtpChallenges;
    const challengeRef = db.collection(collectionName).doc(challengeId);

    transaction.update(challengeRef, {
      status: APP_CONSTANTS.auth.otp.statusExpired,
      expiredAt: FieldValue.serverTimestamp(),
      expireReason: reason,
    });
  }

  /**
   * Updates the attempts count for a challenge.
   * @param {Transaction} transaction Active Firestore transaction.
   * @param {string} challengeId Challenge document ID.
   * @param {number} attempts Updated attempts count.
   * @return {Promise<void>} Resolves when the update is queued.
   */
  async updateChallengeAttempts(
    transaction: Transaction,
    challengeId: string,
    attempts: number,
  ): Promise<void> {
    const collectionName =
      APP_CONSTANTS.firestore.collections.authOtpChallenges;
    const challengeRef = db.collection(collectionName).doc(challengeId);

    transaction.update(challengeRef, {attempts});
  }

  /**
   * Locks a challenge after too many failed attempts.
   * @param {Transaction} transaction Active Firestore transaction.
   * @param {string} challengeId Challenge document ID.
   * @param {number} attempts Updated attempts count.
   * @return {Promise<void>} Resolves when the update is queued.
   */
  async lockChallenge(
    transaction: Transaction,
    challengeId: string,
    attempts: number,
  ): Promise<void> {
    const collectionName =
      APP_CONSTANTS.firestore.collections.authOtpChallenges;
    const challengeRef = db.collection(collectionName).doc(challengeId);

    transaction.update(challengeRef, {
      attempts,
      status: APP_CONSTANTS.auth.otp.statusLocked,
      lockedAt: FieldValue.serverTimestamp(),
    });
  }

  /**
   * Marks a challenge as verified.
   * @param {Transaction} transaction Active Firestore transaction.
   * @param {string} challengeId Challenge document ID.
   * @return {Promise<void>} Resolves when the update is queued.
   */
  async verifyChallenge(
    transaction: Transaction,
    challengeId: string,
  ): Promise<void> {
    const collectionName =
      APP_CONSTANTS.firestore.collections.authOtpChallenges;
    const challengeRef = db.collection(collectionName).doc(challengeId);

    transaction.update(challengeRef, {
      status: APP_CONSTANTS.auth.otp.statusVerified,
      verifiedAt: FieldValue.serverTimestamp(),
    });
  }

  /**
   * Creates a new OTP challenge document within a transaction.
   * @param {Transaction} transaction Active Firestore transaction.
   * @param {CreateOtpChallengeInput} challenge Challenge payload to persist.
   * @return {Promise<string>} Created challenge document ID.
   */
  async createOtpChallenge(
    transaction: Transaction,
    challenge: CreateOtpChallengeInput,
  ): Promise<string> {
    const collectionName =
      APP_CONSTANTS.firestore.collections.authOtpChallenges;
    const challengeRef = db.collection(collectionName).doc();

    transaction.set(challengeRef, {
      ...challenge,
      createdAt: FieldValue.serverTimestamp(),
    });

    return challengeRef.id;
  }

  /**
   * Maps a Firestore document to an OTP challenge record.
   * @param {QueryDocumentSnapshot} document Firestore challenge document.
   * @return {OtpChallengeRecord} Parsed challenge record.
   */
  private mapOtpChallenge(
    document: QueryDocumentSnapshot,
  ): OtpChallengeRecord {
    const data = document.data();

    return {
      id: document.id,
      phoneNumber: data.phoneNumber as string,
      otpHash: data.otpHash as string,
      expiresAt: this.toDate(data.expiresAt),
      createdAt: this.toDate(data.createdAt),
      attempts: data.attempts as number,
      status: data.status as OtpChallengeRecord["status"],
      expiredAt: data.expiredAt ?
        this.toDate(data.expiredAt) :
        undefined,
      expireReason: data.expireReason as OtpChallengeRecord["expireReason"],
      lockedAt: data.lockedAt ?
        this.toDate(data.lockedAt) :
        undefined,
      verifiedAt: data.verifiedAt ?
        this.toDate(data.verifiedAt) :
        undefined,
    };
  }

  /**
   * Maps raw Firestore user profile data to a typed record.
   * @param {string} uid Firebase Auth UID.
   * @param {FirebaseFirestore.DocumentData | undefined} data
   * Firestore user profile data.
   * @return {UserProfileRecord} Parsed user profile.
   */
  private mapUserProfile(
    uid: string,
    data: FirebaseFirestore.DocumentData | undefined,
  ): UserProfileRecord {
    return {
      uid,
      phoneNumber: data?.phoneNumber as string,
      displayName: null,
      emailAddress: null,
      profileImageUrl: null,
      status: "active",
      createdAt: data?.createdAt ? this.toDate(data.createdAt) : undefined,
      updatedAt: data?.updatedAt ? this.toDate(data.updatedAt) : undefined,
    };
  }

  /**
   * Converts Firestore timestamps and date-like values to Date.
   * @param {unknown} value Firestore timestamp-like value.
   * @return {Date} Converted date instance.
   */
  private toDate(value: unknown): Date {
    if (value instanceof Timestamp) {
      return value.toDate();
    }

    if (value instanceof Date) {
      return value;
    }

    return new Date(value as string);
  }
}
