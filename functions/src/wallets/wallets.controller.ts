import {CallableRequest, HttpsError, onCall} from "firebase-functions/https";

import {APP_CONSTANTS} from "../shared/constants/app.constants.js";
import {AppError} from "../shared/errors/app.error.js";
import {ValidationError} from "../shared/errors/validation.error.js";
import {appLogger} from "../shared/utils/logger.js";
import {
  InvalidExchangeRateError,
  InvalidDepositAmountError,
  InvalidTransferAmountError,
  InvalidWalletCurrencyError,
  InsufficientFundsError,
  SameCurrencyExchangeError,
  SameWalletTransferError,
  UnsupportedExchangeCurrencyError,
  UnsupportedTransferCurrencyError,
  WalletCreationError,
  WalletNotFoundError,
  WalletUnauthenticatedError,
  WalletUnauthorizedError,
} from "./wallets.errors.js";
import {WalletsService} from "./wallets.service.js";
import type {
  CreateExchangeRequest,
  CreateExchangeResponse,
  CreateDepositRequest,
  CreateDepositResponse,
  CreateInternalTransferRequest,
  CreateInternalTransferResponse,
  LedgerEntryRecord,
} from "./ledger.types.js";
import type {
  CreateWalletRequest,
  GetWalletBalancesRequest,
  GetWalletLedgerRequest,
  WalletBalancesResponse,
  WalletRecord,
} from "./wallets.types.js";

/**
 * Controller for the wallets module.
 */
export class WalletsController {
  /**
   * Creates a wallets controller instance.
   * @param {WalletsService} walletsService Wallet service dependency.
   */
  constructor(
    private readonly walletsService: WalletsService = new WalletsService(),
  ) {}

  /**
   * Creates a wallet for the authenticated user.
   * @return {unknown} Callable Firebase function handler.
   */
  createWallet() {
    return onCall<CreateWalletRequest>(
      {region: APP_CONSTANTS.region},
      async (request): Promise<WalletRecord> => {
        const ownerUid = this.requireAuthenticatedUid(request);
        const name = this.validateWalletName(request.data?.name);

        appLogger.info("Create wallet request received.", {
          event: "wallets.create.requested",
          ownerUid,
        });

        try {
          return await this.walletsService.createWallet(ownerUid, name);
        } catch (error) {
          appLogger.error("Create wallet request failed.", {
            event: "wallets.create.error",
            ownerUid,
            error: error instanceof Error ? error.message : "unknown_error",
          });
          throw this.toHttpsError(error, "Failed to create wallet.");
        }
      },
    );
  }

  /**
   * Creates a deposit ledger entry for an owned wallet.
   * @return {unknown} Callable Firebase function handler.
   */
  createDeposit() {
    return onCall<CreateDepositRequest>(
      {region: APP_CONSTANTS.region},
      async (request): Promise<CreateDepositResponse> => {
        const ownerUid = this.requireAuthenticatedUid(request);
        const deposit = this.validateDepositRequest(request.data);

        appLogger.info("Create deposit request received.", {
          event: "wallets.deposit.requested",
          ownerUid,
          walletId: deposit.walletId,
          currency: deposit.currency,
          amount: deposit.amount,
        });

        try {
          return await this.walletsService.createDeposit({
            ownerUid,
            ...deposit,
          });
        } catch (error) {
          appLogger.error("Create deposit request failed.", {
            event: "wallets.deposit.error",
            ownerUid,
            walletId: deposit.walletId,
            currency: deposit.currency,
            amount: deposit.amount,
            error: error instanceof Error ? error.message : "unknown_error",
          });
          throw this.toHttpsError(error, "Failed to create deposit.");
        }
      },
    );
  }

