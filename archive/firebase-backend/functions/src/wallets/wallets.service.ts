import {AuditService} from "../audit/audit.service.js";
import {NotificationsService} from "../notifications/notifications.service.js";
import {appLogger} from "../shared/utils/logger.js";
import type {
  CreateExchangeInput,
  CreateExchangeResponse,
  CreateDepositInput,
  CreateDepositResponse,
  CreateInternalTransferInput,
  CreateInternalTransferResponse,
  LedgerEntryRecord,
} from "./ledger.types.js";
import {
  InvalidDepositAmountError,
  InvalidExchangeRateError,
  InvalidTransferAmountError,
  InvalidWalletCurrencyError,
  InsufficientFundsError,
  SameCurrencyExchangeError,
  SameWalletTransferError,
  UnsupportedExchangeCurrencyError,
  UnsupportedTransferCurrencyError,
  WalletCreationError,
  WalletNotFoundError,
  WalletUnauthorizedError,
} from "./wallets.errors.js";
import {WalletsRepository} from "./wallets.repository.js";
import type {
  WalletBalancesResponse,
  WalletRecord,
} from "./wallets.types.js";

/**
 * Service for wallet workflows.
 */
export class WalletsService {
  /**
   * Creates a wallets service instance.
   * @param {WalletsRepository} walletsRepository Wallet repository dependency.
   */
  constructor(
    private readonly walletsRepository: WalletsRepository =
    new WalletsRepository(),
    private readonly auditService: AuditService = new AuditService(),
    private readonly notificationsService: NotificationsService =
    new NotificationsService(),
  ) {}

  /**
   * Creates a wallet for the authenticated user.
   * @param {string} ownerUid Firebase Auth UID of the wallet owner.
   * @param {string} name Wallet display name.
   * @return {Promise<WalletRecord>} Created wallet record.
   */
  async createWallet(ownerUid: string, name: string): Promise<WalletRecord> {
    try {
      const wallet = await this.walletsRepository.createWallet(ownerUid, name);

      appLogger.info("Wallet created successfully.", {
        event: "wallets.create.completed",
        ownerUid,
        walletId: wallet.walletId,
      });

      await this.auditService.createAuditLogSafely(
        {
          ownerUid,
          entityType: "wallet",
          entityId: wallet.walletId,
          action: "wallet_created",
          metadata: {},
        },
        {
          sourceEvent: "wallets.create.completed",
          walletId: wallet.walletId,
        },
      );

      return wallet;
    } catch (error) {
      appLogger.error("Wallet creation failed.", {
        event: "wallets.create.failed",
        ownerUid,
        error: error instanceof Error ? error.message : "unknown_error",
      });
      throw new WalletCreationError();
    }
  }

  /**
   * Returns wallets owned by the authenticated user.
   * @param {string} ownerUid Firebase Auth UID of the wallet owner.
   * @return {Promise<WalletRecord[]>} Wallet records.
   */
  async getWallets(ownerUid: string): Promise<WalletRecord[]> {
    return this.walletsRepository.getWalletsByOwner(ownerUid);
  }

  /**
   * Returns ledger entries for a wallet owned by the authenticated user.
   * @param {string} ownerUid Firebase Auth UID of the wallet owner.
   * @param {string} walletId Wallet document ID.
   * @return {Promise<LedgerEntryRecord[]>} Wallet ledger entries.
   */
  async getWalletLedger(
    ownerUid: string,
    walletId: string,
  ): Promise<LedgerEntryRecord[]> {
    await this.assertWalletOwnership(ownerUid, walletId, "wallets.ledger");

    return this.walletsRepository.getWalletLedger(walletId);
  }

