import {Timestamp, Transaction} from "firebase-admin/firestore";

import {APP_CONSTANTS} from "../shared/constants/app.constants.js";
import {db} from "../shared/firestore/firestore.client.js";
import type {
  DebtDirection,
  DebtRecord,
  DebtSettlementRecord,
  DebtStatus,
} from "./debts.types.js";

/**
 * Repository for debt persistence operations.
 */
export class DebtsRepository {
  /**
   * Runs a debt Firestore transaction.
   * @param {Function} operation Transaction callback to execute.
   * @return {Promise<T>} Transaction result.
   */
  async runTransaction<T>(
    operation: (transaction: Transaction) => Promise<T>,
  ): Promise<T> {
    return db.runTransaction(operation);
  }

  /**
   * Creates a debt document.
   * @param {string} ownerUid Firebase Auth UID of the debt owner.
   * @param {string} contactId Related contact document ID.
   * @param {DebtDirection} direction Debt direction.
   * @param {string} currency Currency code.
   * @param {number} amount Original debt amount.
   * @param {string | null} description Optional debt description.
   * @return {Promise<DebtRecord>} Created debt record.
   */
  async createDebt(
    ownerUid: string,
    contactId: string,
    direction: DebtDirection,
    currency: string,
    amount: number,
    description: string | null,
  ): Promise<DebtRecord> {
    const collectionName = APP_CONSTANTS.firestore.collections.debts;
    const debtRef = db.collection(collectionName).doc();
    const createdAt = Timestamp.now();

    await debtRef.create({
      debtId: debtRef.id,
      ownerUid,
      contactId,
      direction,
      currency,
      originalAmount: amount,
      remainingAmount: amount,
      status: APP_CONSTANTS.debts.defaultStatus,
      description,
      createdAt,
      updatedAt: createdAt,
    });

    return {
      debtId: debtRef.id,
      ownerUid,
      contactId,
      direction,
      currency,
      originalAmount: amount,
      remainingAmount: amount,
      status: APP_CONSTANTS.debts.defaultStatus,
      description,
      createdAt: createdAt.toDate(),
      updatedAt: createdAt.toDate(),
    };
  }

  /**
   * Returns debts owned by a user ordered by creation time.
   * @param {string} ownerUid Firebase Auth UID of the debt owner.
   * @return {Promise<DebtRecord[]>} Debt records for the owner.
   */
  async getDebtsByOwner(ownerUid: string): Promise<DebtRecord[]> {
    const collectionName = APP_CONSTANTS.firestore.collections.debts;
    const snapshot = await db.collection(collectionName)
      .where("ownerUid", "==", ownerUid)
      .orderBy("createdAt", "asc")
      .get();

    return snapshot.docs.map((document) => {
      const data = document.data();

      return {
        debtId: data.debtId as string,
        ownerUid: data.ownerUid as string,
        contactId: data.contactId as string,
        direction: data.direction as DebtDirection,
        currency: data.currency as string,
        originalAmount: data.originalAmount as number,
        remainingAmount: data.remainingAmount as number,
        status: data.status as DebtRecord["status"],
        description: (data.description as string | null) ?? null,
        createdAt: this.toDate(data.createdAt),
        updatedAt: this.toDate(data.updatedAt),
      };
    });
  }

  /**
   * Returns a debt by its identifier.
   * @param {string} debtId Debt document ID.
   * @return {Promise<DebtRecord | null>} Debt record if it exists.
   */
  async getDebtById(debtId: string): Promise<DebtRecord | null> {
    const collectionName = APP_CONSTANTS.firestore.collections.debts;
    const snapshot = await db.collection(collectionName).doc(debtId).get();

    if (!snapshot.exists) {
      return null;
    }

    return this.mapDebt(snapshot.data());
  }

  /**
   * Returns a debt by its identifier within a transaction.
   * @param {Transaction} transaction Active Firestore transaction.
   * @param {string} debtId Debt document ID.
   * @return {Promise<DebtRecord | null>} Debt record if it exists.
   */
  async getDebtByIdInTransaction(
    transaction: Transaction,
    debtId: string,
  ): Promise<DebtRecord | null> {
    const collectionName = APP_CONSTANTS.firestore.collections.debts;
    const snapshot = await transaction.get(
      db.collection(collectionName).doc(debtId),
    );

    if (!snapshot.exists) {
      return null;
    }

    return this.mapDebt(snapshot.data());
  }

  /**
   * Creates a settlement document.
   * @param {string} ownerUid Firebase Auth UID of the debt owner.
   * @param {string} debtId Debt document ID.
   * @param {number} amount Settlement amount.
   * @param {string} currency Debt currency.
   * @return {Promise<DebtSettlementRecord>} Created settlement record.
   */
  async createSettlement(
    ownerUid: string,
    debtId: string,
    amount: number,
    currency: string,
  ): Promise<DebtSettlementRecord> {
    const collectionName = APP_CONSTANTS.firestore.collections.debtSettlements;
    const settlementRef = db.collection(collectionName).doc();
    const createdAt = Timestamp.now();

    await settlementRef.create({
      settlementId: settlementRef.id,
      debtId,
      ownerUid,
      amount,
      currency,
      createdAt,
    });

    return {
      settlementId: settlementRef.id,
      debtId,
      ownerUid,
      amount,
      currency,
      createdAt: createdAt.toDate(),
    };
  }