  /**
   * Creates a manual currency exchange inside an owned wallet.
   * @return {unknown} Callable Firebase function handler.
   */
  createExchange() {
    return onCall<CreateExchangeRequest>(
      {region: APP_CONSTANTS.region},
      async (request): Promise<CreateExchangeResponse> => {
        const ownerUid = this.requireAuthenticatedUid(request);
        const exchange = this.validateExchangeRequest(request.data);

        appLogger.info("Create exchange request received.", {
          event: "wallets.exchange.requested",
          ownerUid,
          walletId: exchange.walletId,
          fromCurrency: exchange.fromCurrency,
          toCurrency: exchange.toCurrency,
          fromAmount: exchange.fromAmount,
          exchangeRate: exchange.exchangeRate,
        });

        try {
          return await this.walletsService.createExchange({
            ownerUid,
            ...exchange,
          });
        } catch (error) {
          appLogger.error("Create exchange request failed.", {
            event: "wallets.exchange.error",
            ownerUid,
            walletId: exchange.walletId,
            fromCurrency: exchange.fromCurrency,
            toCurrency: exchange.toCurrency,
            fromAmount: exchange.fromAmount,
            exchangeRate: exchange.exchangeRate,
            error: error instanceof Error ? error.message : "unknown_error",
          });
          throw this.toHttpsError(error, "Failed to create exchange.");
        }
      },
    );
  }

  /**
   * Creates an internal transfer between two owned wallets.
   * @return {unknown} Callable Firebase function handler.
   */
  createInternalTransfer() {
    return onCall<CreateInternalTransferRequest>(
      {region: APP_CONSTANTS.region},
      async (request): Promise<CreateInternalTransferResponse> => {
        const ownerUid = this.requireAuthenticatedUid(request);
        const transfer = this.validateInternalTransferRequest(request.data);

        appLogger.info("Create internal transfer request received.", {
          event: "wallets.internal_transfer.requested",
          ownerUid,
          fromWalletId: transfer.fromWalletId,
          toWalletId: transfer.toWalletId,
          currency: transfer.currency,
          amount: transfer.amount,
        });

        try {
          return await this.walletsService.createInternalTransfer({
            ownerUid,
            ...transfer,
          });
        } catch (error) {
          appLogger.error("Create internal transfer request failed.", {
            event: "wallets.internal_transfer.error",
            ownerUid,
            fromWalletId: transfer.fromWalletId,
            toWalletId: transfer.toWalletId,
            currency: transfer.currency,
            amount: transfer.amount,
            error: error instanceof Error ? error.message : "unknown_error",
          });
          throw this.toHttpsError(error, "Failed to create internal transfer.");
        }
      },
    );
  }

  /**
   * Returns wallets owned by the authenticated user.
   * @return {unknown} Callable Firebase function handler.
   */
  getWallets() {
    return onCall(
      {region: APP_CONSTANTS.region},
      async (request): Promise<WalletRecord[]> => {
        const ownerUid = this.requireAuthenticatedUid(request);

        appLogger.info("Get wallets request received.", {
          event: "wallets.list.requested",
          ownerUid,
        });

        try {
          return await this.walletsService.getWallets(ownerUid);
        } catch (error) {
          appLogger.error("Get wallets request failed.", {
            event: "wallets.list.error",
            ownerUid,
            error: error instanceof Error ? error.message : "unknown_error",
          });
          throw this.toHttpsError(error, "Failed to load wallets.");
        }
      },
    );
  }

  /**
   * Returns ledger entries for an owned wallet.
   * @return {unknown} Callable Firebase function handler.
   */
  getWalletLedger() {
    return onCall<GetWalletLedgerRequest>(
      {region: APP_CONSTANTS.region},
      async (request): Promise<LedgerEntryRecord[]> => {
        const ownerUid = this.requireAuthenticatedUid(request);
        const walletId = this.validateWalletId(request.data?.walletId);

        appLogger.info("Get wallet ledger request received.", {
          event: "wallets.ledger.requested",
          ownerUid,
          walletId,
        });

        try {
          return await this.walletsService.getWalletLedger(ownerUid, walletId);
        } catch (error) {
          appLogger.error("Get wallet ledger request failed.", {
            event: "wallets.ledger.error",
            ownerUid,
            walletId,
            error: error instanceof Error ? error.message : "unknown_error",
          });
          throw this.toHttpsError(error, "Failed to load wallet ledger.");
        }
      },
    );
  }