  /**
   * Returns derived balances for a wallet owned by the authenticated user.
   * @param {string} ownerUid Firebase Auth UID of the wallet owner.
   * @param {string} walletId Wallet document ID.
   * @return {Promise<WalletBalancesResponse>} Derived wallet balances.
   */
  async getWalletBalances(
    ownerUid: string,
    walletId: string,
  ): Promise<WalletBalancesResponse> {
    await this.assertWalletOwnership(ownerUid, walletId, "wallets.balances");
    const balances = await this.walletsRepository.getWalletBalances(walletId);

    appLogger.info("Wallet balances calculated successfully.", {
      event: "wallets.balances.completed",
      ownerUid,
      walletId,
      currencies: Object.keys(balances),
    });

    return {
      walletId,
      balances,
    };
  }

  /**
   * Creates a deposit ledger entry for an owned wallet.
   * @param {CreateDepositInput} deposit Deposit payload.
   * @return {Promise<CreateDepositResponse>} Deposit creation response.
   */
  async createDeposit(
    deposit: CreateDepositInput,
  ): Promise<CreateDepositResponse> {
    if (deposit.amount <= 0) {
      throw new InvalidDepositAmountError();
    }

    const wallet = await this.assertWalletOwnership(
      deposit.ownerUid,
      deposit.walletId,
      "wallets.deposit",
    );

    if (!wallet.supportedCurrencies.includes(deposit.currency)) {
      appLogger.warn("Unsupported wallet currency for deposit.", {
        event: "wallets.deposit.invalid_currency",
        ownerUid: deposit.ownerUid,
        walletId: deposit.walletId,
        currency: deposit.currency,
      });
      throw new InvalidWalletCurrencyError();
    }

    const ledgerEntry = await this.walletsRepository.createDepositEntry(
      deposit,
    );

    appLogger.info("Deposit ledger entry created successfully.", {
      event: "wallets.deposit.completed",
      ownerUid: deposit.ownerUid,
      walletId: deposit.walletId,
      ledgerEntryId: ledgerEntry.entryId,
      currency: deposit.currency,
      amount: deposit.amount,
    });

    await this.auditService.createAuditLogSafely(
      {
        ownerUid: deposit.ownerUid,
        entityType: "wallet",
        entityId: deposit.walletId,
        action: "deposit_created",
        metadata: {
          currency: deposit.currency,
          amount: deposit.amount,
        },
      },
      {
        sourceEvent: "wallets.deposit.completed",
        walletId: deposit.walletId,
        ledgerEntryId: ledgerEntry.entryId,
      },
    );

    return {
      success: true,
      ledgerEntryId: ledgerEntry.entryId,
    };
  }

