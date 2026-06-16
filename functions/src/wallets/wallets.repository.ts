import {Timestamp} from "firebase-admin/firestore";

import {APP_CONSTANTS} from "../shared/constants/app.constants.js";
import {db} from "../shared/firestore/firestore.client.js";
import type {
  CreateLedgerEntryInput,
  LedgerEntryRecord,
} from "./ledger.types.js";
import type {WalletRecord} from "./wallets.types.js";

/**
 * Repository for wallet persistence operations.
 */
export class WalletsRepository {
  /**
   * Creates a wallet document.
   * @param {string} ownerUid Firebase Auth UID of the wallet owner.
   * @param {string} name Wallet display name.
   * @return {Promise<WalletRecord>} Created wallet record.
   */
  async createWallet(ownerUid: string, name: string): Promise<WalletRecord> {
    const collectionName = APP_CONSTANTS.firestore.collections.wallets;
    const walletRef = db.collection(collectionName).doc();

    await walletRef.create({
      walletId: walletRef.id,
      ownerUid,
      name,
      status: APP_CONSTANTS.wallets.defaultStatus,
      supportedCurrencies: APP_CONSTANTS.wallets.defaultSupportedCurrencies,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    });

    return {
      walletId: walletRef.id,
      ownerUid,
      name,
      status: APP_CONSTANTS.wallets.defaultStatus,
      supportedCurrencies: [
        ...APP_CONSTANTS.wallets.defaultSupportedCurrencies,
      ],
      createdAt: new Date(),
      updatedAt: new Date(),
    };
  }

  /**
   * Returns a wallet by its identifier.
   * @param {string} walletId Wallet document ID.
   * @return {Promise<WalletRecord | null>} Wallet record if it exists.
   */
  async getWalletById(walletId: string): Promise<WalletRecord | null> {
    const collectionName = APP_CONSTANTS.firestore.collections.wallets;
    const snapshot = await db.collection(collectionName).doc(walletId).get();

    if (!snapshot.exists) {
      return null;
    }

    const data = snapshot.data();

    return {
      walletId: data?.walletId as string,
      ownerUid: data?.ownerUid as string,
      name: data?.name as string,
      status: data?.status as WalletRecord["status"],
      supportedCurrencies: data?.supportedCurrencies as string[],
      createdAt: this.toDate(data?.createdAt),
      updatedAt: this.toDate(data?.updatedAt),
    };
  }

  /**
   * Returns wallets owned by a user ordered by creation time.
   * @param {string} ownerUid Firebase Auth UID of the wallet owner.
   * @return {Promise<WalletRecord[]>} Wallet records for the owner.
   */
  async getWalletsByOwner(ownerUid: string): Promise<WalletRecord[]> {
    const collectionName = APP_CONSTANTS.firestore.collections.wallets;
    const snapshot = await db.collection(collectionName)
      .where("ownerUid", "==", ownerUid)
      .orderBy("createdAt", "asc")
      .get();

    return snapshot.docs.map((document) => {
      const data = document.data();

      return {
        walletId: data.walletId as string,
        ownerUid: data.ownerUid as string,
        name: data.name as string,
        status: data.status as WalletRecord["status"],
        supportedCurrencies: data.supportedCurrencies as string[],
        createdAt: this.toDate(data.createdAt),
        updatedAt: this.toDate(data.updatedAt),
      };
    });
  }

  /**
   * Creates a ledger entry document.
   * @param {CreateLedgerEntryInput} entry Ledger entry payload.
   * @return {Promise<LedgerEntryRecord>} Created ledger entry record.
   */
  async createLedgerEntry(
    entry: CreateLedgerEntryInput,
  ): Promise<LedgerEntryRecord> {
    const collectionName = APP_CONSTANTS.firestore.collections.ledgerEntries;
    const entryRef = db.collection(collectionName).doc();
    const createdAt = Timestamp.now();

    await entryRef.create({
      entryId: entryRef.id,
      walletId: entry.walletId,
      ownerUid: entry.ownerUid,
      entryType: entry.entryType,
      currency: entry.currency,
      amount: entry.amount,
      referenceId: entry.referenceId,
      metadata: entry.metadata,
      createdAt,
    });

    return {
      entryId: entryRef.id,
      walletId: entry.walletId,
      ownerUid: entry.ownerUid,
      entryType: entry.entryType,
      currency: entry.currency,
      amount: entry.amount,
      referenceId: entry.referenceId,
      metadata: entry.metadata,
      createdAt: createdAt.toDate(),
    };
  }

  /**
   * Returns ledger entries for a wallet ordered by newest first.
   * @param {string} walletId Wallet document ID.
   * @return {Promise<LedgerEntryRecord[]>} Ledger entries for the wallet.
   */
  async getWalletLedger(walletId: string): Promise<LedgerEntryRecord[]> {
    const collectionName = APP_CONSTANTS.firestore.collections.ledgerEntries;
    const snapshot = await db.collection(collectionName)
      .where("walletId", "==", walletId)
      .orderBy("createdAt", "desc")
      .get();

    return snapshot.docs.map((document) => {
      const data = document.data();

      return {
        entryId: data.entryId as string,
        walletId: data.walletId as string,
        ownerUid: data.ownerUid as string,
        entryType: data.entryType as LedgerEntryRecord["entryType"],
        currency: data.currency as string,
        amount: data.amount as number,
        referenceId: (data.referenceId as string | null) ?? null,
        metadata: (data.metadata as Record<string, unknown>) ?? {},
        createdAt: this.toDate(data.createdAt),
      };
    });
  }

  /**
   * Calculates balances for a wallet from ledger entries only.
   * @param {string} walletId Wallet document ID.
   * @return {Promise<Record<string, number>>} Derived balances by currency.
   */
  async getWalletBalances(walletId: string): Promise<Record<string, number>> {
    const ledgerEntries = await this.getWalletLedger(walletId);
    const balances: Record<string, number> = {};

    for (const entry of ledgerEntries) {
      const direction = this.getSignedAmount(entry);
      balances[entry.currency] = (balances[entry.currency] ?? 0) + direction;
    }

    return balances;
  }

  /**
   * Returns the signed amount for a ledger entry type.
   * @param {LedgerEntryRecord} entry Ledger entry record.
   * @return {number} Signed amount contribution.
   */
  private getSignedAmount(entry: LedgerEntryRecord): number {
    switch (entry.entryType) {
    case "deposit":
    case "transfer_in":
    case "exchange_in":
    case "debt_settlement_in":
      return entry.amount;
    case "withdrawal":
    case "transfer_out":
    case "exchange_out":
    case "debt_settlement_out":
      return -entry.amount;
    }
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
