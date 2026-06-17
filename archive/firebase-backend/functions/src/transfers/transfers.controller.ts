import {CallableRequest, HttpsError, onCall} from "firebase-functions/https";

import {APP_CONSTANTS} from "../shared/constants/app.constants.js";
import {AppError} from "../shared/errors/app.error.js";
import {ValidationError} from "../shared/errors/validation.error.js";
import {appLogger} from "../shared/utils/logger.js";
import {
  InvalidTransferAmountError,
  SelfTransferError,
  TransferInsufficientFundsError,
  TransferUnauthenticatedError,
  TransferUnauthorizedWalletAccessError,
  TransferWalletNotFoundError,
  UnsupportedTransferCurrencyError,
} from "./transfers.errors.js";
import {TransfersService} from "./transfers.service.js";
import type {
  CreateUserTransferRequest,
  CreateUserTransferResponse,
  TransferRecord,
} from "./transfers.types.js";

/**
 * Controller for the transfers module.
 */
export class TransfersController {
  /**
   * Creates a transfers controller instance.
   * @param {TransfersService} transfersService Transfer service dependency.
   */
  constructor(
    private readonly transfersService: TransfersService =
    new TransfersService(),
  ) {}

  /**
   * Creates a user-to-user transfer.
   * @return {unknown} Callable Firebase function handler.
   */
  createUserTransfer() {
    return onCall<CreateUserTransferRequest>(
      {region: APP_CONSTANTS.region},
      async (request): Promise<CreateUserTransferResponse> => {
        const senderUid = this.requireAuthenticatedUid(request);
        const transfer = this.validateCreateUserTransferRequest(request.data);

        appLogger.info("Create user transfer request received.", {
          event: "transfers.create.requested",
          senderUid,
          sourceWalletId: transfer.sourceWalletId,
          destinationWalletId: transfer.destinationWalletId,
          currency: transfer.currency,
          amount: transfer.amount,
        });

        try {
          return await this.transfersService.createUserTransfer({
            senderUid,
            ...transfer,
          });
        } catch (error) {
          appLogger.error("Create user transfer request failed.", {
            event: "transfers.create.error",
            senderUid,
            sourceWalletId: transfer.sourceWalletId,
            destinationWalletId: transfer.destinationWalletId,
            currency: transfer.currency,
            amount: transfer.amount,
            error: error instanceof Error ? error.message : "unknown_error",
          });
          throw this.toHttpsError(error, "Failed to create user transfer.");
        }
      },
    );
  }

  /**
   * Returns transfers where the authenticated user is sender or receiver.
   * @return {unknown} Callable Firebase function handler.
   */
  getTransfers() {
    return onCall(
      {region: APP_CONSTANTS.region},
      async (request): Promise<TransferRecord[]> => {
        const participantUid = this.requireAuthenticatedUid(request);

        appLogger.info("Get transfers request received.", {
          event: "transfers.list.requested",
          participantUid,
        });

        try {
          return await this.transfersService.getTransfers(participantUid);
        } catch (error) {
          appLogger.error("Get transfers request failed.", {
            event: "transfers.list.error",
            participantUid,
            error: error instanceof Error ? error.message : "unknown_error",
          });
          throw this.toHttpsError(error, "Failed to load transfers.");
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
      throw new TransferUnauthenticatedError();
    }

    return uid;
  }

  /**
   * Validates the create user transfer request input.
   * @param {CreateUserTransferRequest | undefined} data Request payload.
   * @return {object} Normalized transfer payload.
   */
  private validateCreateUserTransferRequest(
    data: CreateUserTransferRequest | undefined,
  ): {
    sourceWalletId: string;
    destinationWalletId: string;
    amount: number;
    currency: string;
  } {
    const sourceWalletId = this.validateWalletId(
      data?.sourceWalletId,
      "sourceWalletId",
    );
    const destinationWalletId = this.validateWalletId(
      data?.destinationWalletId,
      "destinationWalletId",
    );

    if (typeof data?.amount !== "number" || Number.isNaN(data.amount)) {
      throw new ValidationError("A valid amount is required.", {
        field: "amount",
      });
    }

    if (typeof data?.currency !== "string") {
      throw new ValidationError("A valid currency is required.", {
        field: "currency",
      });
    }

    const currency = data.currency.trim().toUpperCase();

    if (!currency) {
      throw new ValidationError("Currency is required.", {
        field: "currency",
      });
    }

    return {
      sourceWalletId,
      destinationWalletId,
      amount: data.amount,
      currency,
    };
  }

  /**
   * Validates a wallet identifier input.
   * @param {unknown} walletId Candidate wallet identifier.
   * @param {string} field Field name for validation errors.
   * @return {string} Normalized wallet identifier.
   */
  private validateWalletId(walletId: unknown, field: string): string {
    if (typeof walletId !== "string") {
      throw new ValidationError(`A valid ${field} is required.`, {field});
    }

    const normalizedWalletId = walletId.trim();

    if (!normalizedWalletId) {
      throw new ValidationError(`${field} is required.`, {field});
    }

    return normalizedWalletId;
  }

  /**
   * Maps internal application errors to callable HTTPS errors.
   * @param {unknown} error Error raised by the transfers layer.
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

    if (error instanceof TransferUnauthenticatedError) {
      return new HttpsError("unauthenticated", error.message, error.details);
    }

    if (error instanceof InvalidTransferAmountError) {
      return new HttpsError("invalid-argument", error.message, error.details);
    }

    if (error instanceof SelfTransferError) {
      return new HttpsError("invalid-argument", error.message, error.details);
    }

    if (error instanceof UnsupportedTransferCurrencyError) {
      return new HttpsError("invalid-argument", error.message, error.details);
    }

    if (error instanceof TransferInsufficientFundsError) {
      return new HttpsError(
        "failed-precondition",
        error.message,
        error.details,
      );
    }

    if (error instanceof TransferWalletNotFoundError) {
      return new HttpsError("not-found", error.message, error.details);
    }

    if (error instanceof TransferUnauthorizedWalletAccessError) {
      return new HttpsError(
        "permission-denied",
        error.message,
        error.details,
      );
    }

    if (error instanceof AppError) {
      return new HttpsError("internal", error.message, error.details);
    }

    return new HttpsError("internal", fallbackMessage);
  }
}