  /**
   * Returns derived balances for an owned wallet.
   * @return {unknown} Callable Firebase function handler.
   */
  getWalletBalances() {
    return onCall<GetWalletBalancesRequest>(
      {region: APP_CONSTANTS.region},
      async (request): Promise<WalletBalancesResponse> => {
        const ownerUid = this.requireAuthenticatedUid(request);
        const walletId = this.validateWalletId(request.data?.walletId);

        appLogger.info("Get wallet balances request received.", {
          event: "wallets.balances.requested",
          ownerUid,
          walletId,
        });

        try {
          return await this.walletsService.getWalletBalances(
            ownerUid,
            walletId,
          );
        } catch (error) {
          appLogger.error("Get wallet balances request failed.", {
            event: "wallets.balances.error",
            ownerUid,
            walletId,
            error: error instanceof Error ? error.message : "unknown_error",
          });
          throw this.toHttpsError(error, "Failed to load wallet balances.");
        }
      },
    );
  }

  /**
   * Extracts the authenticated Firebase UID from the callable request.
   * @param {CallableRequest<unknown>} request Callable request.
   * @return {string} Authenticated Firebase UID.
   */
  private requireAuthenticatedUid(request: CallableRequest<unknown>): string {
    const uid = request.auth?.uid;

    if (!uid) {
      throw new WalletUnauthenticatedError();
    }

    return uid;
  }

  /**
   * Validates the wallet name input.
   * @param {unknown} name Candidate wallet name.
   * @return {string} Normalized wallet name.
   */
  private validateWalletName(name: unknown): string {
    if (typeof name !== "string") {
      throw new ValidationError("A valid wallet name is required.", {
        field: "name",
      });
    }

    const normalizedName = name.trim();

    if (!normalizedName) {
      throw new ValidationError("Wallet name is required.", {field: "name"});
    }

    return normalizedName;
  }

  /**
   * Validates the wallet identifier input.
   * @param {unknown} walletId Candidate wallet identifier.
   * @return {string} Normalized wallet identifier.
   */
  private validateWalletId(walletId: unknown): string {
    if (typeof walletId !== "string") {
      throw new ValidationError("A valid walletId is required.", {
        field: "walletId",
      });
    }

    const normalizedWalletId = walletId.trim();

    if (!normalizedWalletId) {
      throw new ValidationError("walletId is required.", {
        field: "walletId",
      });
    }

    return normalizedWalletId;
  }

  /**
   * Validates the deposit request input.
   * @param {CreateDepositRequest | undefined} data Callable request payload.
   * @return {object} Normalized deposit payload.
   */
  private validateDepositRequest(
    data: CreateDepositRequest | undefined,
  ): {walletId: string; currency: string; amount: number; reason?: string} {
    const walletId = this.validateWalletId(data?.walletId);

    if (typeof data?.currency !== "string") {
      throw new ValidationError("A valid currency is required.", {
        field: "currency",
      });
    }

    if (typeof data?.amount !== "number" || Number.isNaN(data.amount)) {
      throw new ValidationError("A valid amount is required.", {
        field: "amount",
      });
    }

    const currency = data.currency.trim().toUpperCase();

    if (!currency) {
      throw new ValidationError("Currency is required.", {
        field: "currency",
      });
    }

    const reason = typeof data.reason === "string" ?
      data.reason.trim() || undefined :
      undefined;

    return {
      walletId,
      currency,
      amount: data.amount,
      reason,
    };
  }

  /**
   * Validates the internal transfer request input.
   * @param {CreateInternalTransferRequest | undefined} data
   * Callable request payload.
   * @return {object} Normalized internal transfer payload.
   */
  private validateInternalTransferRequest(
    data: CreateInternalTransferRequest | undefined,
  ): {
    fromWalletId: string;
    toWalletId: string;
    currency: string;
    amount: number;
    reason?: string;
  } {
    const fromWalletId = this.validateWalletId(data?.fromWalletId);
    const toWalletId = this.validateWalletId(data?.toWalletId);

    if (typeof data?.currency !== "string") {
      throw new ValidationError("A valid currency is required.", {
        field: "currency",
      });
    }

    if (typeof data?.amount !== "number" || Number.isNaN(data.amount)) {
      throw new ValidationError("A valid amount is required.", {
        field: "amount",
      });
    }

    const currency = data.currency.trim().toUpperCase();

    if (!currency) {
      throw new ValidationError("Currency is required.", {
        field: "currency",
      });
    }

    const reason = typeof data.reason === "string" ?
      data.reason.trim() || undefined :
      undefined;

    return {
      fromWalletId,
      toWalletId,
      currency,
      amount: data.amount,
      reason,
    };
  }