  /**
   * Creates an exchange between two currencies inside the same owned wallet.
   * @param {CreateExchangeInput} exchange Exchange payload.
   * @return {Promise<CreateExchangeResponse>} Exchange creation response.
   */
  async createExchange(
    exchange: CreateExchangeInput,
  ): Promise<CreateExchangeResponse> {
    if (exchange.fromCurrency === exchange.toCurrency) {
      throw new SameCurrencyExchangeError();
    }

    if (exchange.fromAmount <= 0) {
      throw new InvalidTransferAmountError();
    }

    if (exchange.exchangeRate <= 0) {
      throw new InvalidExchangeRateError();
    }

    const toAmount = exchange.fromAmount * exchange.exchangeRate;
    const referenceId = crypto.randomUUID();

    await this.walletsRepository.runTransaction(async (transaction) => {
      const wallet = await this.requireOwnedWalletInTransaction(
        transaction,
        exchange.ownerUid,
        exchange.walletId,
        "wallets.exchange",
      );

      if (
        !wallet.supportedCurrencies.includes(exchange.fromCurrency) ||
        !wallet.supportedCurrencies.includes(exchange.toCurrency)
      ) {
        appLogger.warn("Unsupported currency for exchange.", {
          event: "wallets.exchange.invalid_currency",
          ownerUid: exchange.ownerUid,
          walletId: exchange.walletId,
          fromCurrency: exchange.fromCurrency,
          toCurrency: exchange.toCurrency,
        });
        throw new UnsupportedExchangeCurrencyError();
      }

      const availableBalance = await this.walletsRepository
        .getWalletBalanceForCurrencyInTransaction(
          transaction,
          exchange.walletId,
          exchange.fromCurrency,
        );

      if (availableBalance < exchange.fromAmount) {
        appLogger.warn("Insufficient funds for exchange.", {
          event: "wallets.exchange.insufficient_funds",
          ownerUid: exchange.ownerUid,
          walletId: exchange.walletId,
          currency: exchange.fromCurrency,
          availableBalance,
          requestedAmount: exchange.fromAmount,
        });
        throw new InsufficientFundsError();
      }

      this.walletsRepository.createExchangeEntries(
        transaction,
        exchange,
        referenceId,
        toAmount,
      );
    });

    appLogger.info("Exchange ledger entries created successfully.", {
      event: "wallets.exchange.completed",
      ownerUid: exchange.ownerUid,
      walletId: exchange.walletId,
      fromCurrency: exchange.fromCurrency,
      toCurrency: exchange.toCurrency,
      fromAmount: exchange.fromAmount,
      toAmount,
      exchangeRate: exchange.exchangeRate,
      referenceId,
    });

    await this.auditService.createAuditLogSafely(
      {
        ownerUid: exchange.ownerUid,
        entityType: "wallet",
        entityId: exchange.walletId,
        action: "exchange_created",
        metadata: {
          fromCurrency: exchange.fromCurrency,
          toCurrency: exchange.toCurrency,
          fromAmount: exchange.fromAmount,
          toAmount,
        },
      },
      {
        sourceEvent: "wallets.exchange.completed",
        walletId: exchange.walletId,
        referenceId,
      },
    );

    await this.notificationsService.createNotificationSafely(
      {
        ownerUid: exchange.ownerUid,
        type: "exchange_completed",
        title: "Exchange completed",
        body: "Your currency exchange was completed successfully.",
        metadata: {
          fromCurrency: exchange.fromCurrency,
          toCurrency: exchange.toCurrency,
          fromAmount: exchange.fromAmount,
          toAmount,
          referenceId,
        },
      },
      {
        sourceEvent: "wallets.exchange.completed",
        walletId: exchange.walletId,
        referenceId,
      },
    );

    return {
      success: true,
      referenceId,
      fromAmount: exchange.fromAmount,
      toAmount,
    };
  }

  /**
   * Creates an internal transfer between two owned wallets.
   * @param {CreateInternalTransferInput} transfer Transfer payload.
   * @return {Promise<CreateInternalTransferResponse>}
   * Transfer creation response.
   */
  async createInternalTransfer(
    transfer: CreateInternalTransferInput,
  ): Promise<CreateInternalTransferResponse> {
    if (transfer.amount <= 0) {
      throw new InvalidTransferAmountError();
    }

    if (transfer.fromWalletId === transfer.toWalletId) {
      throw new SameWalletTransferError();
    }

    const referenceId = crypto.randomUUID();

    await this.walletsRepository.runTransaction(async (transaction) => {
      const sourceWallet = await this.requireOwnedWalletInTransaction(
        transaction,
        transfer.ownerUid,
        transfer.fromWalletId,
        "wallets.internal_transfer.source",
      );
      const destinationWallet = await this.requireOwnedWalletInTransaction(
        transaction,
        transfer.ownerUid,
        transfer.toWalletId,
        "wallets.internal_transfer.destination",
      );

      if (
        !sourceWallet.supportedCurrencies.includes(transfer.currency) ||
        !destinationWallet.supportedCurrencies.includes(transfer.currency)
      ) {
        appLogger.warn("Unsupported currency for internal transfer.", {
          event: "wallets.internal_transfer.invalid_currency",
          ownerUid: transfer.ownerUid,
          fromWalletId: transfer.fromWalletId,
          toWalletId: transfer.toWalletId,
          currency: transfer.currency,
        });
        throw new UnsupportedTransferCurrencyError();
      }

      const availableBalance = await this.walletsRepository
        .getWalletBalanceForCurrencyInTransaction(
          transaction,
          transfer.fromWalletId,
          transfer.currency,
        );

      if (availableBalance < transfer.amount) {
        appLogger.warn("Insufficient funds for internal transfer.", {
          event: "wallets.internal_transfer.insufficient_funds",
          ownerUid: transfer.ownerUid,
          fromWalletId: transfer.fromWalletId,
          currency: transfer.currency,
          availableBalance,
          requestedAmount: transfer.amount,
        });
        throw new InsufficientFundsError();
      }

      this.walletsRepository.createInternalTransferEntries(
        transaction,
        transfer,
        referenceId,
      );
    });

    appLogger.info("Internal transfer ledger entries created successfully.", {
      event: "wallets.internal_transfer.completed",
      ownerUid: transfer.ownerUid,
      fromWalletId: transfer.fromWalletId,
      toWalletId: transfer.toWalletId,
      currency: transfer.currency,
      amount: transfer.amount,
      referenceId,
    });

    await this.auditService.createAuditLogSafely(
      {
        ownerUid: transfer.ownerUid,
        entityType: "transfer",
        entityId: referenceId,
        action: "internal_transfer_created",
        metadata: {
          currency: transfer.currency,
          amount: transfer.amount,
        },
      },
      {
        sourceEvent: "wallets.internal_transfer.completed",
        fromWalletId: transfer.fromWalletId,
        toWalletId: transfer.toWalletId,
        referenceId,
      },
    );

    return {
      success: true,
      referenceId,
    };
  }

