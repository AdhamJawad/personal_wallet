import {Timestamp, Transaction} from "firebase-admin/firestore";

import {APP_CONSTANTS} from "../shared/constants/app.constants.js";
import {db} from "../shared/firestore/firestore.client.js";
import type {TransferRecord} from "./transfers.types.js";

/**
 * Repository for transfer persistence operations.
 */
export class TransfersRepository {
  /**
   * Runs a transfer Firestore transaction.
   * @param {Function} operation Transaction callback to execute.
   * @return {Promise<T>} Transaction result.
   */
  async runTransaction<T>(
    operation: (transaction: Transaction) => Promise<T>,
  ): Promise<T> {
    return db.runTransaction(operation);
  }

  /**
   * Creates a transfer document inside a transaction.
   * @param {Transaction} transaction Active Firestore transaction.
   * @param {object} input Transfer payload.
   * @return {TransferRecord} Created transfer record.
   */
  createTransferInTransaction(
    transaction: Transaction,
    input: {
      senderUid: string;
      receiverUid: string;
      sourceWalletId: string;
      destinationWalletId: string;
      currency: string;
      amount: number;
    },
  ): TransferRecord {
    const collectionName = APP_CONSTANTS.firestore.collections.transfers;
    const transferRef = db.collection(collectionName).doc();
    const createdAt = Timestamp.now();

    transaction.create(transferRef, {
      transferId: transferRef.id,
      senderUid: input.senderUid,
      receiverUid: input.receiverUid,
      sourceWalletId: input.sourceWalletId,
      destinationWalletId: input.destinationWalletId,
      currency: input.currency,
      amount: input.amount,
      status: APP_CONSTANTS.transfers.defaultStatus,
      createdAt,
    });

    return {
      transferId: transferRef.id,
      senderUid: input.senderUid,
      receiverUid: input.receiverUid,
      sourceWalletId: input.sourceWalletId,
      destinationWalletId: input.destinationWalletId,
      currency: input.currency,
      amount: input.amount,
      status: APP_CONSTANTS.transfers.defaultStatus,
      createdAt: createdAt.toDate(),
    };
  }

  /**
   * Returns transfers where the user is the sender or receiver.
   * @param {string} participantUid Firebase Auth UID of the participant.
   * @return {Promise<TransferRecord[]>}
   * Transfer records ordered by newest first.
   */
  async getTransfersByParticipant(
    participantUid: string,
  ): Promise<TransferRecord[]> {
    const collectionName = APP_CONSTANTS.firestore.collections.transfers;
    const [sentSnapshot, receivedSnapshot] = await Promise.all([
      db.collection(collectionName)
        .where("senderUid", "==", participantUid)
        .orderBy("createdAt", "desc")
        .get(),
      db.collection(collectionName)
        .where("receiverUid", "==", participantUid)
        .orderBy("createdAt", "desc")
        .get(),
    ]);

    const records = new Map<string, TransferRecord>();

    for (const document of [...sentSnapshot.docs, ...receivedSnapshot.docs]) {
      const data = document.data();
      records.set(document.id, {
        transferId: data.transferId as string,
        senderUid: data.senderUid as string,
        receiverUid: data.receiverUid as string,
        sourceWalletId: data.sourceWalletId as string,
        destinationWalletId: data.destinationWalletId as string,
        currency: data.currency as string,
        amount: data.amount as number,
        status: data.status as TransferRecord["status"],
        createdAt: this.toDate(data.createdAt),
      });
    }

    return [...records.values()].sort((left, right) => {
      const leftTime = left.createdAt?.getTime() ?? 0;
      const rightTime = right.createdAt?.getTime() ?? 0;
      return rightTime - leftTime;
    });
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
