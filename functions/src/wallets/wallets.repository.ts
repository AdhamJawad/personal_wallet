import {Timestamp, Transaction} from "firebase-admin/firestore";

import {APP_CONSTANTS} from "../shared/constants/app.constants.js";
import {db} from "../shared/firestore/firestore.client.js";
import type {
  CreateExchangeInput,
  CreateDepositInput,
  CreateInternalTransferInput,
  CreateLedgerEntryInput,
  LedgerEntryRecord,
} from "./ledger.types.js";
import type {WalletRecord} from "./wallets.types.js";

/**
 * Repository for wallet persistence operations.
 */
export class WalletsRepository {
  /**
   * Runs a wallet Firestore transaction.
   * @param {Function} operation Transaction callback to execute.
   * @return {Promise<T>} Transaction result.
   */
  async runTransaction<T>(
    operation: (transaction: Transaction) => Promise<T>,
  ): Promise<T> {
    return db.runTransaction(operation);
  }

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
   * Returns a wallet by its identifier within a transaction.
   * @param {Transaction} transaction Active Firestore transaction.
   * @param {string} walletId Wallet document ID.
   * @return {Promise<WalletRecord | null>} Wallet record if it exists.
   */
  async getWalletByIdInTransaction(
    transaction: Transaction,
    walletId: string,
  ): Promise<WalletRecord | null> {
    const collectionName = APP_CONSTANTS.firestore.collections.wallets;
    const snapshot = await transaction.get(
      db.collection(collectionName).doc(walletId),
    );

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
   * Creates a ledger entry inside a transaction.
   * @param {Transaction} transaction Active Firestore transaction.
   * @param {CreateLedgerEntryInput} entry Ledger entry payload.
   * @return {string} Created ledger entry ID.
   */
  createLedgerEntryInTransaction(
    transaction: Transaction,
    entry: CreateLedgerEntryInput,
  ): string {
    const collectionName = APP_CONSTANTS.firestore.collections.ledgerEntries;
    const entryRef = db.collection(collectionName).doc();

    transaction.create(entryRef, {
      entryId: entryRef.id,
      walletId: entry.walletId,
      ownerUid: entry.ownerUid,
      entryType: entry.entryType,
      currency: entry.currency,
      amount: entry.amount,
      referenceId: entry.referenceId,
      metadata: entry.metadata,
      createdAt: Timestamp.now(),
    });

    return entryRef.id;
  }

  /**
   * Creates a deposit ledger entry.
   * @param {CreateDepositInput} deposit Deposit payload.
   * @return {Promise<LedgerEntryRecord>} Created ledger entry record.
   */
  async createDepositEntry(
    deposit: CreateDepositInput,
  ): Promise<LedgerEntryRecord> {
    return this.createLedgerEntry({
      walletId: deposit.walletId,
      ownerUid: deposit.ownerUid,
      entryType: "deposit",
      currency: deposit.currency,
      amount: deposit.amount,
      referenceId: null,
      metadata: {
        reason: deposit.reason ?? null,
      },
    });
  }

  /**
   * Creates both internal transfer ledger entries in one transaction.
   * @param {Transaction} transaction Active Firestore transaction.
   * @param {CreateInternalTransferInput} transfer Transfer payload.
   * @param {string} referenceId Shared transfer reference ID.
   * @return {{outEntryId: string, inEntryId: string}} Created ledger entry IDs.
   */
  createInternalTransferEntries(
    transaction: Transaction,
    transfer: CreateInternalTransferInput,
    referenceId: string,
  ): {outEntryId: string; inEntryId: string} {
    const metadata = {
      reason: transfer.reason ?? null,
      fromWalletId: transfer.fromWalletId,
      toWalletId: transfer.toWalletId,
    };

    const outEntryId = this.createLedgerEntryInTransaction(transaction, {
      walletId: transfer.fromWalletId,
      ownerUid: transfer.ownerUid,
      entryType: "transfer_out",
      currency: transfer.currency,
      amount: transfer.amount,
      referenceId,
      metadata,
    });

    const inEntryId = this.createLedgerEntryInTransaction(transaction, {
      walletId: transfer.toWalletId,
      ownerUid: transfer.ownerUid,
      entryType: "transfer_in",
      currency: transfer.currency,
      amount: transfer.amount,
      referenceId,
      metadata,
    });

    return {outEntryId, inEntryId};
  }

  /**
   * Creates both exchange ledger entries in one transaction.
   * @param {Transaction} transaction Active Firestore transaction.
   * @param {CreateExchangeInput} exchange Exchange payload.
   * @param {string} referenceId Shared exchange reference ID.
   * @param {number} toAmount Calculated destination amount.
   * @return {{outEntryId: string, inEntryId: string}} Created ledger entry IDs.
   */
  createExchangeEntries(
    transaction: Transaction,
    exchange: CreateExchangeInput,
    referenceId: string,
    toAmount: number,
  ): {outEntryId: string; inEntryId: string} {
    const metadata = {
      fromCurrency: exchange.fromCurrency,
      toCurrency: exchange.toCurrency,
      fromAmount: exchange.fromAmount,
      toAmount,
      exchangeRate: exchange.exchangeRate,
    };

    const outEntryId = this.createLedgerEntryInTransaction(transaction, {
      walletId: exchange.walletId,
      ownerUid: exchange.ownerUid,
      entryType: "exchange_out",
      currency: exchange.fromCurrency,
      amount: exchange.fromAmount,
      referenceId,
      metadata,
    });

    const inEntryId = this.createLedgerEntryInTransaction(transaction, {
      walletId: exchange.walletId,
      ownerUid: exchange.ownerUid,
      entryType: "exchange_in",
      currency: exchange.toCurrency,
      amount: toAmount,
      referenceId,
      metadata,
    });

    return {outEntryId, inEntryId};
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
   * Calculates the current balance for a wallet and currency in a transaction.
   * @param {Transaction} transaction Active Firestore transaction.
   * @param {string} walletId Wallet document ID.
   * @param {string} currency Currency code.
   * @return {Promise<number>} Derived balance amount.
   */
  async getWalletBalanceForCurrencyInTransaction(
    transaction: Transaction,
    walletId: string,
    currency: string,
  ): Promise<number> {
    const collectionName = APP_CONSTANTS.firestore.collections.ledgerEntries;
    const snapshot = await transaction.get(
      db.collection(collectionName)
        .where("walletId", "==", walletId)
        .where("currency", "==", currency),
    );

    let balance = 0;

    for (const document of snapshot.docs) {
      const data = document.data();
      balance += this.getSignedAmount({
        entryId: data.entryId as string,
        walletId: data.walletId as string,
        ownerUid: data.ownerUid as string,
        entryType: data.entryType as LedgerEntryRecord["entryType"],
        currency: data.currency as string,
        amount: data.amount as number,
        referenceId: (data.referenceId as string | null) ?? null,
        metadata: (data.metadata as Record<string, unknown>) ?? {},
        createdAt: this.toDate(data.createdAt),
      });
    }

    return balance;
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