  /**
   * Creates a settlement document inside a transaction.
   * @param {Transaction} transaction Active Firestore transaction.
   * @param {string} ownerUid Firebase Auth UID of the debt owner.
   * @param {string} debtId Debt document ID.
   * @param {number} amount Settlement amount.
   * @param {string} currency Debt currency.
   * @return {DebtSettlementRecord} Created settlement record.
   */
  createSettlementInTransaction(
    transaction: Transaction,
    ownerUid: string,
    debtId: string,
    amount: number,
    currency: string,
  ): DebtSettlementRecord {
    const collectionName = APP_CONSTANTS.firestore.collections.debtSettlements;
    const settlementRef = db.collection(collectionName).doc();
    const createdAt = Timestamp.now();

    transaction.create(settlementRef, {
      settlementId: settlementRef.id,
      debtId,
      ownerUid,
      amount,
      currency,
      createdAt,
    });

    return {
      settlementId: settlementRef.id,
      debtId,
      ownerUid,
      amount,
      currency,
      createdAt: createdAt.toDate(),
    };
  }

  /**
   * Returns settlements for a debt ordered by newest first.
   * @param {string} debtId Debt document ID.
   * @return {Promise<DebtSettlementRecord[]>} Settlement history.
   */
  async getSettlementsByDebt(debtId: string): Promise<DebtSettlementRecord[]> {
    const collectionName = APP_CONSTANTS.firestore.collections.debtSettlements;
    const snapshot = await db.collection(collectionName)
      .where("debtId", "==", debtId)
      .orderBy("createdAt", "desc")
      .get();

    return snapshot.docs.map((document) => {
      const data = document.data();

      return {
        settlementId: data.settlementId as string,
        debtId: data.debtId as string,
        ownerUid: data.ownerUid as string,
        amount: data.amount as number,
        currency: data.currency as string,
        createdAt: this.toDate(data.createdAt),
      };
    });
  }

  /**
   * Updates a debt remaining amount and status.
   * @param {string} debtId Debt document ID.
   * @param {number} remainingAmount Updated remaining amount.
   * @param {DebtStatus} status Updated debt status.
   * @return {Promise<void>} Resolves when the update completes.
   */
  async updateDebtRemainingAmount(
    debtId: string,
    remainingAmount: number,
    status: DebtStatus,
  ): Promise<void> {
    const collectionName = APP_CONSTANTS.firestore.collections.debts;

    await db.collection(collectionName).doc(debtId).update({
      remainingAmount,
      status,
      updatedAt: Timestamp.now(),
    });
  }

  /**
   * Updates a debt remaining amount and status inside a transaction.
   * @param {Transaction} transaction Active Firestore transaction.
   * @param {string} debtId Debt document ID.
   * @param {number} remainingAmount Updated remaining amount.
   * @param {DebtStatus} status Updated debt status.
   * @return {void}
   */
  updateDebtRemainingAmountInTransaction(
    transaction: Transaction,
    debtId: string,
    remainingAmount: number,
    status: DebtStatus,
  ): void {
    const collectionName = APP_CONSTANTS.firestore.collections.debts;

    transaction.update(db.collection(collectionName).doc(debtId), {
      remainingAmount,
      status,
      updatedAt: Timestamp.now(),
    });
  }

  /**
   * Maps Firestore data to a debt record.
   * @param {FirebaseFirestore.DocumentData | undefined} data Firestore data.
   * @return {DebtRecord} Parsed debt record.
   */
  private mapDebt(
    data: FirebaseFirestore.DocumentData | undefined,
  ): DebtRecord {
    return {
      debtId: data?.debtId as string,
      ownerUid: data?.ownerUid as string,
      contactId: data?.contactId as string,
      direction: data?.direction as DebtDirection,
      currency: data?.currency as string,
      originalAmount: data?.originalAmount as number,
      remainingAmount: data?.remainingAmount as number,
      status: data?.status as DebtStatus,
      description: (data?.description as string | null) ?? null,
      createdAt: this.toDate(data?.createdAt),
      updatedAt: this.toDate(data?.updatedAt),
    };
  }

  /**
   * Converts Firestore timestamps and date-like values to Date.
   * @param {unknown} value Firestore timestamp-like value.
   * @return {Date | undefined} Converted date instance.
   */
  private toDate(value: unknown): Date | undefined {
    if (!value) {
      return undefined;
    }

    if (value instanceof Timestamp) {
      return value.toDate();
    }

    if (value instanceof Date) {
      return value;
    }

    return new Date(value as string);
  }
}
