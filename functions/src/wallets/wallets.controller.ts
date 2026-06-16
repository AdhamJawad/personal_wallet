import {CallableRequest, HttpsError, onCall} from "firebase-functions/https";

import {APP_CONSTANTS} from "../shared/constants/app.constants.js";
import {AppError} from "../shared/errors/app.error.js";
import {ValidationError} from "../shared/errors/validation.error.js";
import {appLogger} from "../shared/utils/logger.js";
import {
  WalletCreationError,
  WalletNotFoundError,
  WalletUnauthenticatedError,
  WalletUnauthorizedError,
} from "./wallets.errors.js";
import {WalletsService} from "./wallets.service.js";
import type {LedgerEntryRecord} from "./ledger.types.js";
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