  /**
   * Validates the exchange request input.
   * @param {CreateExchangeRequest | undefined} data Callable request payload.
   * @return {object} Normalized exchange payload.
   */
  private validateExchangeRequest(
    data: CreateExchangeRequest | undefined,
  ): {
    walletId: string;
    fromCurrency: string;
    toCurrency: string;
    fromAmount: number;
    exchangeRate: number;
  } {
    const walletId = this.validateWalletId(data?.walletId);

    if (typeof data?.fromCurrency !== "string") {
      throw new ValidationError("A valid fromCurrency is required.", {
        field: "fromCurrency",
      });
    }

    if (typeof data?.toCurrency !== "string") {
      throw new ValidationError("A valid toCurrency is required.", {
        field: "toCurrency",
      });
    }

    if (
      typeof data?.fromAmount !== "number" ||
      Number.isNaN(data.fromAmount)
    ) {
      throw new ValidationError("A valid fromAmount is required.", {
        field: "fromAmount",
      });
    }

    if (
      typeof data?.exchangeRate !== "number" ||
      Number.isNaN(data.exchangeRate)
    ) {
      throw new ValidationError("A valid exchangeRate is required.", {
        field: "exchangeRate",
      });
    }

    const fromCurrency = data.fromCurrency.trim().toUpperCase();
    const toCurrency = data.toCurrency.trim().toUpperCase();

    if (!fromCurrency) {
      throw new ValidationError("fromCurrency is required.", {
        field: "fromCurrency",
      });
    }

    if (!toCurrency) {
      throw new ValidationError("toCurrency is required.", {
        field: "toCurrency",
      });
    }

    return {
      walletId,
      fromCurrency,
      toCurrency,
      fromAmount: data.fromAmount,
      exchangeRate: data.exchangeRate,
    };
  }

  /**
   * Maps internal application errors to callable HTTPS errors.
   * @param {unknown} error Error raised by the wallets layer.
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

    if (error instanceof WalletUnauthenticatedError) {
      return new HttpsError("unauthenticated", error.message, error.details);
    }

    if (error instanceof WalletCreationError) {
      return new HttpsError("internal", error.message, error.details);
    }

    if (error instanceof InvalidDepositAmountError) {
      return new HttpsError("invalid-argument", error.message, error.details);
    }

    if (error instanceof InvalidWalletCurrencyError) {
      return new HttpsError("invalid-argument", error.message, error.details);
    }

    if (error instanceof InvalidTransferAmountError) {
      return new HttpsError("invalid-argument", error.message, error.details);
    }

    if (error instanceof InvalidExchangeRateError) {
      return new HttpsError("invalid-argument", error.message, error.details);
    }

    if (error instanceof SameWalletTransferError) {
      return new HttpsError("invalid-argument", error.message, error.details);
    }

    if (error instanceof SameCurrencyExchangeError) {
      return new HttpsError("invalid-argument", error.message, error.details);
    }

    if (error instanceof UnsupportedTransferCurrencyError) {
      return new HttpsError("invalid-argument", error.message, error.details);
    }

    if (error instanceof UnsupportedExchangeCurrencyError) {
      return new HttpsError("invalid-argument", error.message, error.details);
    }

    if (error instanceof InsufficientFundsError) {
      return new HttpsError(
        "failed-precondition",
        error.message,
        error.details,
      );
    }

    if (error instanceof WalletNotFoundError) {
      return new HttpsError("not-found", error.message, error.details);
    }

    if (error instanceof WalletUnauthorizedError) {
      return new HttpsError("permission-denied", error.message, error.details);
    }

    if (error instanceof AppError) {
      return new HttpsError("internal", error.message, error.details);
    }

    return new HttpsError("internal", fallbackMessage);
  }
}