  /**
   * Ensures that a wallet exists and belongs to the authenticated owner.
   * @param {string} ownerUid Firebase Auth UID of the wallet owner.
   * @param {string} walletId Wallet document ID.
   * @param {string} eventPrefix Logging event prefix.
   * @return {Promise<void>} Resolves when ownership is confirmed.
   */
  private async assertWalletOwnership(
    ownerUid: string,
    walletId: string,
    eventPrefix: string,
  ): Promise<WalletRecord> {
    const wallet = await this.walletsRepository.getWalletById(walletId);

    if (!wallet) {
      appLogger.warn("Wallet not found for owned access check.", {
        event: `${eventPrefix}.wallet_not_found`,
        ownerUid,
        walletId,
      });
      throw new WalletNotFoundError();
    }

    if (wallet.ownerUid !== ownerUid) {
      appLogger.warn("Unauthorized wallet access denied.", {
        event: `${eventPrefix}.unauthorized`,
        ownerUid,
        walletId,
        walletOwnerUid: wallet.ownerUid,
      });
      throw new WalletUnauthorizedError();
    }

    return wallet;
  }

  /**
   * Ensures that a wallet exists and belongs to the owner within a transaction.
   * @param {Transaction} transaction Active Firestore transaction.
   * @param {string} ownerUid Firebase Auth UID of the wallet owner.
   * @param {string} walletId Wallet document ID.
   * @param {string} eventPrefix Logging event prefix.
   * @return {Promise<WalletRecord>} Owned wallet record.
   */
  private async requireOwnedWalletInTransaction(
    transaction: import("firebase-admin/firestore").Transaction,
    ownerUid: string,
    walletId: string,
    eventPrefix: string,
  ): Promise<WalletRecord> {
    const wallet = await this.walletsRepository.getWalletByIdInTransaction(
      transaction,
      walletId,
    );

    if (!wallet) {
      appLogger.warn("Wallet not found for transactional ownership check.", {
        event: `${eventPrefix}.wallet_not_found`,
        ownerUid,
        walletId,
      });
      throw new WalletNotFoundError();
    }

    if (wallet.ownerUid !== ownerUid) {
      appLogger.warn("Unauthorized wallet access denied in transaction.", {
        event: `${eventPrefix}.unauthorized`,
        ownerUid,
        walletId,
        walletOwnerUid: wallet.ownerUid,
      });
      throw new WalletUnauthorizedError();
    }

    return wallet;
  }
}
